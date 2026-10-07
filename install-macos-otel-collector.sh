#!/usr/bin/env bash
#
# install the opentelemetry collector (contrib distribution) as a launchd daemon on macos.
#
# usage:
#   ./install-macos-otel-collector.sh <path-to-mtls.zip>
#   ./install-macos-otel-collector.sh --uninstall
#   ./install-macos-otel-collector.sh --start | --stop | --status
#
# the zip must contain: config.yaml ca.crt client.crt client.key bundle.pem
# config.yaml from the zip is only read to pull the otlp exporter endpoint out of it;
# a macos-appropriate config is generated here (the vendor config assumes linux).
#
# env overrides:
#   OTEL_ENDPOINT       otlp endpoint, instead of the one in the zip's config.yaml
#   OTEL_VERSION        collector version, instead of the latest release
#   OTEL_DOCKER=0       never collect docker container metrics
#   OTEL_UNIFIED_LOG=0  do not collect the macos unified log
#   OTEL_LOG_PREDICATE  nspredicate for the unified log receiver
#
# https://github.com/open-telemetry/opentelemetry-collector/blob/main/docs/platform-support.md

set -e

LABEL="io.opentelemetry.otelcol-contrib"
BIN="/usr/local/bin/otelcol-contrib"
LAUNCHER="/usr/local/bin/otelcol-contrib-launch"
CONF_DIR="/etc/otelcol-contrib"
CERT_DIR="${CONF_DIR}/certs"
CONF="${CONF_DIR}/config.yaml"
CONF_DOCKER="${CONF_DIR}/config-docker.yaml"
STATE_DIR="/var/lib/otelcol-contrib"
PLIST="/Library/LaunchDaemons/${LABEL}.plist"
LOG="/var/log/otelcol-contrib.log"
ERR="/var/log/otelcol-contrib.err"
DOCKER_SOCK="/var/run/docker.sock"
REPO="open-telemetry/opentelemetry-collector-releases"

# error-level unified log events, minus the two loudest sources on macos.
# /kernel alone emits ~50/sec of IOSurface noise. tune with OTEL_LOG_PREDICATE.
DEFAULT_LOG_PREDICATE='eventType == "logEvent" AND logType == "error" AND processImagePath != "/kernel" AND processImagePath != "/Applications/Parsec.app/Contents/MacOS/parsecd" AND NOT (subsystem BEGINSWITH "com.apple.icloud.searchpartyd")'
LOG_PREDICATE="${OTEL_LOG_PREDICATE:-$DEFAULT_LOG_PREDICATE}"

usage() {
  sed -n '3,21p' "$0" | sed 's/^# \{0,1\}//'
  exit 1
}

stop_daemon() {
  if sudo launchctl print "system/${LABEL}" &>/dev/null; then
    echo "stopping ${LABEL}"
    sudo launchctl bootout "system/${LABEL}"
  fi
}

start_daemon() {
  echo "loading ${LABEL}"
  sudo launchctl enable "system/${LABEL}"
  sudo launchctl bootstrap system "$PLIST"
}

case "${1:-}" in
  --stop)
    stop_daemon
    exit 0
    ;;
  --start)
    [ -f "$PLIST" ] || { echo "not installed: ${PLIST}"; exit 1; }
    stop_daemon
    start_daemon
    exit 0
    ;;
  --status)
    sudo launchctl print "system/${LABEL}" 2>/dev/null | grep -E 'state =|active count|program =' || echo "not loaded"
    exit 0
    ;;
  --uninstall)
    stop_daemon
    sudo rm -fv "$PLIST" "$BIN" "$LAUNCHER"
    sudo rm -rfv "$CONF_DIR" "$STATE_DIR"
    echo "uninstalled (logs left at ${LOG} ${ERR})"
    exit 0
    ;;
  ""|-h|--help)
    usage
    ;;
esac

ZIP="$1"
[ -f "$ZIP" ] || { echo "no such file: ${ZIP}"; exit 1; }

for dep in curl tar unzip awk sudo; do
  command -v "$dep" >/dev/null || { echo "missing dependency: ${dep}"; exit 1; }
done

[ "$(uname -s)" = "Darwin" ] || { echo "this script is macos only"; exit 1; }

case "$(uname -m)" in
  arm64)  ARCH="darwin_arm64" ;;
  x86_64) ARCH="darwin_amd64" ;;
  *) echo "unsupported architecture: $(uname -m)"; exit 1 ;;
esac

# ---------------------------------------------------------------- unpack the zip

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

unzip -o -q -j "$ZIP" -d "$WORK"

for f in config.yaml ca.crt client.crt client.key bundle.pem; do
  [ -f "${WORK}/${f}" ] || { echo "zip is missing ${f}"; exit 1; }
done

# pull the first endpoint under the top level exporters: block
ENDPOINT="${OTEL_ENDPOINT:-$(awk '
  /^[^[:space:]#]/ { section = $1; sub(/:$/, "", section) }
  section == "exporters" && $1 == "endpoint:" { gsub(/["\x27]/, "", $2); print $2; exit }
' "${WORK}/config.yaml")}"

[ -n "$ENDPOINT" ] || { echo "could not find an otlp exporter endpoint in config.yaml (set OTEL_ENDPOINT to override)"; exit 1; }
echo "otlp endpoint: ${ENDPOINT}"

# ---------------------------------------------------------------- install binary

VERSION="${OTEL_VERSION:-$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" \
  | awk -F'"' '/"tag_name"/ && !v { sub(/^v/, "", $4); v = $4 } END { print v }')}"

[ -n "$VERSION" ] || { echo "could not determine latest release (set OTEL_VERSION to override)"; exit 1; }
echo "installing otelcol-contrib ${VERSION} (${ARCH})"

TARBALL="otelcol-contrib_${VERSION}_${ARCH}.tar.gz"
curl -fL --progress-bar \
  "https://github.com/${REPO}/releases/download/v${VERSION}/${TARBALL}" \
  -o "${WORK}/${TARBALL}"

tar -xzf "${WORK}/${TARBALL}" -C "$WORK" otelcol-contrib

stop_daemon

sudo install -m 0755 -o root -g wheel "${WORK}/otelcol-contrib" "$BIN"

# ---------------------------------------------------------------- install certs

sudo install -d -m 0755 -o root -g wheel "$CONF_DIR"
sudo install -d -m 0700 -o root -g wheel "$CERT_DIR"
sudo install -d -m 0750 -o root -g wheel "$STATE_DIR"

sudo install -m 0644 -o root -g wheel "${WORK}/ca.crt"     "${CERT_DIR}/ca.crt"
sudo install -m 0644 -o root -g wheel "${WORK}/client.crt" "${CERT_DIR}/client.crt"
sudo install -m 0644 -o root -g wheel "${WORK}/bundle.pem" "${CERT_DIR}/bundle.pem"
sudo install -m 0600 -o root -g wheel "${WORK}/client.key" "${CERT_DIR}/client.key"

# keep the vendor config around for reference, it is not what we run
sudo install -m 0644 -o root -g wheel "${WORK}/config.yaml" "${CONF_DIR}/config.yaml.vendor"

# ---------------------------------------------------------------- generate config

# the macos unified log receiver replays the previous 24h on every start, so it is
# easy to turn off entirely. the receiver exposes no lookback setting.
UNIFIED_LOG_RECEIVER=""
UNIFIED_LOG_PIPELINE_BLOCK=""
if [ "${OTEL_UNIFIED_LOG:-1}" != "0" ]; then
  UNIFIED_LOG_RECEIVER="  macos_unified_logging:
    predicate: '${LOG_PREDICATE}'"
  # its own pipeline, so the backfill filter applies only to the unified log and
  # cannot drop legitimately older records arriving over otlp or from file_log
  UNIFIED_LOG_PIPELINE_BLOCK="    logs/unified:
      receivers: [macos_unified_logging]
      processors: [memory_limiter, filter/backfill, resource_detection, batch]
      exporters: [otlp_grpc]
"
fi

sudo tee "$CONF" >/dev/null <<EOF
# generated by install-macos-otel-collector.sh - re-running the installer
# overwrites this file. the config shipped in the mtls zip is kept at
# config.yaml.vendor for reference; it targets linux and will not load on macos.
#
# docker container metrics live in config-docker.yaml and are merged in at
# startup by ${LAUNCHER}, but only when the docker socket actually answers.
# a missing docker socket is fatal to the collector, so it must stay optional.

extensions:
  # persists the exporter queue and the file_log read offsets across restarts
  file_storage:
    directory: ${STATE_DIR}
    create_directory: true

receivers:
  host_metrics:
    collection_interval: 30s
    scrapers:
      cpu:
        metrics:
          system.cpu.utilization:
            enabled: true
      disk: {}
      filesystem: {}
      load: {}
      memory: {}
      network: {}
      paging: {}
      processes: {}
      # the per-process scraper is omitted on purpose: on darwin it cannot read
      # other processes' argv and logs a multi-kb error on every collection.
  file_log:
    include:
      - /var/log/*.log
    exclude:
      - ${LOG}
      - ${ERR}
    start_at: end
    include_file_name: true
    include_file_path: true
    storage: file_storage
${UNIFIED_LOG_RECEIVER}
  otlp:
    protocols:
      grpc:
        endpoint: 127.0.0.1:4317
      http:
        endpoint: 127.0.0.1:4318

processors:
  # the macos unified log receiver replays the previous 24h on every start and has
  # no lookback setting, which is what saturated the exporter queue and dropped
  # data during an endpoint outage. records carry real timestamps, so drop anything
  # that is not recent. the receiver still reads the backlog, it just never leaves.
  filter/backfill:
    error_mode: ignore
    logs:
      log_record:
        - 'time < Now() - Duration("10m")'
  memory_limiter:
    limit_mib: 512
    spike_limit_mib: 128
    check_interval: 5s
  resource_detection:
    detectors:
      - env
      - system
    override: false
    system:
      hostname_sources:
        - os
      resource_attributes:
        host.id:
          enabled: true
        host.ip:
          enabled: true
        host.mac:
          enabled: true
        os.version:
          enabled: true
        os.description:
          enabled: true
  batch:
    timeout: 5s
    send_batch_size: 1000

exporters:
  otlp_grpc:
    endpoint: ${ENDPOINT}
    tls:
      ca_file: ${CERT_DIR}/ca.crt
      cert_file: ${CERT_DIR}/client.crt
      key_file: ${CERT_DIR}/client.key
    retry_on_failure:
      enabled: true
      initial_interval: 5s
      max_interval: 60s
      max_elapsed_time: 10m
    sending_queue:
      enabled: true
      num_consumers: 4
      queue_size: 5000
      storage: file_storage

service:
  extensions: [file_storage]
  pipelines:
    metrics:
      receivers: [host_metrics, otlp]
      processors: [memory_limiter, resource_detection, batch]
      exporters: [otlp_grpc]
    logs:
      receivers: [file_log, otlp]
      processors: [memory_limiter, resource_detection, batch]
      exporters: [otlp_grpc]
${UNIFIED_LOG_PIPELINE_BLOCK}    traces:
      receivers: [otlp]
      processors: [memory_limiter, resource_detection, batch]
      exporters: [otlp_grpc]
  telemetry:
    logs:
      level: info
EOF

# docker overlay, merged in only when the socket answers. confmap replaces
# sequences rather than appending, so the metrics receiver list is restated.
sudo tee "$CONF_DOCKER" >/dev/null <<EOF
# generated by install-macos-otel-collector.sh - merged over config.yaml by
# ${LAUNCHER} only when the docker socket responds.
receivers:
  docker_stats:
    endpoint: unix://${DOCKER_SOCK}
    collection_interval: 30s
service:
  pipelines:
    metrics:
      receivers: [host_metrics, otlp, docker_stats]
EOF

echo "validating ${CONF}"
sudo "$BIN" validate --config "file:${CONF}"
echo "validating ${CONF} + ${CONF_DOCKER}"
sudo "$BIN" validate --config "file:${CONF}" --config "file:${CONF_DOCKER}"

# ---------------------------------------------------------------- launcher

# docker_stats aborts collector startup if the socket is absent, which would take
# host metrics, logs and traces down with it. probe first, include it only if up.
sudo tee "$LAUNCHER" >/dev/null <<EOF
#!/bin/bash
# generated by install-macos-otel-collector.sh
set -e

ARGS=(--config "file:${CONF}")

if [ "\${OTEL_DOCKER:-1}" != "0" ] \\
  && curl -s -m 2 --unix-socket "${DOCKER_SOCK}" http://localhost/_ping >/dev/null 2>&1; then
  ARGS+=(--config "file:${CONF_DOCKER}")
  echo "docker socket responded, collecting container metrics"
else
  echo "no docker socket, skipping container metrics"
fi

exec "${BIN}" "\${ARGS[@]}"
EOF
sudo chmod 0755 "$LAUNCHER"
sudo chown root:wheel "$LAUNCHER"

# ---------------------------------------------------------------- install daemon

sudo tee "$PLIST" >/dev/null <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>${LABEL}</string>
  <key>ProgramArguments</key>
  <array>
    <string>${LAUNCHER}</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
  <key>StandardOutPath</key>
  <string>${LOG}</string>
  <key>StandardErrorPath</key>
  <string>${ERR}</string>
</dict>
</plist>
EOF

sudo chown root:wheel "$PLIST"
sudo chmod 0644 "$PLIST"

start_daemon

echo
echo "installed:"
echo "  binary   ${BIN}"
echo "  launcher ${LAUNCHER}"
echo "  config   ${CONF}"
echo "  docker   ${CONF_DOCKER} (merged only when the socket answers)"
echo "  certs    ${CERT_DIR}"
echo "  state    ${STATE_DIR}"
echo "  daemon   ${PLIST}"
echo "  logs     ${LOG} ${ERR}"
echo
echo "status:  $0 --status"
echo "stop:    $0 --stop"
echo "tail:    sudo tail -f ${ERR}"

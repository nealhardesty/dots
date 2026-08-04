#!/bin/sh
curl -sL https://talos.dev/install | sh
talosctl version --client

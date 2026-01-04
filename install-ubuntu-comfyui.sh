#!/bin/bash
#
set -ex

./install-ubuntu-uv.sh

cd ~
git clone https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI

uv venv --python 3.12 venv

source venv/bin/activate

which python
python --version

if command -v nvidia-smi; then
  echo Using cuda pytorch
  USE_CPU=""
  uv pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu124
else
  echo Using cpu python ... will be slow...
  USE_CPU="--cpu"
  uv pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cpu
fi

uv pip install -r requirements.txt

cat > start.sh <<MOOSE
#!/bin/bash
set -ex
source venv/bin/activate
python3 main.py --listen 0.0.0.0 ${USE_CPU}
MOOSE
chmod a+x start.sh

cd custom_nodes
git clone git@github.com:ltdrdata/ComfyUI-Manager
git clone git@github.com:pydn/ComfyUI-to-Python-Extension.git
cd ..

echo Install models with ./install-ubuntu-comfyui-models.sh
echo Start with ./start.sh



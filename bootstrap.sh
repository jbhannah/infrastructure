#!/bin/sh

set -euo pipefail

python3 -m venv --system-site-packages .venv
. .venv/bin/activate
pip install pipenv pip-autoremove
pipenv install
pipenv run ansible-playbook ansible/dotfiles.yml
pip-autoremove pipenv pip-autoremove -y
deactivate

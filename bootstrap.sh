#!/bin/sh

set -euo pipefail

python3 -m venv --system-site-packages .venv
. .venv/bin/activate
pip install pipenv
pipenv install
pipenv run ansible-playbook ansible/dotfiles.yml

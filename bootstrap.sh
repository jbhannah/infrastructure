#!/bin/sh

set -euo pipefail

export PIPENV_VERBOSITY=-1

echo "### Creating virtual environment…\c"
python3 -m venv --system-site-packages .venv
echo "done! Entering virtual environment."
. .venv/bin/activate

echo "\n### Installing Pipenv"
pip install pipenv pip-autoremove

echo "\n### Installing runtime dependencies"
pipenv install

echo "\n### Bootstrapping Dotfiles"
pipenv run ansible-playbook ansible/dotfiles.yml

echo "\n### Cleaning up"
pip-autoremove pipenv pip-autoremove -y
echo "\n### Exiting virtual environment…\c"
deactivate
echo "done!"

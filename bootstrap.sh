#!/bin/sh

set -euo pipefail

export PIPENV_VERBOSITY=-1
type pipenv > /dev/null && PIPENV_EXISTS=1

if [ ! -f .venv/bin/activate ]; then
    echo "### Creating virtual environment…\c"
    python3 -m venv --system-site-packages .venv
    echo "done!"
else
    echo "### Using existing virtual environment"
fi

. .venv/bin/activate
python --version

if [ -z ${PIPENV_EXISTS} ]; then
    echo "\n### Installing Pipenv"
    pip install pipenv pip-autoremove
fi

echo "\n### Installing runtime dependencies"
pipenv install

echo "\n### Bootstrapping system"
pipenv run ansible-playbook ansible/system.yml

if [ -z ${PIPENV_EXISTS} ]; then
    echo "\n### Cleaning up"
    pip-autoremove pipenv pip-autoremove -y
fi

echo "\n### Exiting virtual environment…\c"
deactivate
echo "done!"

echo "Initializing local python environment"
python -m venv venv

echo
echo "Activating local python environment"
source ./venv/bin/activate
echo
echo "Local python environment activated"

echo
echo "Upgrading pip"
echo
pip install --upgrade pip
echo
echo "pip upgraded"

echo
echo "Installing project dependencies"
echo
pip install -r requirements.txt --no-cache-dir

echo
echo "Copying .env.keploy.linux to .env.local"
cp .env.keploy.linux .env.local

echo "Enabling Pre Commit Hooks"
pre-commit install
echo

opentelemetry-bootstrap --action=install

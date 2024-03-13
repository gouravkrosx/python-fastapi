echo "Enabling Pre Commit Hooks"
#Enabling Pre-Commit hooks gor git
pre-commit install
echo

echo "Initializing local python environment"
# Initialize python environment
python -m venv venv

echo 
echo "Activating local python environment"
# Activate python environment
source ./venv/bin/activate
echo 
echo "Local python environment activated"

echo 
echo "Upgrading pip"
echo 
# Upgrade pip
pip install --upgrade pip
echo 
echo "pip upgraded"

echo 
echo "Installing project dependencies"
echo 
# Install requirements/dependencies
pip install -r requirements.txt --no-cache-dir

pip uninstall httpcore -y
pip uninstall httpx -y
pip install httpcore
pip install httpx
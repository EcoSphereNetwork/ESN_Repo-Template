#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print step information
print_step() {
    echo -e "${GREEN}==>${NC} $1"
}

# Function to print error and exit
error() {
    echo -e "${RED}Error:${NC} $1"
    exit 1
}

# Function to print warning
warning() {
    echo -e "${YELLOW}Warning:${NC} $1"
}

# Get script directory and paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
TEMPLATE_DIR="$( dirname "$SCRIPT_DIR" )"
TARGET_DIR="$PWD"

# Copy template files to target directory
print_step "Copying template files..."
cp -r "$TEMPLATE_DIR"/* "$TARGET_DIR/"
cp "$TEMPLATE_DIR"/.* "$TARGET_DIR/" 2>/dev/null || true

# Change to target directory
cd "$TARGET_DIR"

print_step "Initializing new project from template..."

# Initialize Git repository
print_step "Initializing Git repository..."
git init

# Get project information
read -p "Enter project name (lowercase, hyphens only): " PROJECT_NAME
read -p "Enter project description: " PROJECT_DESCRIPTION
read -p "Enter your name: " AUTHOR_NAME
read -p "Enter your email: " AUTHOR_EMAIL

# Validate project name
if [[ ! $PROJECT_NAME =~ ^[a-z0-9-]+$ ]]; then
    error "Project name must contain only lowercase letters, numbers, and hyphens"
fi

print_step "Setting up Git configuration..."
git config user.name "$AUTHOR_NAME"
git config user.email "$AUTHOR_EMAIL"

print_step "Updating project files..."

# Update pyproject.toml
sed -i "s/name = \"ecosphere-project\"/name = \"$PROJECT_NAME\"/" pyproject.toml
sed -i "s/description = \"EcoSphere Network Project Template\"/description = \"$PROJECT_DESCRIPTION\"/" pyproject.toml
sed -i "s/authors = \[\"EcoSphere Network <openhands@all-hands.dev>\"\]/authors = [\"$AUTHOR_NAME <$AUTHOR_EMAIL>\"]/" pyproject.toml

# Update README.md
sed -i "s/<h1>EcoSphere Network Repository Template<\/h1>/<h1>$PROJECT_NAME<\/h1>/" README.md
sed -i "s/A modern, comprehensive template for creating new repositories within the EcoSphere Network ecosystem./$PROJECT_DESCRIPTION/" README.md

# Create virtual environment and install dependencies
print_step "Setting up Python environment..."

# Install pip if not available
if ! command -v pip3 &> /dev/null; then
    print_step "Installing pip..."
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py --user
    rm get-pip.py
fi

# Install required packages
print_step "Installing required packages..."
python3 -m pip install toml pyyaml rich click

# Check if Poetry is installed
if ! command -v poetry &> /dev/null; then
    print_step "Installing Poetry..."
    curl -sSL https://install.python-poetry.org | python3 -
fi

# Install dependencies
print_step "Installing project dependencies..."
poetry install

# Create poetry shell script
cat > poetry-shell.sh << 'EOF'
#!/bin/bash
poetry shell
EOF
chmod +x poetry-shell.sh

# Initialize pre-commit
print_step "Setting up pre-commit hooks..."
poetry run pre-commit install

# Create initial directories if they don't exist
print_step "Creating project structure..."
mkdir -p src/core src/modules tests/{unit,integration,e2e} docs/{api,guides,development}

# Create .env from example if it doesn't exist
if [[ ! -f ".env" ]] && [[ -f ".env.example" ]]; then
    print_step "Creating .env file from example..."
    cp .env.example .env
fi

# Commit initial changes
print_step "Committing initial changes..."
git add .
git commit -m "feat: initial project setup from template"

# Clean up template-specific files
print_step "Cleaning up template files..."
rm -f docs/static/img/logo.png
rm -f CREDITS.md

# Create initial test files
print_step "Creating initial test files..."
cat > tests/unit/test_unit.py << 'EOF'
"""Unit tests for the project."""

def test_unit_example():
    """Basic unit test example."""
    assert True
EOF

cat > tests/integration/test_integration.py << 'EOF'
"""Integration tests for the project."""

def test_integration_example():
    """Basic integration test example."""
    assert True
EOF

cat > tests/e2e/test_e2e.py << 'EOF'
"""End-to-end tests for the project."""

def test_e2e_example():
    """Basic end-to-end test example."""
    assert True
EOF

# Run initial test to verify setup
print_step "Running initial tests..."
poetry run pytest

print_step "Setting up documentation..."
poetry run mkdocs build

print_step "Project initialization complete! 🎉"
echo -e "\nNext steps:"
echo -e "1. Review and update the .env file with your configuration"
echo -e "2. Update the project documentation in docs/"
echo -e "3. Start developing in src/"
echo -e "4. Run tests with 'poetry run pytest'"
echo -e "5. Build documentation with 'poetry run mkdocs build'"
** *Weiter überarbeiten* **


# *How to use this Template*

## Configuration

- Der Ordner Repo-Template/docs enthält die Repository Dokumentation
  - *Docs und mkdocs nutzung erläutern* 
- Der Ordner Repo-Template/src enthält den Projekt Code des Repository
- Alle Änderungen in "mkdocs.yml (Repo-Template/mkdocs.yml)" doumentieren!


### GitHub Actions

The pipeline is configured in `.github/workflows/ci.yml`:

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    # Test job configuration...
    
  build:
    # Build job configuration...
    
  deploy-staging:
    # Staging deployment configuration...
    
  deploy-production:
    # Production deployment configuration...
```

### Environment Variables

Required secrets in GitHub:

- `DOCKER_USERNAME`: Docker Hub username
- `DOCKER_PASSWORD`: Docker Hub password
- `STAGING_SSH_KEY`: SSH key for staging server
- `PRODUCTION_SSH_KEY`: SSH key for production server

### Docker Configuration

Dockerfile for the application:

```dockerfile
FROM python:3.10-slim

WORKDIR /app

# Install Poetry
RUN pip install poetry

# Copy project files
COPY pyproject.toml poetry.lock ./
COPY smolit_llm_nn/ ./smolit_llm_nn/

# Install dependencies
RUN poetry config virtualenvs.create false \
    && poetry install --no-dev

# Run application
CMD ["poetry", "run", "python", "-m", "smolit_llm_nn"]
```

### GitHub .gitignore

The gitignore file is configured in `Repo-Template/.gitignore`:

```yaml
**/node_modules

```

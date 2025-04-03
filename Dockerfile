# Use a Python base image
FROM python:3.9-slim-buster

# Set the working directory
WORKDIR /app

# Copy the Poetry lock file and pyproject.toml
COPY poetry.lock pyproject.toml ./

# Install Poetry and project dependencies
RUN pip install poetry && poetry install --no-root

# Copy the rest of the project files
COPY . .


# Set the GOOGLE_APPLICATION_CREDENTIALS environment variable
ENV GOOGLE_APPLICATION_CREDENTIALS=/app/sa_key.json

# Set the DBT_PROFILES_DIR environment variable
ENV DBT_PROFILES_DIR=/app/bigquery

# Run dbt version check (optional)
RUN poetry run dbt --version

# Default command to run dbt run
CMD ["poetry", "run", "dbt", "run"]
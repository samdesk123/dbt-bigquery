# Use a Python 3.11 base image
FROM python:3.11-slim-buster

ENV DBT_VERSION=1.0.0
ENV PATH="/root/.local/bin:$PATH"

# Install git and gcloud CLI
RUN apt-get update && \
    apt-get install -y sudo apt-transport-https ca-certificates curl gpg gnupg git 

# Download and add the missing Google Cloud public key
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/cloud.google.gpg

# Add the Google Cloud SDK repository
RUN echo "deb [signed-by=/etc/apt/trusted.gpg.d/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

RUN apt-get update && \
    apt-get install -y google-cloud-sdk && \
    rm -rf /var/lib/apt/lists/*

# Add gcloud to PATH
ENV PATH="/google-cloud-sdk/bin:$PATH"

RUN python3 -m ensurepip --default-pip && \
    pip install --no-cache-dir --upgrade pip pipx && \
    python3 -m pipx ensurepath

RUN pipx install poetry

# Set the working directory
WORKDIR /app

# Copy the rest of the project files
COPY . .

# Set the GOOGLE_APPLICATION_CREDENTIALS environment variable
ENV GOOGLE_APPLICATION_CREDENTIALS=/app/sa_key.json

# Install dependencies
RUN poetry install --no-root

# Set the DBT_PROFILES_DIR environment variable
ENV DBT_PROFILES_DIR=/app/bigquery

# Run dbt version check (optional)
RUN poetry run dbt --version

# Default command to run dbt run
CMD ["poetry", "run", "dbt", "run"]
FROM python:3.8-slim

# Set environment variables
ENV DBT_VERSION=1.0.0

# Install Poetry
RUN pip install poetry

# Install gcloud SDK
RUN apt-get update && apt-get install -y \
    git \
    curl \
    gnupg \
    && curl -sSL https://sdk.cloud.google.com | bash

# Set environment variable for gcloud
ENV PATH=$PATH:/root/google-cloud-sdk/bin

# Authenticate gcloud
RUN gcloud auth application-default login

# Copy the pyproject.toml and poetry.lock files
COPY pyproject.toml poetry.lock ./

# Install dependencies using Poetry
RUN poetry install

# Set the working directory
WORKDIR /app

# Copy the dbt project files into the container
COPY . .

# Command to run dbt
CMD ["dbt", "run"]
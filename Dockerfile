FROM python:3.11-slim-bullseye

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

# Create a directory for the service account key
RUN mkdir /app

# Set the GOOGLE_APPLICATION_CREDENTIALS environment variable
ENV GOOGLE_APPLICATION_CREDENTIALS=jason.json

RUN python3 -m ensurepip --default-pip && \
    pip install --no-cache-dir --upgrade pip pipx && \
    python3 -m pipx ensurepath

RUN pipx install poetry

ENV PATH="/root/.local/bin:$PATH"

WORKDIR /dbt_demo
# Copy the rest of the project files
COPY . .

# Install dependencies
RUN poetry install --no-root

WORKDIR /dbt_demo/bigquery

ENV DBT_PROFILES_DIR=/dbt_demo/bigquery
# Run dbt
RUN poetry run dbt --version

CMD ["poetry", "run", "dbt", "run"]
# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.217.4/containers/python-3/.devcontainer/base.Dockerfile

# [Choice] Python version (use -bullseye variants on local arm64/Apple Silicon): 3, 3.10, 3.9, 3.8, 3.7, 3.6, 3-bullseye, 3.10-bullseye, 3.9-bullseye, 3.8-bullseye, 3.7-bullseye, 3.6-bullseye, 3-buster, 3.10-buster, 3.9-buster, 3.8-buster, 3.7-buster, 3.6-buster
ARG VARIANT="3.10-bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/python:0-${VARIANT}

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
# ARG NODE_VERSION="none"
# RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# [Optional] If your pip requirements rarely change, uncomment this section to add them to the image.
# COPY requirements.txt /tmp/pip-tmp/
# RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
#    && rm -rf /tmp/pip-tmp

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1

# Get golang installed. See: https://stackoverflow.com/questions/52056387/how-to-install-go-in-alpine-linux
ARG GOLANG_VERSION=1.18
RUN wget https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go$GOLANG_VERSION.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin
ENV PATH=$PATH:"/root/go/bin"
RUN which go && go version

# Install Azure CLI dependencies
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
RUN az extension add -n azure-devops
RUN which az && az --version

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN which aws && aws --version

# Install Google Cloud SDK
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz
RUN mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

# Install terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    # Link up to repository before installing
    && apt-get --allow-releaseinfo-change update \
    && apt-get install -y software-properties-common --no-install-recommends \
    && apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && apt-get update \
    && apt-get -y --no-install-recommends install terraform g++ gcc libc6-dev libffi-dev libgmp-dev make xz-utils zlib1g-dev git gnupg netbase graphviz
RUN which terraform && terraform version

# Terraform linting (taken from https://github.com/antonbabenko/pre-commit-terraform)
RUN curl -L https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
RUN which tflint && tflint --version

# Install tfdocs
RUN go install github.com/terraform-docs/terraform-docs@v0.15.0
RUN which terraform-docs && terraform-docs --version

# Install tfsec
RUN go install github.com/aquasecurity/tfsec/cmd/tfsec@latest
RUN which tfsec && tfsec --version

# Copy go installs to vscode user
ENV PATH=$PATH:/rootgo/bin/
RUN mkdir -p /rootgo/bin/ && cp -r root/go/bin/* /rootgo/bin/

# Install homebrew
RUN git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew \
&& mkdir ~/.linuxbrew/bin \
&& ln -s ../Homebrew/bin/brew ~/.linuxbrew/bin \
&& eval $(~/.linuxbrew/bin/brew shellenv) \
&& brew --version

# Install just
RUN curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /bin

# Setup aliases
RUN echo 'alias tf="terraform"' >> /root.bashrc \
&& echo 'alias gc="gcloud"' >> /root.bashrc \
&& echo 'alias j="just"' >> /root.bashrc

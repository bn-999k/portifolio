FROM alpine:latest as builder

# Atualizando pacotes e instalando dependências
RUN apk update && \
    apk add --no-cache wget unzip curl python3 py3-pip

# Instalar Terraform
RUN wget https://releases.hashicorp.com/terraform/1.8.2/terraform_1.8.2_linux_amd64.zip && \
    unzip terraform_1.8.2_linux_amd64.zip && \
    mv terraform /usr/local/bin/

RUN apk add --no-cache python3-dev

# Instalar awscli
RUN wget "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -O "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install -i /usr/local/aws-cli -b /usr/local/bin

WORKDIR /work/
COPY app/ .

# STAGE 2
FROM alpine:latest

WORKDIR /work

COPY --from=builder /usr/local/bin/terraform /usr/local/bin/terraform 
COPY --from=builder /usr/local/bin/aws /usr/local/bin/aws
COPY --from=builder /work /work

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_DEFAULT_REGION

# Configurar credenciais AWS
RUN echo "[default]" >> aws/credentials && \
    echo "aws_access_key_id = ${AWS_ACCESS_KEY_ID}" >> aws/credentials && \
    echo "aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}" >> aws/credentials

# Instalar Python e pip
RUN apk update && \
    apk add --no-cache python3 py3-pip

# Instalar os requisitos mínimos (requirements.txt) com a opção --ignore-installed
RUN python3 -m pip install --no-cache-dir --ignore-installed -r requirements.txt --break-system-packages

EXPOSE 8080

# Rodar a aplicação
CMD ["python3", "app.py"]
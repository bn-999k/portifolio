<div align="center">
<img src="https://upload.wikimedia.org/wikipedia/commons/8/8c/SENAI_S%C3%A3o_Paulo_logo.png" height="100">
</div>

<br><br>

# Portifólio

> Curso Técnico Em Redes de Computadores

<p align="center">

> [![senai_automacao](https://github.com/cl0uD-C1SC0/github_actions_first/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/cl0uD-C1SC0/github_actions_first/actions/workflows/main.yml) <img src="https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=green" width="130"> <img src="https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white" width="55"> <img src="https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white" width="80"> <img src="https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white" width="60">
</p>

## Índice
* [01 - Execução](#01---Execução)
* [02 - Dockerfile](#02---Dockerfile)
* [03 - Terraform](#03---Terraform)
* [04 - Workflows](#04---Workflows)

<br><br>

Este repositório contém o código e as configurações necessárias para implantar e executar um portfólio utilizando tecnologias como Docker, Terraform, e GitHub Actions.

# 01 - Execução
# Para executar este projeto, siga os passos abaixo:


1.  Criar repositório manualmente no GitHub

> Crie um novo repositório no GitHub.

2.  Clonar o repositório

> Clone o repositório para sua máquina local utilizando o comando:
```bash
git clone <URL\_DO\_REPOSITORIO>
```

3.  Adicionar os arquivos

> Adicione os arquivos ao repositório clonado.

4.  Executar os comandos

> Execute os seguintes comandos na raiz do projeto:
```bash
git add .
git init
git commit -m "<update>[Portifolio]: Adicionando Arquivos"
git checkout -b develops
git branch
git push origin develops
```

5.  Criar as Actions Secrets e Variables no GitHub

> No GitHub, vá para o seu repositório e crie as seguintes Actions Secrets e Variables:
```
SNYK_AUTH_TOKEN
```
```
REGISTRY
```
```
DOCKER_USER
```
```
DOCKER_PASSWORD
```
```
AWS_SESSION_TOKEN
```
```
AWS_SECRET_ACCESS_KEY
```
```
AWS_ACCESS_KEY_ID
```

6.  Criar repositório no Docker Hub

> Crie um repositório público no Docker Hub com o nome portifolio.

7.  Criar o workflow no GitHub Actions

> No GitHub, clique em "Actions" e crie um novo workflow com o conteúdo do código

8.  Executar o workflow

> O workflow será iniciado automaticamente. Se houver erros será devido a branches separadas, siga as instruções para criar um pull request e mesclar as alterações.

9.  Ajustar e executar novamente

> Se necessário, ajuste o código e execute novamente o workflow.

10. Sucesso!

Depois de todos os passos concluídos com sucesso, seu portfólio estará implantado e em execução.


<div align="center">
    <img src="https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white" height="65">
    <img src="https://img.shields.io/badge/gitlab-%23181717.svg?style=for-the-badge&logo=gitlab&logoColor=white" height="65">
</div>
<br><br>


# 02 - Dockerfile
* O Dockerfile contém as instruções para construir a imagem Docker necessária para executar a aplicação. Ele instala as dependências e configura a aplicação para ser executada.

```
FROM alpine:latest as builder
``` 
> Esta linha define a imagem base do Docker que será utilizada como ponto de partida para a construção da imagem. Neste caso, está sendo utilizada a imagem Alpine Linux, uma distribuição Linux leve.

```
# Atualizando pacotes e instalando dependências
RUN apk update && \
    apk add --no-cache wget unzip curl python3 py3-pip
```
> Estae bloco de comando executa o apk update para atualizar o cache dos repositórios de pacotes do Alpine Linux.
E instala as dependências necessárias para o funcionamento da aplicação, como wget, unzip, curl, Python 3 e pip.

```
# Instalar Terraform
RUN wget https://releases.hashicorp.com/terraform/1.8.2/terraform_1.8.2_linux_amd64.zip && \
    unzip terraform_1.8.2_linux_amd64.zip && \
    mv terraform /usr/local/bin/
```
> Este bloco de comandos baixa o Terraform na versão 1.8.2, descompacta o arquivo zip e move o binário do Terraform para o diretório /usr/local/bin/, tornando-o disponível globalmente no sistema.

```
RUN apk add --no-cache python3-dev
```
> Este comando adiciona o pacote python3-dev ao sistema, que é necessário para compilar e instalar pacotes Python.

```
# Instalar awscli
RUN wget "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -O "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install -i /usr/local/aws-cli -b /usr/local/bin
```
> Este bloco de comandos baixa o AWS CLI, descompacta o arquivo zip e instala o AWS CLI no sistema.

```
WORKDIR /work/
COPY app/ .
```
> WORKDIR /work/: Define o diretório de trabalho para /work/

> COPY app/ . : Copia o conteúdo do diretório app/ do host para o diretório de trabalho dentro do container.

```
# STAGE 2
FROM alpine:latest

WORKDIR /work

COPY --from=builder /usr/local/bin/terraform /usr/local/bin/terraform 
COPY --from=builder /usr/local/bin/aws /usr/local/bin/aws
COPY --from=builder /work /work
```

> Este bloco define uma segunda etapa na construção da imagem Docker, chamada de "STAGE 2". Aqui, estamos criando uma nova imagem baseada em Alpine Linux.

> WORKDIR /work: Define o diretório de trabalho como /work.

> COPY --from=builder ...: Copia os binários do Terraform e AWS CLI, bem como todos os arquivos do diretório de trabalho da etapa anterior (builder) para o diretório de trabalho desta etapa (/work).

```
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_DEFAULT_REGION
```
> Estas são variáveis de argumento que podem ser passadas durante o processo de construção da imagem Docker.

```
# Configurar credenciais AWS
RUN echo "[default]" >> aws/credentials && \
    echo "aws_access_key_id = ${AWS_ACCESS_KEY_ID}" >> aws/credentials && \
    echo "aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}" >> aws/credentials
```
> Este comando configura as credenciais da AWS dentro do container, escrevendo-as em um arquivo de configuração AWS.

```
# Instalar Python e pip
RUN apk update && \
    apk add --no-cache python3 py3-pip
```
> Este comando instala o Python e o pip dentro do container, que serão necessários para executar a aplicação.

```
# Instalar os requisitos mínimos (requirements.txt) com a opção --ignore-installed
RUN python3 -m pip install --no-cache-dir --ignore-installed -r requirements.txt --break-system-packages
```
> Este comando instala os requisitos mínimos da aplicação, listados no arquivo requirements.txt, ignorando as dependências já instaladas e quebrando pacotes de sistema se necessário.

```
EXPOSE 8080
```
> EXPOSE 8080: Define a porta 8080 como a porta em que a aplicação estará escutando dentro do container.

```
# Rodar a aplicação
CMD ["python3", "app.py"]
```
> Executa dos comandos python3 app.py para rodar a aplicação dentro do container 


<div align="center">
    <img src="https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white" height="65">
    <img src="https://img.shields.io/badge/python-%233776AB.svg?style=for-the-badge&logo=python&logoColor=white" height="65">
    <img src="https://img.shields.io/badge/dockerfile-%232496ED.svg?style=for-the-badge&logo=docker&logoColor=white" height="65">
</div>
<br><br>


# 03 - Terraform

```
terraform {
required\_version = ">=1.0.0" # Versão do Terraform

# Provedores Utilizados
required\_providers {
aws = {
source  = "hashicorp/aws"
version = "5.42.0" # Versão do AWS no Terraform
}
```
> terraform { ... }: Esta seção define as configurações globais do Terraform para este diretório.

> required\_version = ">=1.0.0": Define a versão mínima do Terraform necessária para usar este código.

> required\_providers { ... }: Define os provedores de recursos necessários para este projeto.

> aws { ... }: Especifica que este projeto requer o provedor AWS.

> source = "hashicorp/aws": Especifica a origem do provedor AWS.

> version = "5.42.0": Especifica a versão do provedor AWS a ser usada.

```
provider "aws" {
region           = "us-east-1"
access_key       = var.AWS_ACCESS_KEY_ID
secret_key       = var.AWS_SECRET_ACCESS_KEY
token            = var.AWS_SESSION_TOKEN
}
```
> provider "aws" { ... }: Esta seção configura o provedor AWS.

> region = "us-east-1": Define a região da AWS onde os recursos serão provisionados.

> access_key = var.AWS_ACCESS_KEY_ID: Define a chave de acesso da AWS, que é uma variável passada para o Terraform.

> secret_key = var.AWS_SECRET_ACCESS_KEY: Define a chave secreta da AWS, também passada como variável.

> token = var.AWS_SESSION_TOKEN: Define o token de sessão da AWS, se aplicável, e também é passado como variável.

```
variable "AWS_ACCESS_KEY_ID" {
description = "The AWS access key ID"
}

variable "AWS_SECRET_ACCESS_KEY" {
description = "The AWS secret access key"
}

variable "AWS_SESSION_TOKEN" {
description = "The AWS session token"
}
```
> variable "..." { ... }: Esta seção define as variáveis que serão usadas no arquivo Terraform.

> description = "...": Fornece uma descrição para cada variável para tornar mais claro o seu propósito.

```
resource "aws_security_group" "grupoapi" {
name        = "grupoapi"
description = "Security group for EC2 instance"
```
> resource "aws_security_group" "grupoapi" { ... }: Esta seção define um recurso de grupo de segurança na AWS.

> name = "grupoapi": Define o nome do grupo de segurança.

> description = "Security group for EC2 instance": Fornece uma descrição para o grupo de segurança.

```
ingress {
from_port   = 22
to_port     = 22
protocol    = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
```
> ingress { ... }: Esta seção define uma regra de entrada para o grupo de segurança.

> from_port = 22: Define a porta de origem para a regra.

> to_port = 22: Define a porta de destino para a regra.

> protocol = "tcp": Define o protocolo para a regra.

> cidr\_blocks = ["0.0.0.0/0"]: Define os blocos CIDR que têm permissão para acessar a porta especificada.

```
ingress {
from_port   = 80
to_port     = 80
protocol    = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
```
> Este bloco define uma segunda regra de entrada no grupo de segurança, permitindo tráfego TCP na porta 80 para qualquer endereço IP.

```
ingress {
from_port   = 8080
to_port     = 8080
protocol    = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
```
> Este bloco define uma terceira regra de entrada no grupo de segurança, permitindo tráfego TCP na porta 8080 para qualquer endereço IP.

```
egress {
from_port   = 0
to_port     = 0
protocol    = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
```
> Este bloco define uma regra de saída no grupo de segurança, permitindo qualquer tráfego de saída para qualquer destino.

```
resource "aws_instance" "linux" {
ami                         = "ami-058bd2d568351da34" # Debian
instance_type               = "t2.micro"
key_name                    = "vockey" # Estamos ultilizando a chave padão da aws
vpc_security_group_ids      = [aws_security_group.grupoapi.id]  # ID do grupo de segurança específico
subnet_id                   = "subnet-0d823ddb2dcf69349" # Não se esqueca se subistituir para a sua subrede
associate_public_ip_address = true
```
> Este bloco define um recurso de instância EC2 na AWS.

> ami: Define o ID da AMI (Amazon Machine Image) a ser usada para a instância, neste caso, uma imagem Debian.

> instance_type: Define o tipo de instância EC2, neste caso, t2.micro.

> key_name: Define o nome da chave SSH a ser associada à instância para acesso seguro.

> vpc_security_group_ids: Define os IDs dos grupos de segurança que serão aplicados a esta instância.

> subnet_id: Define o ID da sub-rede onde a instância será lançada.

> associate_public_ip_address: Define se a instância terá um endereço IP público associado.

```
user_data = <<-EOF
              #!/bin/bash
              # Atualizar os pacotes de instalação
              sudo apt update -y
              # Instalar o Docker
              sudo apt install docker.io -y
              # Iniciar o Docker
              sudo systemctl start docker
              # Adicionar o usuário ec2-user ao grupo docker para executar comandos docker sem sudo
              sudo usermod -aG docker ec2-user
              # Baixar a imagem do Docker Hub
              sudo docker pull euumarceloo/portifolio:latest 
              # Iniciar o contêiner
              sudo docker run -d -p 8080:8080 --name apicontainer euumarceloo/portifolio
              EOF
```
> Este bloco define um script de inicialização que será executado quando a instância for iniciada.

> Ele atualiza os pacotes, instala o Docker, inicia o Docker daemon, adiciona o usuário ec2-user ao grupo docker, puxa a imagem do Docker Hub e inicia o contêiner.

```
tags = {
    Name = "EC2 CI/CD"
  }
```
> Define tags para a instância EC2, fornecendo metadados para identificar e categorizar a instância.

<div align="center">
    <img src="https://img.shields.io/badge/terraform-%23623CE4.svg?style=for-the-badge&logo=terraform&logoColor=white" height="65">
    <img src="https://img.shields.io/badge/aws-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white" height="65">
</div>
<br><br>

# 04 - Workflows

<h2>

Os workflows definidos nas Actions do GitHub automatizam o processo de construção, teste e implantação da aplicação. Eles configuram variáveis, constroem imagens Docker, realizam análises de segurança e implantam a aplicação na AWS.

 * Arquivo main.yml no Workflow
</h2>

```
name: Portifolio_senai
```
name: Define o nome do workflow como Portifolio_senai.

```
on:
  push:
    branches:
      - "main"
```
> on: Especifica os eventos que acionarão o workflow. Neste caso, o workflow será acionado quando ocorrer um push em branches específicas.

> branches: Lista as branches que acionarão o workflow. Aqui, o workflow será acionado apenas quando houver um push na branch main.

```
jobs:
  portifolio:
    runs-on: ubuntu-latest
```
> jobs: Define os diferentes trabalhos que serão executados no workflow.

> portifolio: Define o nome do trabalho como portifolio.

> runs-on: ubuntu-latest: Especifica o ambiente em que o trabalho será executado, neste caso, em uma máquina virtual Ubuntu.

```
steps:
      - name: Checkout
        uses: actions/checkout@v4
```
> steps: Define os passos individuais que compõem o trabalho.

> name: Checkout: Define o nome deste passo como "Checkout".

> uses: actions/checkout@v4: Utiliza a ação checkout da versão 4, que permite ao workflow clonar o repositório onde está sendo executado.

```
- name: INSTALL PACKAGES
        run: |
          sudo apt update -y
          sudo apt-get install figlet -y
          curl https://static.snyk.io/cli/latest/snyk-linux -o snyk
          chmod +x ./snyk
          mv ./snyk /usr/local/bin/
```
> Este passo é chamado "INSTALL PACKAGES" e executa uma série de comandos para instalar pacotes necessários, como o figlet e o snyk, uma ferramenta de verificação de segurança de código.

```
- name: Snyk Auth
        run: |
          snyk -d auth $SNYK_TOKEN
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_AUTH_TOKEN }}
```
> Este passo é chamado "Snyk Auth" e autentica o Snyk utilizando um token fornecido como uma secret do GitHub.

```
- name: DockerLint (CI)
        run: |
          echo "DOCKERLINT" | figlet -f small
          docker run --rm -i hadolint/hadolint < Dockerfile || true
```
> Este passo é chamado "DockerLint (CI)" e executa uma verificação de lint no Dockerfile usando a ferramenta hadolint, exibindo uma mensagem "DOCKERLINT" formatada com figlet.

```
- name: Configurar AWS CLI
        if: always()
        run: |
          echo "AWS CLI" | figlet -f small
          aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
          aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
          aws configure set default.region us-east-1
          export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
          export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
          export AWS_DEFAULT_REGION="us-east-1"
          export AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_SESSION_TOKEN: ${{ secrets.AWS_SESSION_TOKEN }}
```
> Este passo é chamado "Configurar AWS CLI" e configura as credenciais da AWS no ambiente, utilizando as secrets do GitHub. Além disso, define a região padrão da AWS como us-east-1.

```
- name: Docker Login
        if: always()
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ secrets.DOCKER_USER }}
          password: ${{ secrets.DOCKER_PASSWORD }}
```
> Este passo é chamado "Docker Login" e utiliza a ação docker/login-action@v3 para fazer login no Docker Hub. Ele utiliza as secrets do GitHub para autenticar o usuário e senha.

```
- name: Docker build (CI)
        if: always()
        run: |
          echo $AWS_ACCESS_KEY_ID
          docker build --build-arg AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID --build-arg AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY --build-arg AWS_DEFAULT_REGION="us-east-1" -t portifolio .
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```
> Este passo é chamado "Docker build (CI)" e constrói a imagem Docker utilizando o Dockerfile fornecido. Ele também passa as credenciais da AWS como argumentos durante a construção da imagem.

```
- name: Docker Analysis (CI)
        if: always()
        run: |
          echo "VULNERABILIDADES" | figlet -c -f small
          snyk container test portifolio:latest || true
```
> Este passo é chamado "Docker Analysis (CI)" e realiza uma análise de segurança na imagem Docker utilizando o Snyk. Ele exibe uma mensagem "VULNERABILIDADES" formatada com figlet.

```
- name: Docker Push (CD)
        if: always()
        run: |
          # Extrair os 7 primeiros caracteres do SHA do commit
          COMMIT_SHA=$(echo $GITHUB_SHA | cut -c 1-7)
          echo "Commit SHA: $COMMIT_SHA"
      
          # Tag da imagem com o commit SHA
          docker tag portifolio:latest euumarceloo/portifolio:$COMMIT_SHA
          # Push da imagem com a tag do commit
          docker push euumarceloo/portifolio:$COMMIT_SHA
      
          # Atualizar a imagem "latest" para a nova versão
          docker tag portifolio:latest euumarceloo/portifolio:latest
          docker push euumarceloo/portifolio:latest
```
> Este passo é chamado "Docker Push (CD)" e faz o push da imagem Docker para o Docker Hub. Ele também atualiza a tag latest com a nova versão da imagem

```
- name: Copy EC2 Terraform file
        run: |
          cp app/aws/ec2.tf .
```
> Este passo é chamado "Copy EC2 Terraform file" e copia o arquivo ec2.tf necessário para configurar a infraestrutura da AWS para o diretório atual do workflow.

```
- name: Install Terraform
        run: |
          wget https://releases.hashicorp.com/terraform/1.0.0/terraform_1.0.0_linux_amd64.zip
          unzip terraform_1.0.0_linux_amd64.zip
          sudo mv terraform /usr/local/bin/
```
> Este passo é chamado "Install Terraform" e baixa, descompacta e instala o Terraform na versão 1.0.0 na máquina do workflow.

```
- name: Deploy EC2 using Terraform
        if: always()
        run: |
          echo "Deploying EC2" | figlet -f small
          terraform init
          terraform apply -auto-approve \
            -var="AWS_ACCESS_KEY_ID=${{ secrets.AWS_ACCESS_KEY_ID }}" \
            -var="AWS_SECRET_ACCESS_KEY=${{ secrets.AWS_SECRET_ACCESS_KEY }}" \
            -var="AWS_SESSION_TOKEN=${{ secrets.AWS_SESSION_TOKEN }}"
          PUBLIC_IP=$(terraform output -json public_ip | jq -r '.')
          echo "$PUBLIC_IP" | figlet -f small
```
> Este passo é chamado "Deploy EC2 using Terraform" e utiliza o Terraform para implantar a infraestrutura na AWS. Ele inicializa o Terraform, aplica as alterações com aprovado automático e recupera o endereço IP público da instância EC2 implantada.

```
- name: Finalização
        run: echo "Portifolio e do job ${{ job.status }}."
```
> Este é o último passo chamado "Finalização" que apenas exibe uma mensagem indicando a conclusão do workflow e o status do job.

<div align="center">
    <img src="https://img.shields.io/badge/workflow-%231f8b4c.svg?style=for-the-badge&logo=github-actions&logoColor=white" height="65">
    <img src="https://img.shields.io/badge/yml-%230055AF.svg?style=for-the-badge&logo=yaml&logoColor=white" height="65"></div>
<br><br>


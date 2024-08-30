FROM php:8.2-apache

# Instalar as dependências necessárias
RUN apt-get update && apt-get install -y \
    gnupg2 \
    unixodbc \
    unixodbc-dev \
    apt-transport-https \
    curl \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update && ACCEPT_EULA=Y apt-get install -y \
    msodbcsql18 \
    mssql-tools18 \
    odbcinst \
    && echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
	
# Instalar o módulo `mod_rewrite`
RUN a2enmod rewrite

# Instalar e habilitar as extensões do SQL Server para PHP
RUN pecl install sqlsrv pdo_sqlsrv \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv

# Copiar o código da aplicação para o diretório padrão do Apache
COPY . /var/www/html/

# Adicionar o script SQL ao contêiner
#COPY script.sql /script.sql

# Comando para executar o script
#CMD /bin/bash -c 'sleep 30s; /opt/mssql-tools18/bin/sqlcmd -S db -U sa -P YourStrong@Passw0rd -d master -i /script.sql -No -C'


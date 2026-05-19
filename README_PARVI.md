#!/bin/bash

set -e

echo "=========================================="
echo "  Instalando plugins do Moodle EAD Parvi"
echo "=========================================="
echo ""

# Permissões
sudo chown -R $USER:$USER public/theme public/mod public/admin/tool public/local 2>/dev/null || true

# Tema Moove
echo "→ Instalando tema Moove..."
git clone https://github.com/willianmano/moodle-theme_moove.git public/theme/moove
cd public/theme/moove && git checkout MOODLE_501_STABLE && cd ../../..
echo "✅ Tema Moove instalado!"

# HVP (H5P)
echo ""
echo "→ Instalando HVP (H5P)..."
git clone https://github.com/h5p/h5p-moodle-plugin.git public/mod/hvp
cd public/mod/hvp && git submodule update --init && cd ../../..
echo "✅ HVP instalado!"

# Simple Certificate
echo ""
echo "→ Instalando Simple Certificate..."
git clone https://github.com/bozoh/moodle-mod_simplecertificate.git public/mod/simplecertificate
echo "✅ Simple Certificate instalado!"

# ObjectFS
echo ""
echo "→ Instalando ObjectFS..."
git clone https://github.com/catalyst/moodle-tool_objectfs.git public/admin/tool/objectfs

# Adicionar path style endpoint no client S3
sed -i 's/if (\$config->s3_base_url) {/if (\$config->s3_base_url) {\n            \$options['"'"'use_path_style_endpoint'"'"'] = true;/' \
    public/admin/tool/objectfs/classes/local/store/s3/client.php
echo "✅ ObjectFS instalado!"

# AWS SDK
echo ""
echo "→ Instalando AWS SDK..."
git clone https://github.com/catalyst/moodle-local_aws.git public/local/aws
echo "✅ AWS SDK instalado!"

echo ""
echo "=========================================="
echo "  ✅ Todos os plugins instalados!"
echo "=========================================="
echo ""
echo "Próximos passos:"
echo "1. docker-compose up -d --build"
echo "2. Aguarde 10 segundos"
echo "3. docker exec -it moodle-web php /var/www/html/admin/cli/install_database.php \\"
echo "     --adminpass=Admin@123 \\"
echo "     --adminemail=admin@parvi.com.br \\"
echo "     --fullname='EAD Parvi' \\"
echo "     --shortname='EAD Parvi' \\"
echo "     --agree-license"
echo ""
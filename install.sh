#!/bin/bash

# Script de instalación automática para FreePBX
# Este script automatiza la instalación completa de la aplicación

set -e  # Salir si hay algún error

echo "=========================================="
echo "Instalación de Gestión de Trunks Asterisk"
echo "=========================================="
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar que se ejecuta como root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Error: Este script debe ejecutarse como root (usa sudo)${NC}"
    exit 1
fi

# Obtener el directorio actual
CURRENT_DIR=$(pwd)
APP_DIR="$CURRENT_DIR"

# Si estamos en el directorio app, subir un nivel
if [[ "$CURRENT_DIR" == *"/app" ]]; then
    APP_DIR="$CURRENT_DIR"
else
    # Buscar el directorio app
    if [ -d "app" ]; then
        APP_DIR="$CURRENT_DIR/app"
    fi
fi

echo -e "${YELLOW}Directorio de la aplicación: $APP_DIR${NC}"
echo ""

# Paso 1: Instalar dependencias de Node.js
echo -e "${GREEN}[1/6] Instalando dependencias de Node.js...${NC}"
cd "$APP_DIR"
npm install
echo -e "${GREEN}✓ Dependencias instaladas${NC}"
echo ""

# Paso 2: Crear archivo de servicio systemd
echo -e "${GREEN}[2/6] Creando servicio systemd...${NC}"
SERVICE_FILE="/etc/systemd/system/miapp.service"
cat > "$SERVICE_FILE" << EOF
[Unit]
Description=Servicio Node.js para gestionar trunks Asterisk
After=network.target

[Service]
ExecStart=/usr/bin/node $APP_DIR/app.js
WorkingDirectory=$APP_DIR
Restart=always
User=root
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOF
echo -e "${GREEN}✓ Servicio systemd creado en $SERVICE_FILE${NC}"
echo ""

# Paso 3: Recargar y habilitar servicio systemd
echo -e "${GREEN}[3/6] Configurando servicio systemd...${NC}"
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable miapp
echo -e "${GREEN}✓ Servicio systemd configurado${NC}"
echo ""

# Paso 4: Crear directorio de trunks de Asterisk
echo -e "${GREEN}[4/6] Configurando directorio de trunks de Asterisk...${NC}"
mkdir -p /etc/asterisk/trunks/
chown -R root:root /etc/asterisk/trunks/
chmod 755 /etc/asterisk/trunks/
echo -e "${GREEN}✓ Directorio de trunks configurado${NC}"
echo ""

# Paso 5: Configurar pjsip_custom.conf
echo -e "${GREEN}[5/6] Configurando pjsip_custom.conf...${NC}"
PJSIP_CUSTOM="/etc/asterisk/pjsip_custom.conf"
INCLUDE_LINE="#include trunks/*.conf"

# Verificar si el archivo existe
if [ ! -f "$PJSIP_CUSTOM" ]; then
    echo "$INCLUDE_LINE" > "$PJSIP_CUSTOM"
    echo -e "${GREEN}✓ Archivo pjsip_custom.conf creado${NC}"
else
    # Verificar si la línea ya existe
    if ! grep -q "$INCLUDE_LINE" "$PJSIP_CUSTOM"; then
        echo "$INCLUDE_LINE" >> "$PJSIP_CUSTOM"
        echo -e "${GREEN}✓ Línea agregada a pjsip_custom.conf${NC}"
    else
        echo -e "${YELLOW}⚠ La línea ya existe en pjsip_custom.conf${NC}"
    fi
fi
echo ""

# Paso 6: Iniciar el servicio
echo -e "${GREEN}[6/6] Iniciando servicio...${NC}"
systemctl start miapp
sleep 2
systemctl status miapp --no-pager
echo ""

echo "=========================================="
echo -e "${GREEN}¡Instalación completada exitosamente!${NC}"
echo "=========================================="
echo ""
echo "El servicio está corriendo. Para ver el estado:"
echo "  sudo systemctl status miapp"
echo ""
echo "Para ver los logs:"
echo "  sudo journalctl -u miapp -f"
echo ""
echo "Para reiniciar el servicio:"
echo "  sudo systemctl restart miapp"
echo ""


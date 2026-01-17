# Gestión de Trunks Asterisk

Aplicación Node.js para gestionar trunks de Asterisk mediante API REST.

## Instalación Automática

### Opción 1: Instalación desde GitHub (Recomendado)

```bash
# Clonar el repositorio
git clone <URL_DEL_REPOSITORIO>
cd app

# Ejecutar el script de instalación
sudo bash install.sh
```

### Opción 2: Instalación Manual

Si prefieres instalar manualmente, sigue estos pasos:

```bash
# 1. Navegar al directorio
cd app

# 2. Instalar dependencias
npm install

# 3. Crear servicio systemd
sudo nano /etc/systemd/system/miapp.service
# Pegar el contenido de miapp.service

# 4. Configurar servicios
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable miapp
sudo systemctl start miapp

# 5. Configurar directorio de trunks
sudo mkdir -p /etc/asterisk/trunks/
sudo chown -R root:root /etc/asterisk/trunks/
sudo chmod 755 /etc/asterisk/trunks/

# 6. Configurar pjsip_custom.conf
sudo nano /etc/asterisk/pjsip_custom.conf
# Agregar: #include trunks/*.conf

# 7. Reiniciar servicio
sudo systemctl restart miapp
sudo systemctl status miapp
```

## Uso

El servicio se ejecuta en el puerto `56201` por defecto.

### Agregar un Trunk

```bash
curl -X POST http://localhost:56201/add-trunk \
  -H "Content-Type: application/json" \
  -d '{
    "username": "usuario",
    "password": "contraseña",
    "server": "servidor.com",
    "type": "twilio"
  }'
```

Tipos disponibles: `twilio`, `plivo`, `telnyx`, `vonage`, `signalwire`, `custom`

### Eliminar un Trunk

```bash
curl -X DELETE http://localhost:56201/delete-trunk/Trunk_XXXXX
```

## Gestión del Servicio

```bash
# Ver estado
sudo systemctl status miapp

# Ver logs
sudo journalctl -u miapp -f

# Reiniciar
sudo systemctl restart miapp

# Detener
sudo systemctl stop miapp

# Iniciar
sudo systemctl start miapp
```

## Requisitos

- Node.js instalado
- Asterisk configurado
- Permisos de root para la instalación

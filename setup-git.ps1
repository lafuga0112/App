# Script para inicializar Git y preparar para GitHub
# Ejecutar desde el directorio del proyecto

Write-Host "Inicializando repositorio Git..." -ForegroundColor Green
git init

Write-Host "Agregando archivos..." -ForegroundColor Green
git add .

Write-Host "Creando commit inicial..." -ForegroundColor Green
git commit -m "Initial commit: Aplicación de gestión de trunks Asterisk con script de instalación automática"

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "¡Repositorio Git inicializado!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Siguiente paso:" -ForegroundColor Yellow
Write-Host "1. Ve a https://github.com y crea un nuevo repositorio" -ForegroundColor White
Write-Host "2. NO inicialices con README, .gitignore o licencia" -ForegroundColor White
Write-Host "3. Copia la URL del repositorio (ej: https://github.com/usuario/repo.git)" -ForegroundColor White
Write-Host "4. Ejecuta estos comandos:" -ForegroundColor White
Write-Host ""
Write-Host "   git remote add origin <URL_DEL_REPOSITORIO>" -ForegroundColor Cyan
Write-Host "   git branch -M main" -ForegroundColor Cyan
Write-Host "   git push -u origin main" -ForegroundColor Cyan
Write-Host ""


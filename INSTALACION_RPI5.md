# Guía de Instalación para Raspberry Pi 5

Esta guía proporciona instrucciones en español para configurar y ejecutar el Agente de Voz IA en Raspberry Pi 5 usando Docker.

## Requisitos de Hardware

- **Raspberry Pi 5** (se recomienda 4GB u 8GB de RAM)
- **Tarjeta MicroSD** (32GB o más, Clase 10 o superior)
- **Micrófono USB** o **micrófono de 3.5mm** con adaptador apropiado
- **Altavoces** o **Auriculares** (USB, 3.5mm, o audio HDMI)
- **Fuente de alimentación** (se recomienda la oficial de Raspberry Pi 5)
- **Conexión a Internet** (Ethernet o WiFi)

## Instalación Rápida con Docker

### 1. Instalar Docker en Raspberry Pi 5

```bash
# Descargar e instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Agregar usuario al grupo docker
sudo usermod -aG docker $USER

# Instalar Docker Compose
sudo apt-get install -y docker-compose-plugin

# Reiniciar para aplicar cambios
sudo reboot
```

### 2. Clonar y Configurar la Aplicación

```bash
# Clonar el repositorio
cd ~
git clone https://github.com/xukrutdonut/AI-Voice-Agent.git
cd AI-Voice-Agent

# Copiar archivo de configuración
cp .env.example .env

# Editar y agregar tus claves API
nano .env
```

Actualiza el archivo `.env` con tus claves:
```
DEEPGRAM_API_KEY=tu-clave-deepgram-aqui
OPENAI_API_KEY=tu-clave-openai-aqui
```

**Obtén tus claves API de:**
- Deepgram: https://console.deepgram.com/
- OpenAI: https://platform.openai.com/api-keys

### 3. Configurar Audio

```bash
# Verificar dispositivos de audio
aplay -l    # Listar dispositivos de reproducción
arecord -l  # Listar dispositivos de grabación

# Probar altavoces
speaker-test -t wav -c 2 -l 1

# Probar micrófono (grabar 3 segundos)
arecord -d 3 prueba.wav
aplay prueba.wav
```

### 4. Ejecutar con Docker

```bash
# Construir la imagen Docker
docker compose build

# Ejecutar el contenedor
docker compose up

# O ejecutar en segundo plano
docker compose up -d

# Ver logs (si está en segundo plano)
docker compose logs -f

# Detener el contenedor
docker compose down
```

### 5. Probar Configuración de Audio

Hemos incluido un script de prueba:

```bash
# Ejecutar prueba de audio
./test_audio.sh
```

## Comandos Útiles

```bash
# Ver logs del contenedor
docker compose logs -f

# Reiniciar el contenedor
docker compose restart

# Reconstruir después de cambios
docker compose up --build

# Eliminar contenedor y volúmenes
docker compose down -v
```

## Solución de Problemas Comunes

### Sin Salida de Audio

```bash
# Verificar volumen
amixer sget Master

# Aumentar volumen y activar
amixer sset Master unmute
amixer sset Master 80%
```

### Micrófono No Funciona

```bash
# Verificar que el micrófono está detectado
arecord -l

# Ajustar volumen del micrófono
alsamixer
# Presiona F4 para seleccionar dispositivo de captura
```

### Error de Permisos en Audio

```bash
# Agregar usuario al grupo audio
sudo usermod -aG audio $USER

# Reiniciar
sudo reboot
```

## Personalización

Edita la variable `prompt` en `app.py` para personalizar la personalidad y rol del agente IA para tu caso de uso específico.

## Documentación Completa

Para instrucciones más detalladas, consulta:
- `RPI5_SETUP.md` - Guía completa en inglés con troubleshooting avanzado
- `README.md` - Documentación general del proyecto

## Soporte

Si encuentras problemas:
1. Revisa los logs: `docker compose logs`
2. Ejecuta el script de prueba: `./test_audio.sh`
3. Consulta la documentación completa en `RPI5_SETUP.md`
4. Abre un issue en GitHub

## Características

- Transcripción de voz a texto en tiempo real
- Procesamiento de lenguaje natural con GPT-3.5
- Síntesis de texto a voz
- Memoria de conversación
- Totalmente personalizable

¡Disfruta tu Agente de Voz IA!

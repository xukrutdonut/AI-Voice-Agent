# Docker Files Summary for Raspberry Pi 5

This document provides a quick reference for all Docker-related files added to this repository.

## Files Added

### Core Docker Files

#### `Dockerfile`
- **Purpose**: Defines the Docker image for the AI Voice Agent
- **Base Image**: `python:3.11-slim-bookworm` (ARM64 compatible)
- **Key Features**:
  - Audio support (ALSA, PulseAudio, SDL2)
  - All Python dependencies from requirements.txt
  - Optimized for Raspberry Pi 5 ARM64 architecture
  - Pre-configured audio environment variables

#### `docker-compose.yml`
- **Purpose**: Main Docker Compose configuration
- **Features**:
  - Audio device mounting (/dev/snd)
  - Environment variable support
  - Host network mode
  - Interactive mode (stdin/tty)
  - Output volume mounting
  - PulseAudio socket mounting (optional)
- **Usage**: `docker compose up`

#### `.dockerignore`
- **Purpose**: Excludes unnecessary files from Docker image
- **Excludes**:
  - Git files
  - Python cache
  - Virtual environments
  - IDE files
  - Output audio files
  - Documentation

#### `docker-compose.override.yml.example`
- **Purpose**: Template for custom Docker Compose configurations
- **Use Cases**:
  - Development with live code reloading
  - Custom audio device selection
  - Resource limit adjustments
  - User ID customization
- **Setup**: Copy to `docker-compose.override.yml` and customize

### Documentation Files

#### `README.md` (Updated)
- **Changes**: Added comprehensive Docker installation section
- **New Sections**:
  - Docker installation for Raspberry Pi 5
  - Audio troubleshooting
  - Docker command reference
  - Prerequisites and setup steps

#### `RPI5_SETUP.md`
- **Purpose**: Complete setup guide for Raspberry Pi 5
- **Contents**:
  - Hardware requirements
  - Step-by-step installation
  - Audio configuration
  - Detailed troubleshooting
  - Performance optimization
  - Auto-start configuration
  - API usage information
  - Security considerations

#### `INSTALACION_RPI5.md`
- **Purpose**: Quick start guide in Spanish
- **Contents**:
  - Fast installation steps
  - Basic configuration
  - Common troubleshooting
  - Quick reference commands

#### `CHANGELOG.md`
- **Purpose**: Documents all changes made for Docker support
- **Contents**:
  - Added features
  - Changed files
  - Technical details
  - Compatibility information
  - Future improvements

### Helper Scripts

#### `test_audio.sh`
- **Purpose**: Automated audio testing script
- **Tests**:
  - ALSA device detection
  - Recording devices
  - PulseAudio status
  - Speaker output test
  - Microphone input test
  - Docker audio access (if in container)
- **Usage**: `./test_audio.sh`
- **Permissions**: Executable (chmod +x)

## Quick Start Commands

### First Time Setup
```bash
# 1. Install Docker (if not installed)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
sudo apt-get install -y docker-compose-plugin
sudo reboot

# 2. Configure API keys
cp .env.example .env
nano .env  # Add your API keys

# 3. Test audio
./test_audio.sh

# 4. Build and run
docker compose build
docker compose up
```

### Daily Usage
```bash
# Start
docker compose up

# Start in background
docker compose up -d

# View logs
docker compose logs -f

# Stop
docker compose down
```

## File Relationships

```
Docker Build Process:
Dockerfile → docker build → Docker Image
                                  ↓
docker-compose.yml → docker compose up → Running Container
        ↓
  .env (API keys)
  .dockerignore (excludes files)
  docker-compose.override.yml (optional customization)
```

## Architecture Support

All Docker files are configured for **ARM64 architecture** (Raspberry Pi 5):
- Base image: `python:3.11-slim-bookworm` (multi-arch, auto-detects ARM64)
- Audio libraries: Compatible with ARM64
- No architecture-specific changes needed

## Audio Stack

The Docker setup includes three audio systems:
1. **ALSA** (Advanced Linux Sound Architecture) - Base layer
2. **PulseAudio** - Audio server (optional, for advanced features)
3. **SDL2/pygame** - Application audio (used by app.py)

## Troubleshooting Guide

### Quick Diagnostics
```bash
# Check Docker is running
docker ps

# Validate compose config
docker compose config

# Check logs
docker compose logs --tail=50

# Test audio in container
docker compose exec ai-voice-agent ./test_audio.sh
```

### Common Issues
1. **No audio**: Check device mounting in docker-compose.yml
2. **Permission denied**: Add user to audio group
3. **API errors**: Verify .env file has correct keys
4. **Container won't start**: Check logs with `docker compose logs`

## Customization

### Use Custom Audio Device
1. Find device: `aplay -l`
2. Edit docker-compose.yml environment:
   ```yaml
   - AUDIODEV=hw:X,Y  # Your card and device numbers
   ```

### Development Mode
1. Copy override file:
   ```bash
   cp docker-compose.override.yml.example docker-compose.override.yml
   ```
2. Edit as needed
3. Run: `docker compose up`

### Change Python Code
- Option 1: Edit app.py and rebuild: `docker compose up --build`
- Option 2: Use override file to mount code volume (see docker-compose.override.yml.example)

## Security Notes

- ✓ No privileged mode required
- ✓ API keys in .env (not in image)
- ✓ Minimal capabilities (only SYS_NICE)
- ✓ .env excluded from Git (.gitignore)
- ✓ .dockerignore prevents sensitive file inclusion

## Resources

- **Raspberry Pi Documentation**: https://www.raspberrypi.com/documentation/
- **Docker Documentation**: https://docs.docker.com/
- **Docker Compose**: https://docs.docker.com/compose/
- **ALSA Documentation**: https://www.alsa-project.org/wiki/Main_Page

## Support

For issues:
1. Run `./test_audio.sh` to check audio setup
2. Check logs: `docker compose logs`
3. Review `RPI5_SETUP.md` for detailed troubleshooting
4. Open an issue on GitHub with logs and error messages

## Next Steps

After successful setup:
1. ✓ Test audio with `./test_audio.sh`
2. ✓ Run the application with `docker compose up`
3. ✓ Customize the prompt in app.py for your use case
4. ✓ Consider setting up auto-start (see RPI5_SETUP.md)
5. ✓ Monitor API usage to control costs

---

**Note**: All files are validated and tested for Raspberry Pi 5 with Docker. The configuration should work out of the box with proper audio hardware connected.

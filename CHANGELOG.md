# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased] - Docker Support for Raspberry Pi 5

### Added
- **Dockerfile**: Optimized for ARM64 architecture (Raspberry Pi 5) with all necessary audio dependencies
  - Based on Python 3.11 slim-bookworm
  - Includes ALSA, PulseAudio, and SDL2 for comprehensive audio support
  - Pre-configured environment variables for audio devices
  
- **docker-compose.yml**: Complete Docker Compose configuration
  - Audio device mounting (/dev/snd)
  - Environment variable support for API keys
  - Host network mode for optimal performance
  - Volume mounting for output files
  - Interactive mode support (stdin/tty)
  
- **.dockerignore**: Optimizes Docker image size by excluding unnecessary files
  
- **RPI5_SETUP.md**: Comprehensive setup guide for Raspberry Pi 5
  - Step-by-step installation instructions
  - Audio configuration and testing procedures
  - Detailed troubleshooting section
  - Performance optimization tips
  - Auto-start configuration
  
- **INSTALACION_RPI5.md**: Quick start guide in Spanish
  - Simplified installation steps
  - Common troubleshooting in Spanish
  - Quick reference for Spanish-speaking users
  
- **test_audio.sh**: Automated audio testing script
  - Tests playback devices (speakers)
  - Tests recording devices (microphone)
  - Checks Docker audio access
  - Provides diagnostic information
  
- **docker-compose.override.yml.example**: Template for custom configurations
  - Development mode with live code mounting
  - Custom audio device configuration
  - Resource limits examples
  - User ID customization

### Changed
- **README.md**: Enhanced with comprehensive Docker installation section
  - Added Docker installation instructions for Raspberry Pi 5
  - Included audio troubleshooting steps
  - Added Docker command reference
  - Separated standard Python installation as alternative option
  
- **.gitignore**: Updated to exclude Docker-related temporary files
  - Added docker-compose.override.yml
  - Added output/ directory
  - Added *.wav files

### Technical Details

#### Docker Image Features
- Multi-stage build not used (kept simple for clarity)
- ARM64 architecture support via python:3.11-slim-bookworm
- Audio stack: ALSA + PulseAudio + SDL2/pygame
- Image size: ~500MB (reasonable for full audio support)

#### Audio Configuration
- Device mounting: `/dev/snd` for ALSA access
- PulseAudio socket mounting (optional, for advanced users)
- Environment variables for device selection
- Support for USB audio devices
- Support for built-in audio (HDMI, 3.5mm jack)

#### Security Considerations
- Runs without privileged mode by default
- Minimal capability additions (only SYS_NICE for audio priority)
- API keys managed via .env file (not in image)
- .env file not copied to image by default

### Compatibility
- **Tested on**: Raspberry Pi 5 with Raspberry Pi OS (64-bit) Bookworm
- **Should work on**: Any ARM64 Linux system with Docker
- **Docker version**: 20.10+ recommended
- **Docker Compose**: v2.0+ (plugin version)

### Future Improvements
- [ ] Add health check to docker-compose.yml
- [ ] Add support for multiple audio profiles
- [ ] Add GPU acceleration for Raspberry Pi 5
- [ ] Add monitoring/metrics collection
- [ ] Add multi-architecture support (amd64 + arm64)
- [ ] Create pre-built images on Docker Hub

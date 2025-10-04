# Use Python 3.11 slim image for ARM64 architecture (Raspberry Pi 5)
FROM python:3.11-slim-bookworm

# Set working directory
WORKDIR /app

# Install system dependencies required for audio support on Raspberry Pi
# - portaudio19-dev: Required for PyAudio/microphone support
# - libasound2-dev: ALSA sound library for audio playback
# - libsdl2-dev, libsdl2-mixer-2.0-0: SDL2 libraries for pygame
# - pulseaudio: Audio server for better audio device management
RUN apt-get update && apt-get install -y \
    portaudio19-dev \
    libasound2-dev \
    libsdl2-dev \
    libsdl2-mixer-2.0-0 \
    pulseaudio \
    alsa-utils \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY app.py .
COPY .env.example .env

# Create directory for audio output files
RUN mkdir -p /app/output

# Set environment variables for audio support
ENV PULSE_SERVER=unix:/run/user/1000/pulse/native
ENV SDL_AUDIODRIVER=alsa
ENV AUDIODEV=hw:0,0

# Expose any ports if needed (currently not used)
# EXPOSE 8000

# Run the application
CMD ["python", "app.py"]

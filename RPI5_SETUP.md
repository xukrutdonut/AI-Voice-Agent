# Raspberry Pi 5 Setup Guide for AI Voice Agent

This guide provides detailed instructions for setting up and running the AI Voice Agent on Raspberry Pi 5 using Docker.

## Hardware Requirements

- **Raspberry Pi 5** (4GB or 8GB RAM recommended)
- **MicroSD card** (32GB or larger, Class 10 or better)
- **USB Microphone** or **3.5mm microphone** with appropriate adapter
- **Speakers** or **Headphones** (USB, 3.5mm, or HDMI audio)
- **Power supply** (Official Raspberry Pi 5 power supply recommended)
- **Internet connection** (Ethernet or WiFi)

## Software Requirements

- Raspberry Pi OS (64-bit) - Bookworm or newer
- Docker and Docker Compose
- Active internet connection for API calls

## Step-by-Step Installation

### 1. Prepare Raspberry Pi 5

```bash
# Update system packages
sudo apt-get update
sudo apt-get upgrade -y

# Install essential tools
sudo apt-get install -y git curl
```

### 2. Install Docker

```bash
# Download and install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add current user to docker group (avoid using sudo)
sudo usermod -aG docker $USER

# Install Docker Compose plugin
sudo apt-get install -y docker-compose-plugin

# Verify installation
docker --version
docker compose version

# Apply group changes (logout/login or reboot)
sudo reboot
```

### 3. Configure Audio

#### Enable Audio Devices

```bash
# Check if audio is enabled in config
sudo nano /boot/firmware/config.txt
```

Ensure these lines are present and uncommented:
```
dtparam=audio=on
```

Save and reboot if you made changes:
```bash
sudo reboot
```

#### Test Audio Setup

```bash
# List playback devices
aplay -l

# List recording devices
arecord -l

# Test speakers (you should hear sound)
speaker-test -t wav -c 2 -l 1

# Test microphone (record 3 seconds)
arecord -d 3 test.wav

# Play back recording
aplay test.wav

# Clean up
rm test.wav
```

### 4. Clone and Configure the Application

```bash
# Clone repository
cd ~
git clone https://github.com/xukrutdonut/AI-Voice-Agent.git
cd AI-Voice-Agent

# Copy environment template
cp .env.example .env

# Edit configuration file
nano .env
```

Add your API keys to `.env`:
```
DEEPGRAM_API_KEY=your-actual-deepgram-key-here
OPENAI_API_KEY=your-actual-openai-key-here
```

**Important:** Get your API keys from:
- Deepgram: https://console.deepgram.com/
- OpenAI: https://platform.openai.com/api-keys

### 5. Run with Docker

```bash
# Build the Docker image
docker compose build

# Run the container (interactive mode)
docker compose up

# Or run in background (detached mode)
docker compose up -d

# View logs if running in background
docker compose logs -f

# Stop the container
docker compose down
```

### 6. Using the Audio Test Script

We've included a helpful script to test your audio setup:

```bash
# Run audio test
./test_audio.sh
```

This script will:
- List all audio devices
- Test speaker output
- Test microphone input
- Check Docker audio access (if applicable)

## Docker Configuration Details

### Audio Device Access

The `docker-compose.yml` is configured to:
- Mount `/dev/snd` for ALSA audio device access
- Set appropriate environment variables for audio
- Use host network mode for better audio performance

### Customizing Audio Settings

If you need to use a specific audio device:

1. Find your device number:
```bash
aplay -l
```

2. Update the environment in `docker-compose.yml`:
```yaml
environment:
  - AUDIODEV=hw:X,Y  # Replace X,Y with your card and device numbers
```

## Troubleshooting

### Issue: No Audio Output

**Solution:**
```bash
# Check audio routing
amixer sget Master

# Unmute and increase volume
amixer sset Master unmute
amixer sset Master 80%

# Select audio output (0=auto, 1=headphones, 2=HDMI)
sudo raspi-config
# Navigate to: System Options → Audio
```

### Issue: Microphone Not Working

**Solution:**
```bash
# Check if microphone is detected
arecord -l

# Test microphone with higher volume
arecord -d 3 -f cd test.wav
aplay test.wav

# Adjust microphone volume
alsamixer
# Press F4 to select capture device
# Use arrow keys to adjust levels
```

### Issue: Docker Cannot Access Audio

**Solution:**
```bash
# Check audio device permissions
ls -l /dev/snd/

# Add user to audio group
sudo usermod -aG audio $USER

# Reboot to apply changes
sudo reboot

# Verify group membership
groups $USER
```

### Issue: "Permission Denied" on Audio Devices

**Solution:**
```bash
# Check current user's groups
groups

# Should include: audio, video

# If not, add to groups:
sudo usermod -aG audio $USER
sudo usermod -aG video $USER

# Logout and login again, or reboot
sudo reboot
```

### Issue: Poor Audio Quality or Latency

**Solutions:**
1. Use a USB audio device instead of built-in audio
2. Reduce CPU load by closing other applications
3. Use a powered USB hub for USB audio devices
4. Adjust buffer sizes in PulseAudio config if using it

### Issue: Container Keeps Restarting

**Solution:**
```bash
# Check logs for errors
docker compose logs

# Common issues:
# - Missing API keys in .env file
# - Audio device not accessible
# - Network issues

# Verify .env file
cat .env

# Test API connectivity
curl https://api.deepgram.com/v1/listen
```

## Performance Optimization

### For Better Performance on Raspberry Pi 5

1. **Use 64-bit OS:** Ensure you're running Raspberry Pi OS 64-bit
2. **Overclock (optional):** Only if needed and with proper cooling
3. **Close unnecessary applications:** Free up RAM and CPU
4. **Use Ethernet:** More stable than WiFi for API calls
5. **Monitor temperature:** Keep Pi cool for sustained performance

```bash
# Check CPU temperature
vcgencmd measure_temp

# Monitor resource usage
htop
```

## API Usage and Costs

### Deepgram
- **STT (Speech-to-Text):** ~$0.0043 per minute
- **TTS (Text-to-Speech):** ~$0.015 per 1,000 characters

### OpenAI
- **GPT-3.5-turbo:** ~$0.0015 per 1,000 input tokens, ~$0.002 per 1,000 output tokens

**Tip:** Monitor your API usage in the respective dashboards to avoid unexpected costs.

## Auto-Start on Boot (Optional)

To run the AI Voice Agent automatically when Raspberry Pi boots:

```bash
# Create systemd service
sudo nano /etc/systemd/system/ai-voice-agent.service
```

Add this content:
```ini
[Unit]
Description=AI Voice Agent Docker Container
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/home/pi/AI-Voice-Agent
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
User=pi

[Install]
WantedBy=multi-user.target
```

Enable and start:
```bash
sudo systemctl enable ai-voice-agent.service
sudo systemctl start ai-voice-agent.service

# Check status
sudo systemctl status ai-voice-agent.service
```

## Security Considerations

1. **API Keys:** Never commit `.env` file to git or share it
2. **Network:** Use firewall if exposing services
3. **Updates:** Keep Docker and system packages updated
4. **Monitoring:** Monitor API usage to prevent abuse

## Additional Resources

- [Raspberry Pi Documentation](https://www.raspberrypi.com/documentation/)
- [Docker Documentation](https://docs.docker.com/)
- [Deepgram API Documentation](https://developers.deepgram.com/)
- [OpenAI API Documentation](https://platform.openai.com/docs/)

## Support

For issues specific to:
- **This application:** Open an issue on GitHub
- **Raspberry Pi:** Check Raspberry Pi forums
- **Docker:** Check Docker documentation
- **Audio setup:** Check ALSA/PulseAudio documentation

## Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.

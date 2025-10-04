# AI-Voice-Agent
Self-hosted AI voice agent

Open-source AI agent which can handle voice calls and respond back in real-time. Can be used for many use-cases such as sales calls, customer support etc.

### Youtube Tutorial -> https://youtu.be/77xnx26dyYU

### Medium Article -> https://medium.com/@anilmatcha/ai-voice-agent-how-to-build-one-in-minutes-a-comprehensive-guide-032a79a1ac1e

### Requirements

Python 3.11

Deepgram and OpenAI key

## Installation Options

### Option 1: Docker on Raspberry Pi 5 (Recommended)

This is the easiest way to run the AI Voice Agent on Raspberry Pi 5 with all audio dependencies pre-configured.

#### Prerequisites for Raspberry Pi 5

1. **Raspberry Pi 5** with Raspberry Pi OS (64-bit) installed
2. **Docker and Docker Compose** installed on your Raspberry Pi
3. **Microphone and speakers** connected to your Raspberry Pi
4. **Deepgram API key** - Get it from [Deepgram](https://deepgram.com/)
5. **OpenAI API key** - Get it from [OpenAI](https://openai.com/)

#### Install Docker on Raspberry Pi 5

If you don't have Docker installed, run these commands:

```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add your user to the docker group
sudo usermod -aG docker $USER

# Install Docker Compose
sudo apt-get install docker-compose-plugin

# Reboot to apply changes
sudo reboot
```

#### Setup and Run with Docker

1. **Clone the repository:**
```bash
git clone https://github.com/xukrutdonut/AI-Voice-Agent.git
cd AI-Voice-Agent
```

2. **Configure API keys:**
```bash
# Copy the example environment file
cp .env.example .env

# Edit the .env file and add your API keys
nano .env
```

Update the `.env` file with your keys:
```
DEEPGRAM_API_KEY=your-deepgram-api-key-here
OPENAI_API_KEY=your-openai-api-key-here
```

3. **Configure audio devices (if needed):**
```bash
# List available audio devices
aplay -l

# Test microphone
arecord -d 5 test.wav
aplay test.wav
```

4. **Build and run with Docker Compose:**
```bash
# Build the Docker image
docker compose build

# Run the container
docker compose up
```

The application will start and connect to your microphone. Press Enter in the terminal to stop recording.

#### Docker Commands

```bash
# Run in detached mode (background)
docker compose up -d

# View logs
docker compose logs -f

# Stop the container
docker compose down

# Rebuild after changes
docker compose up --build
```

#### Troubleshooting Audio on Raspberry Pi 5

If you encounter audio issues:

1. **Check audio devices:**
```bash
# Inside the container
docker compose exec ai-voice-agent aplay -l
docker compose exec ai-voice-agent arecord -l
```

2. **Test audio output:**
```bash
speaker-test -t wav -c 2
```

3. **Configure audio card:**
Edit `/boot/config.txt` and ensure:
```
dtparam=audio=on
```

4. **PulseAudio configuration:**
If using PulseAudio, ensure it's running:
```bash
pulseaudio --check
pulseaudio --start
```

### Option 2: Standard Python Installation

#### Steps to run

Open .env file and setup Deepgram and OpenAI api key

Create a virtualenv and install depends from requirements.txt using below command

```bash
pip install -r requirements.txt
```

Run the app using below command

```bash
python app.py
```

## Usage

Once the application is running:
1. Speak into your microphone
2. The AI agent will transcribe your speech using Deepgram
3. Process your request using OpenAI GPT
4. Respond back with synthesized speech
5. Press Enter to stop the recording

## Features

- Real-time speech-to-text transcription
- Natural language processing with GPT-3.5
- Text-to-speech synthesis
- Voice conversation memory
- Restaurant receptionist demo (can be customized)

## Customization

Edit the `prompt` variable in `app.py` to customize the AI agent's personality and role for your specific use case.

#!/bin/bash
# Audio testing script for Raspberry Pi 5

echo "==================================="
echo "Audio Setup Test for Raspberry Pi 5"
echo "==================================="
echo ""

# Check if running on Raspberry Pi
if [ -f /proc/device-tree/model ]; then
    MODEL=$(cat /proc/device-tree/model)
    echo "Device: $MODEL"
    echo ""
fi

# Test 1: Check ALSA devices
echo "Test 1: Checking ALSA audio devices..."
echo "---------------------------------------"
aplay -l
echo ""

# Test 2: Check recording devices
echo "Test 2: Checking recording devices..."
echo "---------------------------------------"
arecord -l
echo ""

# Test 3: Check PulseAudio (if available)
echo "Test 3: Checking PulseAudio..."
echo "---------------------------------------"
if command -v pulseaudio &> /dev/null; then
    pulseaudio --check && echo "PulseAudio is running" || echo "PulseAudio is not running"
    if command -v pactl &> /dev/null; then
        echo "Audio sinks:"
        pactl list short sinks
        echo "Audio sources:"
        pactl list short sources
    fi
else
    echo "PulseAudio is not installed"
fi
echo ""

# Test 4: Test speaker output
echo "Test 4: Testing speaker output..."
echo "---------------------------------------"
echo "Playing a test sound (2 seconds)..."
speaker-test -t wav -c 2 -l 1 2>/dev/null || echo "Speaker test failed. Please check your audio output connection."
echo ""

# Test 5: Test microphone input
echo "Test 5: Testing microphone input..."
echo "---------------------------------------"
echo "Recording 3 seconds of audio from microphone..."
arecord -d 3 -f cd /tmp/test_recording.wav 2>/dev/null
if [ -f /tmp/test_recording.wav ]; then
    echo "Recording successful. Playing back..."
    aplay /tmp/test_recording.wav 2>/dev/null
    rm /tmp/test_recording.wav
    echo "If you heard your voice, the microphone is working!"
else
    echo "Recording failed. Please check your microphone connection."
fi
echo ""

# Test 6: Check Docker audio access (if in Docker)
if [ -f /.dockerenv ]; then
    echo "Test 6: Docker audio device access..."
    echo "---------------------------------------"
    if [ -e /dev/snd ]; then
        echo "✓ /dev/snd is accessible"
        ls -la /dev/snd/
    else
        echo "✗ /dev/snd is not accessible - audio devices not mounted"
    fi
    echo ""
fi

echo "==================================="
echo "Audio test complete!"
echo "==================================="
echo ""
echo "If all tests passed, your audio setup is ready for the AI Voice Agent."
echo "If any test failed, please check:"
echo "  1. Audio cables are properly connected"
echo "  2. Audio devices are not muted (run 'alsamixer')"
echo "  3. User has permission to access audio devices"
echo "  4. Docker has access to /dev/snd (if running in container)"

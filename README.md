<div align="center">
  <img src="./assets/logo.png" alt="AIMind Logo" width="200"/>
  
  # AIMind
  ### Your Virtual Psychology Companion
</div>

## Overview

**AIMind** is a virtual psychologist mobile application powered by Llama 4 AI that provides mental health support through conversational therapy, Cognitive Behavioral Therapy (CBT) exercises, and therapeutic journaling.

## Problem Statement

Mental health support faces significant barriers:
- Limited access to professional therapists
- High costs and long waiting times
- Lack of immediate support during difficult moments
- Need for consistent therapeutic practice

## Solution

An AI-powered mental health companion providing 24/7 conversational support, evidence-based CBT exercises, and private therapeutic journaling in a safe, judgment-free space.

## Tech Stack

- **Mobile**: Flutter (Dart)
- **Backend**: Supabase (Auth, PostgreSQL, Storage)
- **AI Model**: Llama 4 (Meta)
- **Architecture**: Clean Architecture / MVVM

## Key Features

### AI Chatbot
- Natural conversation powered by Llama 4
- Empathetic responses and active listening
- Crisis detection and resources
- Context-aware conversations

### CBT Exercises
- Thought challenging worksheets
- Mood tracking and analysis
- Breathing and relaxation exercises
- Cognitive restructuring tools
- Progress tracking

### Therapeutic Journal
- Private, encrypted entries
- Mood and emotion logging
- Reflection prompts
- Search and filter entries

## Installation
```bash
# Clone repository
git clone https://github.com/your-org/aimind.git
cd aimind

# Install dependencies
flutter pub get

# Configure environment
cp .env.example .env
# Add your credentials to .env

# Run the app
flutter run
```

## Security & Privacy

- End-to-end encryption for journal entries
- Supabase Row Level Security
- No personal data shared with third parties
- Secure authentication

## Testing
```bash
# Run tests
flutter test

# Build for production
flutter build apk --release
```

## Disclaimer

**AIMind is not a replacement for professional mental health care.** Users experiencing severe mental health issues should seek help from qualified professionals.

## Team

This project was developed collaboratively by a team of Computer Systems Engineering students.

# Hathora deployment example

This project consists of two Hathora applications that work together to provide AI voice conversations:

1. **Pipecat Runner** - Manages session creation and bot spawning
2. **Pipecat Bot** - Handles the actual AI conversation logic

This architecture allows for better resource management and scalability by separating session orchestration from bot execution.

For this example, we are using Daily as a WebRTC transport and provisioning a new room and token for each session. You can use another transport, such as WebSockets, by modifying the `bot.py` and `bot_runner.py` files accordingly.

## Running locally

### Install dependencies

```bash
pip install -r requirements.txt
```

### Create your .env file

Copy the base `env.example` to `.env` and enter the necessary API keys.

### Run the bot runner

```bash
python bot_runner.py
```

## Setting up your Hathora deployment

This project requires two separate Hathora applications:

### Application 1: Pipecat Runner

1. Create a new application in the Hathora dashboard
2. Deploy `bot_runner.py` as the main entry point. You can use our [CLI](https://hathora.dev/docs/hathora-cli) or [Console UI](https://console.hathora.dev/applications).
3. Set application type to Load balanced.
4. Set the following environment variables in the Hathora dashboard:
   - `DAILY_API_KEY` - Your Daily.co API key
   - `OPENAI_API_KEY` - Your OpenAI API key  
   - `ELEVENLABS_API_KEY` - Your ElevenLabs API key
   - `ELEVENLABS_VOICE_ID` - Your ElevenLabs voice ID
   - `HATHORA_TOKEN` - Your Hathora API token
   - `HATHORA_APP_ID_BOTS` - The application ID of your second Hathora app (see below)
5. Configure the port to match your runner (default: 7860)
6. This application handles incoming session requests and spawns bot instances

### Application 2: Pipecat Bot

1. Create a second application in the Hathora dashboard
2. Deploy `bot.py` as the main entry point. You can use our [CLI](https://hathora.dev/docs/hathora-cli) or [Console UI](https://console.hathora.dev/applications).
3. Set application type to process ingress. This will return a unique host:port for the bot so users connect directly to the process.
3. Set the same environment variables as above (except `HATHORA_APP_ID_BOTS` is not needed)
4. This application runs the actual AI conversation logic
5. Copy this application's ID and set it as `HATHORA_APP_ID_BOTS` in Application 1

### Required Environment Variables

Both applications need these environment variables configured in the Hathora dashboard:

```
DAILY_API_KEY=your_daily_api_key
OPENAI_API_KEY=your_openai_api_key
ELEVENLABS_API_KEY=your_elevenlabs_api_key
ELEVENLABS_VOICE_ID=your_elevenlabs_voice_id
HATHORA_TOKEN=your_hathora_api_token
```

Additionally, the Runner application needs:
```
HATHORA_APP_ID_BOTS=your_bot_app_id
```

## Connecting to your bot

Send a POST request to your Pipecat Runner Hathora instance:

```bash
curl --location --request POST 'https://YOUR_HATHORA_RUNNER_URL/'
```

This request will create a new bot session and return a room URL and token to join the conversation.

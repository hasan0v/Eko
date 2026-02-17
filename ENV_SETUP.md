# Environment Variables Setup

This project uses environment variables to securely store API keys and sensitive configuration.

## Setup Instructions

1. **Copy the example file:**
   ```bash
   cp .env.example .env
   ```

2. **Edit `.env` file with your actual credentials:**

   ```env
   # Supabase Configuration
   SUPABASE_URL=your_supabase_project_url
   SUPABASE_ANON_KEY=your_supabase_anon_key

   # Gemini AI Configuration
   GEMINI_API_KEY=your_gemini_api_key
   ```

3. **Get your credentials:**

   ### Supabase:
   - Go to [Supabase Dashboard](https://app.supabase.com)
   - Select your project
   - Go to Settings → API
   - Copy `Project URL` → `SUPABASE_URL`
   - Copy `anon public` key → `SUPABASE_ANON_KEY`

   ### Gemini AI:
   - Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Create an API key
   - Copy the key → `GEMINI_API_KEY`

## Security Notes

⚠️ **IMPORTANT:**
- **NEVER** commit the `.env` file to version control
- The `.env` file is already in `.gitignore`
- Only commit `.env.example` with placeholder values
- Keep your API keys secure and rotate them regularly

## For Team Members

When cloning this repository:
1. Copy `.env.example` to `.env`
2. Contact the project admin to get the actual API keys
3. Add your keys to the `.env` file

## Running the App

After setting up your `.env` file:

```bash
flutter pub get
flutter run
```

The app will automatically load environment variables on startup.

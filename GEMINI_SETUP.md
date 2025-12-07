# Gemini AI Setup Guide

## 🚀 Getting Your Gemini API Key

### Step 1: Get API Key from Google AI Studio
1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Click "Get API Key" or "Create API Key"
4. Copy your API key

### Step 2: Add API Key to Your App

Open `lib/core/config/gemini_config.dart` and replace `YOUR_API_KEY_HERE` with your actual API key:

```dart
static const String apiKey = 'AIzaSy...your-actual-api-key-here';
```

### Step 3: Install Dependencies

Run the following command:

```bash
flutter pub get
```

### Step 4: Run the App

```bash
flutter run
```

## 🌟 Features

### AI Assistant Capabilities
- **Soil Health Analysis**: NPK balance, pH levels, moisture, organic matter advice
- **Water Management**: Irrigation schedules, water quality, conservation
- **Compost Production**: Composting tips, temperature, moisture, C/N ratio
- **Plant Care**: Disease identification, pest control, crop recommendations
- **Sustainable Farming**: Eco-friendly practices, biodiversity, natural fertilizers

### Quick Response Topics
1. 🌱 **Torpaq Analizi** - Soil health checks
2. 💧 **Suvarma** - Irrigation guidance
3. ♻️ **Kompost** - Composting help
4. 🌾 **Məhsul** - Crop recommendations

## 📝 System Prompt Details

The AI assistant is configured with:
- **Language**: Azerbaijani
- **Expertise**: Agriculture, soil science, water management, composting
- **Tone**: Friendly, supportive, practical
- **Context-Aware**: Uses app sensor data (soil, water, compost)
- **Safety**: Configured with medium harm blocking

## 🔧 Advanced Configuration

### Model Settings (in `gemini_config.dart`):
- **Model**: `gemini-2.0-flash-exp` (fast, efficient)
- **Temperature**: 0.7 (balanced creativity)
- **Max Tokens**: 1024 (concise responses)
- **Top K**: 40
- **Top P**: 0.95

### Context Integration

The chatbot can receive real-time data from your app:

```dart
final response = await _geminiService.sendMessageWithContext(
  userMessage: 'What should I do?',
  soilData: {
    'nitrogen': 4.8,
    'phosphorus': 9.2,
    'potassium': 11.5,
    'ph': 6.5,
    'moisture': 52.3,
  },
);
```

## 🛡️ Security Best Practices

### For Production:
1. **Never commit API keys to version control**
2. Use environment variables:
   ```dart
   static const String apiKey = String.fromEnvironment('GEMINI_API_KEY');
   ```
3. Run with:
   ```bash
   flutter run --dart-define=GEMINI_API_KEY=your-key-here
   ```

### Alternative: Use `.env` file
1. Add `flutter_dotenv` to `pubspec.yaml`
2. Create `.env` file:
   ```
   GEMINI_API_KEY=your-key-here
   ```
3. Add `.env` to `.gitignore`
4. Load in app:
   ```dart
   await dotenv.load();
   final apiKey = dotenv.env['GEMINI_API_KEY'];
   ```

## 🎨 UI Features

- **Modern Chat Interface**: Dark theme with gradient accents
- **Typing Indicator**: Animated dots while AI responds
- **Quick Responses**: Pre-defined farming questions
- **Message Bubbles**: User (green gradient) vs AI (dark glass)
- **Timestamps**: Relative time display
- **Error Handling**: Graceful error messages
- **Clear Chat**: Delete conversation history
- **Auto-scroll**: Automatically scrolls to latest message

## 📱 Testing

Test with these sample questions:
- "Torpağımın pH səviyyəsi 5.2-dir, nə etməliyəm?"
- "Kompost hazırlamağa necə başlayım?"
- "Nə vaxt suvarmalıyam?"
- "Azot səviyyəsi niyə vacibdir?"

## 🐛 Troubleshooting

### API Key Error
```
Error: API key not valid
```
**Solution**: Check your API key in `gemini_config.dart`

### Network Error
```
Error: Failed to connect
```
**Solution**: Check internet connection and firewall settings

### Rate Limit Error
```
Error: Resource exhausted
```
**Solution**: Google AI Studio has free tier limits. Wait or upgrade plan.

## 📚 Resources

- [Google AI Studio](https://makersuite.google.com/)
- [Gemini API Documentation](https://ai.google.dev/docs)
- [Flutter Gemini Package](https://pub.dev/packages/google_generative_ai)

## 💡 Tips

1. **Be Specific**: The more context you provide, the better the AI response
2. **Use Sensor Data**: Share current readings for personalized advice
3. **Follow-up Questions**: The AI maintains conversation context
4. **Clear History**: Start fresh conversations for new topics

---

**Built with ❤️ for Azerbaijani Farmers** 🌾

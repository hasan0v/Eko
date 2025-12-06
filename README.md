# EcoBin Mobile App

**Smart Farming & Sustainability Companion**

EcoBin is a comprehensive Flutter-based mobile application designed to help users manage composting, water irrigation, and soil health through IoT sensors and AI-powered recommendations.

## 📱 Features

### Core Modules
- **🌿 Compost Management**: Real-time monitoring of compost batches with sensor data (temperature, humidity, CO2, weight)
- **💧 Water Management**: Automated irrigation control, water quality monitoring, and usage tracking
- **🌱 Soil Analysis**: NPK nutrient levels, pH monitoring, and AI-powered recommendations
- **📚 Education Center**: Video tutorials and articles about sustainable farming
- **🤖 AI Assistant**: Chatbot for instant answers about farm status and best practices

### Authentication & Onboarding
- Beautiful splash screen with animations
- 3-step onboarding carousel
- Multi-step registration with profile photo upload
- Social login support (Google, Facebook)

### Dashboard
- Personalized greeting based on time of day
- Real-time weather widget
- Quick stats overview (Compost, Water, Temperature, Soil pH)
- Critical alerts system

## 🏗️ Architecture

### Feature-First Structure
```
lib/
├── core/                       # Shared code
│   ├── constants/             # Colors, Strings, Assets
│   ├── theme/                 # Light/Dark themes
│   ├── utils/                 # Helpers & validators
│   ├── widgets/               # Reusable UI components
│   └── services/              # API, Storage, etc.
├── features/                  # Feature modules
│   ├── auth/                  # Authentication & Onboarding
│   ├── dashboard/             # Home screen
│   ├── compost/               # Compost management
│   ├── water/                 # Water management
│   ├── soil/                  # Soil analysis
│   ├── education/             # Learning resources
│   └── chatbot/               # AI assistant
└── models/                    # Data models
```

## 🎨 Design System

### Color Palette
- **Primary**: `#19E624` (Eco Green)
- **Primary Dark**: `#4CAF50`
- **Background Light**: `#F6F8F6`
- **Background Dark**: `#112112`

### Typography
- **Headings**: Lexend (600-700 weight)
- **Body Text**: Inter (400-500 weight)

### Theme Support
- ✅ Light Mode
- ✅ Dark Mode
- Auto-detection based on system preferences

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.29.3 or higher
- Dart 3.7.2 or higher
- Android Studio / VS Code with Flutter extensions
- For iOS: Xcode 15+
- For Android: Android SDK 21+

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd Eko
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
# For Windows
flutter run -d windows

# For Android
flutter run -d android

# For iOS
flutter run -d ios

# For Web
flutter run -d chrome
```

## 📦 Dependencies

### State Management
- `flutter_bloc` - BLoC pattern for state management
- `equatable` - Value equality for models

### Navigation
- `go_router` - Declarative routing

### UI & Styling
- `google_fonts` - Inter & Lexend fonts
- `flutter_svg` - SVG support
- `percent_indicator` - Progress indicators
- `fl_chart` - Beautiful charts
- `liquid_progress_indicator` - Animated water tank
- `shimmer` - Loading skeletons
- `cached_network_image` - Image caching

### Media
- `video_player` & `chewie` - Video playback
- `image_picker` - Photo selection

### Networking & Storage
- `dio` - HTTP client
- `shared_preferences` - Local storage
- `intl` - Internationalization

### Chat & Voice
- `flutter_chat_ui` - Chat interface
- `speech_to_text` - Voice input

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

## 📱 Supported Platforms

- ✅ Android (API 21+)
- ✅ iOS (13.0+)
- ✅ Windows
- ✅ macOS
- ✅ Linux
- ✅ Web

## 🔧 Development Status

### ✅ Completed
- [x] Project setup & architecture
- [x] Theme system (Light/Dark)
- [x] Core constants & assets
- [x] Splash screen with animations
- [x] Onboarding flow (3 screens)
- [x] Login screen with validation
- [x] Multi-step registration
- [x] Home dashboard with navigation
- [x] Bottom navigation bar
- [x] Basic screen placeholders

### 🔄 In Progress
- [ ] State management with BLoC
- [ ] API integration
- [ ] Compost monitoring features
- [ ] Water management features
- [ ] Soil analysis features
- [ ] Education center content
- [ ] AI chatbot integration

### 📋 Planned
- [ ] Real-time data from IoT sensors
- [ ] Push notifications
- [ ] Data export/import
- [ ] Offline mode
- [ ] Multi-language support (Turkish, English)
- [ ] Unit & integration tests
- [ ] App store deployment

## 🌐 Localization

Currently supports:
- English (default)

Planned:
- Turkish (Türkçe)

## 📄 License

This project is proprietary. All rights reserved.

## 👥 Team

- **Project**: EcoBin Smart Farming
- **Platform**: Flutter (Cross-platform)
- **Started**: December 7, 2025

## 📞 Support

For issues, feature requests, or questions, please create an issue in the repository.

## 🔄 Version History

### v1.0.0 (In Development)
- Initial release
- Core features implementation
- Authentication & onboarding
- Dashboard & navigation
- Feature module placeholders

---

**Built with ❤️ using Flutter**

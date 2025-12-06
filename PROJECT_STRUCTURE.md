# 📁 EcoBin Project Structure

```
Eko/
│
├── 📱 android/                     # Android native code
├── 🍎 ios/                         # iOS native code  
├── 🪟 windows/                     # Windows native code
├── 🐧 linux/                       # Linux native code
├── 🍏 macos/                       # macOS native code
├── 🌐 web/                         # Web support files
│
├── 📦 assets/                      # App assets
│   ├── images/                     # Images (logos, backgrounds)
│   ├── icons/                      # SVG icons
│   └── animations/                 # Lottie/JSON animations
│
├── 📚 lib/                         # Main application code
│   │
│   ├── 🎯 main.dart               # App entry point
│   │
│   ├── 🧩 core/                   # Shared/Common code
│   │   ├── constants/
│   │   │   ├── app_colors.dart    ✅ Color palette
│   │   │   ├── app_strings.dart   ✅ All text strings
│   │   │   └── app_assets.dart    ✅ Asset paths
│   │   ├── theme/
│   │   │   └── app_theme.dart     ✅ Light/Dark themes
│   │   ├── utils/
│   │   │   └── validators.dart    🔄 Form validators (TODO)
│   │   ├── widgets/
│   │   │   ├── eco_card.dart      🔄 Reusable card (TODO)
│   │   │   ├── stat_badge.dart    🔄 Status badge (TODO)
│   │   │   └── custom_chart.dart  🔄 Chart widget (TODO)
│   │   └── services/
│   │       ├── api_client.dart    🔄 HTTP client (TODO)
│   │       └── storage.dart       🔄 Local storage (TODO)
│   │
│   ├── 🔐 features/auth/          # Authentication module
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user.dart      🔄 User model (TODO)
│   │   │   └── repositories/
│   │   │       └── auth_repo.dart 🔄 Auth repository (TODO)
│   │   ├── logic/
│   │   │   └── auth_bloc.dart     🔄 Auth BLoC (TODO)
│   │   └── screens/
│   │       ├── splash_screen.dart           ✅ DONE
│   │       ├── onboarding_screen.dart       ✅ DONE
│   │       ├── login_screen.dart            ✅ DONE
│   │       └── registration_screen.dart     ✅ DONE
│   │
│   ├── 🏠 features/dashboard/     # Home dashboard
│   │   ├── logic/
│   │   │   └── dashboard_bloc.dart 🔄 Dashboard BLoC (TODO)
│   │   └── screens/
│   │       └── home_screen.dart    ✅ DONE (basic)
│   │
│   ├── 🌿 features/compost/       # Compost management
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── compost_batch.dart 🔄 Batch model (TODO)
│   │   │   └── repositories/
│   │   │       └── compost_repo.dart  🔄 Repository (TODO)
│   │   ├── logic/
│   │   │   └── compost_bloc.dart      🔄 Compost BLoC (TODO)
│   │   └── screens/
│   │       ├── compost_monitoring_screen.dart    ✅ Placeholder
│   │       ├── compost_history_screen.dart       🔄 TODO
│   │       └── batch_detail_screen.dart          🔄 TODO
│   │
│   ├── 💧 features/water/         # Water management
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── water_tank.dart   🔄 Tank model (TODO)
│   │   │   └── repositories/
│   │   │       └── water_repo.dart   🔄 Repository (TODO)
│   │   ├── logic/
│   │   │   └── water_bloc.dart       🔄 Water BLoC (TODO)
│   │   └── screens/
│   │       ├── water_management_screen.dart      ✅ Placeholder
│   │       └── irrigation_history_screen.dart    🔄 TODO
│   │
│   ├── 🌱 features/soil/          # Soil analysis
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── soil_data.dart    🔄 Soil model (TODO)
│   │   │   └── repositories/
│   │   │       └── soil_repo.dart    🔄 Repository (TODO)
│   │   ├── logic/
│   │   │   └── soil_bloc.dart        🔄 Soil BLoC (TODO)
│   │   └── screens/
│   │       └── soil_analysis_screen.dart         ✅ Placeholder
│   │
│   ├── 📚 features/education/     # Education center
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── content.dart      🔄 Content model (TODO)
│   │   │   └── repositories/
│   │   │       └── education_repo.dart 🔄 Repository (TODO)
│   │   ├── logic/
│   │   │   └── education_bloc.dart    🔄 Education BLoC (TODO)
│   │   └── screens/
│   │       ├── education_center_screen.dart      ✅ Placeholder
│   │       ├── video_player_screen.dart          🔄 TODO
│   │       └── article_reader_screen.dart        🔄 TODO
│   │
│   ├── 🤖 features/chatbot/       # AI Assistant
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── chat_message.dart  🔄 Message model (TODO)
│   │   │   └── repositories/
│   │   │       └── chat_repo.dart     🔄 Repository (TODO)
│   │   ├── logic/
│   │   │   └── chat_bloc.dart         🔄 Chat BLoC (TODO)
│   │   └── screens/
│   │       └── chatbot_screen.dart    ✅ Placeholder
│   │
│   └── 📊 models/                 # Global models
│       ├── sensor_data.dart       🔄 Sensor readings (TODO)
│       └── weather_data.dart      🔄 Weather info (TODO)
│
├── 🧪 test/                       # Unit & Widget tests
│   └── widget_test.dart           🔄 Default test (TODO)
│
├── 📄 Configuration Files
├── pubspec.yaml                   ✅ Dependencies configured
├── analysis_options.yaml          ✅ Linting rules
├── .gitignore                     ✅ Git configuration
│
└── 📖 Documentation
    ├── README.md                  ✅ Project overview
    ├── TODO.md                    ✅ Development roadmap
    ├── DEVELOPMENT_SUMMARY.md     ✅ What's built
    ├── QUICK_START.md             ✅ Getting started guide
    └── PROJECT_STRUCTURE.md       ✅ This file
```

## 📊 Legend

- ✅ **DONE** - Fully implemented and working
- 🔄 **TODO** - Not yet implemented (next phases)
- 📱 Platform-specific code
- 🧩 Core/shared functionality
- 🔐 Feature module
- 🧪 Testing code
- 📄 Configuration
- 📖 Documentation

## 📈 Progress Overview

### Completed (Phase 1-2)
- ✅ Project setup & architecture
- ✅ Theme system
- ✅ Core constants
- ✅ Authentication screens (4 screens)
- ✅ Home dashboard
- ✅ Navigation system
- ✅ Placeholder screens (5 modules)

### In Progress (Phase 3)
- 🔄 Data models
- 🔄 Repositories
- 🔄 BLoC state management
- 🔄 API integration
- 🔄 Reusable widgets

### Upcoming (Phase 4+)
- 📋 Feature implementation (Compost, Water, Soil)
- 📋 Charts & data visualization
- 📋 AI chatbot functionality
- 📋 Education content
- 📋 Testing suite

## 🎯 Key Directories

### 🔥 Hot Development Areas
1. `lib/features/*/screens/` - UI implementation
2. `lib/features/*/logic/` - Business logic (BLoC)
3. `lib/features/*/data/` - Data layer (models, repos)
4. `lib/core/widgets/` - Reusable components

### 📦 Asset Management
- `assets/images/` - PNG/JPG images
- `assets/icons/` - SVG icons
- `assets/animations/` - Lottie files

### ⚙️ Configuration
- `pubspec.yaml` - Dependencies & assets
- `lib/core/constants/` - App-wide constants
- `lib/core/theme/` - Theming

## 🚀 Development Flow

1. **Design** → Create UI in `screens/`
2. **Model** → Define data in `data/models/`
3. **Repository** → API calls in `data/repositories/`
4. **Logic** → State management in `logic/`
5. **Connect** → Wire everything together
6. **Test** → Write tests in `test/`

## 📝 Naming Conventions

### Files
- `snake_case.dart` - All Dart files
- Screens: `*_screen.dart`
- Widgets: `*_widget.dart` or descriptive name
- Models: `*.dart` (singular)
- Repositories: `*_repository.dart`
- BLoCs: `*_bloc.dart`

### Classes
- `PascalCase` - All class names
- Screens: `*Screen`
- Widgets: `*Widget` or descriptive
- Models: Descriptive (e.g., `User`, `CompostBatch`)
- Repositories: `*Repository`
- BLoCs: `*Bloc`

### Variables
- `camelCase` - All variables
- Private: `_camelCase` (with underscore)
- Constants: `SCREAMING_SNAKE_CASE` (in uppercase)

---

**This structure supports scalability, maintainability, and team collaboration.** 🏗️

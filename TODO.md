# EcoBin Mobile App - Development TODO List

## Project Status: In Progress
**Start Date:** December 7, 2025  
**Target Platform:** Flutter (Android & iOS)

---

## Phase 1: Foundation & Setup ✅ COMPLETE
- [x] Create TODO list
- [x] Initialize Flutter project
- [x] Configure pubspec.yaml with dependencies (115 packages)
- [x] Set up project folder structure (Feature-First Architecture)
- [x] Create core constants (colors, strings, assets)
- [x] Implement theme system (Light/Dark mode)
- [x] Successfully builds on Windows (17.6s)

### Dependencies to Add:
```yaml
# State Management
flutter_bloc: ^8.1.3
equatable: ^2.0.5

# Navigation
go_router: ^12.1.3

# UI & Styling
google_fonts: ^6.1.0
flutter_svg: ^2.0.9
percent_indicator: ^4.2.3
fl_chart: ^0.66.0
liquid_progress_indicator: ^0.4.0

# Media
video_player: ^2.8.1
chewie: ^1.7.4
image_picker: ^1.0.5

# Networking & Storage
dio: ^5.4.0
shared_preferences: ^2.2.2
intl: ^0.19.0

# Chat & Voice
flutter_chat_ui: ^1.6.10
speech_to_text: ^6.5.1
```

---

## Phase 2: Authentication & Onboarding ✅ COMPLETE
- [x] **Splash Screen**
  - [x] Create splash animation with EcoBin logo
  - [x] Add version display
  - [x] Implement auto-navigation based on auth state (BlocListener)

- [x] **Onboarding Screens**
  - [x] Create onboarding carousel widget
  - [x] Screen 1: Intelligent Water Management
  - [x] Screen 2: Turn Waste into Treasure
  - [x] Screen 3: Real-time Monitoring
  - [x] Add skip/next buttons
  - [x] Store onboarding completion flag

- [x] **Login Screen**
  - [x] Build login UI (email/password fields)
  - [x] Add form validation
  - [x] Implement social login buttons (Google, Facebook)
  - [x] Add "Forgot Password" link
  - [x] Implement login logic with AuthBloc
  - [x] BlocConsumer for state management
  - [x] Error handling with SnackBar

- [x] **Registration Screen**
  - [x] Multi-step form structure
  - [x] Step 1: Profile photo upload
  - [x] Step 2: Personal info (Name, Phone, Email)
  - [x] Step 3: Password creation
  - [x] Form validation for each step
  - [x] Progress indicator
  - [x] Image picker integration

- [ ] **Forgot Password** (Future Phase)
  - [ ] Email input screen
  - [ ] OTP verification screen
  - [ ] Reset password screen

---✅ COMPLETE
- [x] **Models** (6/6 core models)
  - [x] User model (with Equatable, JSON serialization)
  - [x] CompostBatch model (with status enum, computed properties)
  - [x] SensorData model (IoT sensor readings)
  - [x] WaterTank model (with quality enum, alert methods)
  - [x] SoilAnalysis model (NPK nutrients, health status)
  - [x] WeatherData model (current + forecast)

- [x] **Repositories** (2/7 with mock data)
  - [x] AuthRepository (login, register, logout, updateProfile, passwordReset)
  - [x] CompostRepository (CRUD operations, sensor data)
  - [ ] WaterRepository
  - [ ] SoilRepository
  - [ ] WeatherRepository
  - [ ] EducationRepository
  - [ ] ChatRepository

- [x] **Blocs/Cubits** (2/7 implemented)
  - [x] AuthBloc (6 events, 5 states, full auth flow)
  - [x] CompostBloc (8 events, 7 states, batch management)
  - [ ] ThemeBloc
  - [ ] DashboardBloc
  - [ ] WaterBloc
  - [ ] SoilBloc
  - [ ] ChatBloc

- [x] **Services** (2/4 complete)
  - [x] API Client (Dio with interceptors, error handling)
  - [x] Local Storage Service (SharedPreferences wrapper)
  - [ ] API Client (Dio configuration)
  - [ ] Local Storage Service
  - [ ] Image Upload Service
  - [ ] Notification Service

---

## Phase 4: Dashboard & Navigation 🔄
- [x] **Navigation Shell**
  - [x] Bottom navigation bar✅ COMPLETE (Basic)
- [x] **Navigation Shell**
  - [x] Bottom navigation bar (5 tabs)
  - [x] MaterialApp routing
  - [ ] Navigation routes with go_router (optional enhancement)
  - [ ] Deep linking configuration (future)

- [x] **Home Dashboard**
  - [x] App bar with user greeting
  - [x] Weather widget (current + 5-day forecast)
  - [x] Quick stats grid (4 cards: Compost, Water, Temp, pH)
  - [x] AI chatbot quick access button
  - [ ] Real data from DashboardBloc (Next: Phase 5)
  - [ ] Alerts section (Next: Phase 6)
� IN PROGRESS
- [ ] **Compost Monitoring Screen** (Placeholder exists, needs BLoC integration)
  - [ ] Connect to CompostBloc
  - [ ] Circular progress indicator (compost cycle)
  - [ ] Real-time sensor data grid (Weight, Temp, CO2, Humidity)
  - [ ] "Next Actions" timeline widget
  - [ ] Status badge (Active/Curing/Ready)
  - [ ] Manual control buttons
  - [ ] Pull-to-refresh

- [ ] **Compost History Screen**
  - [ ] List view of past batches
  - [ ] Batch cards with star rating, duration, weight stats
  - [ ] Filter by date range
  - [ ] Detail view for individual batch

- [ ] **Compost Detail Screen**
  - [ ] Full batch information
  - [ ] Sensor data charts over time (fl_chart)
  - [ ] Export batch report

- [ ] **Reusable Widgets**
  - [ ] EcoCard (dashboard cards)
  - [ ] StatBadge (quick stats)
  - [ ] SensorGrid (sensor data display)
  - [ ] CircularProgress (batch progress)
  - [ ] BatchStatusBadgeover time
  - [ ] Export batch report

---

## Phase 6: Water Management Module 💧
- [ ] **Water Management Screen**
  - [ ] Animated water tank level indicator
  - [ ] Auto-irrigate toggle switch
  - [ ] Irrigation schedule calendar view
  - [ ] Water quality grid (pH, DO, Nitrate, EC, Temp, Turbidity)
  - [ ] Manual irrigation trigger

- [ ] **Irrigation History Screen**
  - [ ] Bar chart for weekly water usage
  - [ ] Statistics cards (Total used, Saved, Cost)
  - [ ] Timeline of irrigation events
  - [ ] Filter by date range

- [ ] **Water Tank Animation**
  - [ ] Implement liquid progress indicator
  - [ ] Wave animation
  - [ ] Percentage display

---

## Phase 7: Soil Analysis Module 🌱
- [ ] **Soil Analysis Screen**
  - [ ] Health score gauge (0-100)
  - [ ] NPK nutrient progress bars
  - [ ] Soil moisture chart
  - [ ] AI recommendations section (expandable)
  - [ ] Last updated timestamp
  - [ ] Refresh button

- [ ] **Soil History**
  - [ ] Line chart for nutrient trends
  - [ ] Historical readings table

---

## Phase 8: Education Center 📚
- [ ] **Education Library Screen**
  - [ ] Search bar
  - [ ] Category filters (Composting, Irrigation, Soil, etc.)
  - [ ] Grid/List view of content
  - [ ] Content cards (thumbnail, title, duration/read time)

- [ ] **Video Player Screen**
  - [ ] Implement Chewie video player
  - [ ] Playback controls
  - [ ] Fullscreen mode
  - [ ] Related videos section

- [ ] **Article Reader Screen**
  - [ ] Rich text display
  - [ ] Image support
  - [ ] Bookmark functionality

---

## Phase 9: AI Chatbot 🤖
- [ ] **Chat Interface**
  - [ ] Message list view
  - [ ] Text input field
  - [ ] Voice input button
  - [ ] Send button
  - [ ] Message bubbles (user vs AI)

- [ ] **Rich Responses**
  - [ ] Support for text messages
  - [ ] Embed charts/widgets in chat
  - [ ] Quick action buttons
  - [ ] Typing indicator

- [ ] **Voice Integration**
  - [ ] Implement speech_to_text
  - [ ] Recording animation
  - [ ] Voice waveform visualization

---

## Phase 10: Charts & Data Visualization 📊
- [ ] **Compost Charts**
  - [ ] Temperature trend line chart
  - [ ] CO2 levels over time
  - [ ] Weight reduction graph

- [ ] **Water Charts**
  - [ ] Weekly usage bar chart
  - [ ] Daily consumption line chart
  - [ ] Water quality trends

- [ ] **Soil Charts**
  - [ ] NPK levels over time
  - [ ] Moisture trend chart
  - [ ] pH history graph

---

## Phase 11: Settings & Profile ⚙️
- [ ] **User Profile Screen**
  - [ ] Profile photo display/edit
  - [ ] Personal information
  - [ ] Edit profile functionality

- [ ] **Settings Screen**
  - [ ] Theme toggle (Light/Dark)
  - [ ] Notification preferences
  - [ ] Language selection (Turkish/English)
  - [ ] Units (Metric/Imperial)
  - [ ] About app
  - [ ] Privacy policy
  - [ ] Logout

- [ ] **Notifications**
  - [ ] Local notifications setup
  - [ ] Alert triggers (low water, high temp, compost ready)
  - [ ] Notification history

---

## Phase 12: Integration & Testing 🔌
- [ ] **Backend Integration**
  - [ ] Connect to REST API endpoints
  - [ ] Implement authentication flow
  - [ ] Real-time data fetching
  - [ ] Error handling & retry logic

- [ ] **Mock Data**
  - [ ] Create mock repositories for development
  - [ ] Sample sensor data
  - [ ] Sample user data
  - [ ] Sample weather data

- [ ] **Testing**
  - [ ] Unit tests for models
  - [ ] Unit tests for repositories
  - [ ] Widget tests for screens
  - [ ] Integration tests for flows
  - [ ] Test on Android device
  - [ ] Test on iOS device

---

## Phase 13: Polish & Optimization 🎨
- [ ] **UI/UX Refinements**
  - [ ] Loading states for all screens
  - [ ] Empty states
  - [ ] Error states
  - [ ] Animations & transitions
  - [ ] Haptic feedback

- [ ] **Performance**
  - [ ] Image caching
  - [ ] Chart performance optimization
  - [ ] Reduce app size
  - [ ] Memory leak fixes

- [ ] **Accessibility**
  - [ ] Screen reader support
  - [ ] Contrast ratios
  - [ ] Touch target sizes

---

## Phase 14: Deployment 🚀
- [ ] **Android**
  - [ ] Configure app signing
  - [ ] Update AndroidManifest.xml
  - [ ] Generate app icons
  - [ ] Create splash screen
  - [ ] Build release APK
  - [ ] Test release build
  - [ ] Submit to Play Store

- [ ] **iOS**
  - [ ] Configure Xcode project
  - [ ] Update Info.plist
  - [ ] Configure app signing
  - [ ] Build release IPA
  - [ ] Test release build
  - [ ] Submit to App Store

---

## Ongoing Tasks 🔄
- [ ] Documentation
  - [ ] Code documentation
  - [ ] API documentation
  - [ ] User guide

- [ ] Maintenance
  - [ ] Bug fixes
  - [ ] Performance monitoring
  - [ ] Update dependencies
  - [ ] User feedback integration

---

## Notes & Decisions
- **State Management Choice:** Flutter Bloc (strict, predictable)
- **Localization:** Implement i18n from start (Turkish + English)
- **Backend:** REST API with JWT authentication
- **Primary Color:** #19e624 (Eco Green)
- **Fonts:** Inter (body), Lexend (headings)

---

## Resources
- Design Reference: `consolidated_html/` folder
- Compost Logic: `Kompost durumu.pdf`
- Icons: Material Icons + Custom SVGs

# Spider Panel Android App

Professional Flutter-based Android client for **Spider Panel** Xray management server.

## Features

### 🎨 **Design System**
- Material Design 3 + Glassmorphism
- Three neon themes: Red, Blue, Green
- Dark/Light mode support
- Smooth animations and transitions
- Responsive layout

### 📱 **Screens**
- **Splash Screen** - Animated galaxy with spider logo
- **Login** - API key authentication with device binding
- **Dashboard** - Real-time stats (CPU, RAM, Disk, Network, Users)
- **Users** - Manage Xray clients (create, edit, delete, QR codes)
- **Inbounds** - Configure Xray inbound protocols
- **AI Chat** - Hermes AI integration
- **News** - Iran news from Google RSS
- **IP Proxy** - Manage proxy configurations
- **Settings** - Themes, API keys, Telegram, backup
- **Profile** - User info and days remaining

### 🛠 **Technical Stack**

| Category | Technology |
|----------|------------|
| UI Framework | Flutter 3.x |
| State Management | Riverpod |
| Networking | Dio |
| Local Storage | Hive + Secure Storage |
| Animations | flutter_animate + Lottie |
| Charts | FL Chart |
| QR Code | qr_flutter |
| SVG | flutter_svg |
| Glassmorphism | backdropp_filter |

## Project Structure

```
spider-panel-android/
├── lib/
│   ├── main.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── inbound_model.dart
│   │   ├── dashboard_model.dart
│   │   ├── api_key_model.dart
│   │   ├── news_model.dart
│   │   └── proxy_model.dart
│   ├── widgets/
│   │   ├── glass_card.dart
│   │   ├── stat_card.dart
│   │   ├── user_card.dart
│   │   ├── inbound_card.dart
│   │   ├── neon_button.dart
│   │   └── glass_input.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── dashboard_screen.dart
│   │   ├── users_screen.dart
│   │   ├── inbounds_screen.dart
│   │   ├── ai_screen.dart
│   │   ├── news_screen.dart
│   │   ├── proxy_screen.dart
│   │   ├── settings_screen.dart
│   │   ├── profile_screen.dart
│   │   └── sidebar.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   └── storage_service.dart
│   └── providers/
│       ├── auth_provider.dart
│       ├── theme_provider.dart
│       └── dashboard_provider.dart
├── pubspec.yaml
└── README.md
```

## Installation

```bash
# Install dependencies
flutter pub get

# Generate Hive adapters
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

## Building for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release
```

## Configuration

### Backend URL
The app connects to the Spider Panel server via REST API. Configure the base URL on first login.

### API Keys
Users authenticate using API keys generated from the server's admin panel.

## API Endpoints Mapping

| Screen | Button | Backend Endpoint |
|--------|--------|------------------|
| Login | Enter | `POST /api/auth/login` |
| Dashboard | Refresh | `GET /api/dashboard` |
| Profile | Save | `PATCH /api/profile` |
| Users | + | `POST /api/users` |
| Users | Edit | `PATCH /api/users/{id}` |
| Users | Delete | `DELETE /api/users/{id}` |
| Users | QR | `GET /api/users/{id}/qr` |
| Users | Config | `GET /api/users/{id}/config` |
| Users | Subscription | `GET /api/users/{id}/subscription` |
| Users | Reset | `POST /api/users/{id}/reset` |
| Inbounds | + | `POST /api/inbounds` |
| Inbounds | Edit | `PATCH /api/inbounds/{id}` |
| Inbounds | Delete | `DELETE /api/inbounds/{id}` |
| Inbounds | Enable | `POST /api/inbounds/{id}/enable` |
| Inbounds | Disable | `POST /api/inbounds/{id}/disable` |
| Inbounds | Copy JSON | `GET /api/inbounds/{id}/json` |
| AI | Turn On | `POST /api/hermes/install` |
| AI | Chat | `POST /api/hermes/chat` |
| AI | Upload | `POST /api/hermes/upload` |
| News | Refresh | `GET /api/news` |
| Proxy | Add | `POST /api/proxy` |
| Proxy | Assign | `POST /api/proxy/assign` |
| Settings | Theme | `PATCH /api/settings/theme` |
| Settings | Password | `PATCH /api/settings/password` |
| Settings | Telegram | `POST /api/telegram/connect` |
| Settings | API Key | `POST /api/apikeys` |
| Settings | Backup | `POST /api/backup` |
| Settings | Reset | `POST /api/reset` |

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1
  dio: ^5.4.3
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  flutter_secure_storage: ^9.2.2
  flutter_animate: ^4.5.0
  lottie: ^3.1.0
  fl_chart: ^0.68.0
  qr_flutter: ^4.1.0
  flutter_svg: ^2.0.10
  backdropp_filter: ^0.3.0
  intl: ^0.19.0
  url_launcher: ^6.2.5
  image_picker: ^1.1.2
```

## Development

### Adding New Screens
1. Create screen in `lib/screens/`
2. Add route in `main.dart`
3. Add navigation in `sidebar.dart`

### Theming
Themes are managed via `AppTheme` class in `lib/theme/app_theme.dart`:
- `NeonTheme.red`, `NeonTheme.blue`, `NeonTheme.green`
- `lightTheme()` and `darkTheme()` methods
- Glass card decoration utilities

### State Management
Riverpod providers:
- `authStateProvider` - Authentication state
- `themeModeProvider` - Light/Dark mode
- `customThemeProvider` - Neon color theme
- `dashboardProvider` - Dashboard statistics

## Requirements

- Flutter 3.16+
- Dart 3.2+
- Android SDK 21+ (Android 5.0)
- iOS 12+ (if targeting iOS)

## License

MIT License - see LICENSE file for details.

## Support

For issues and feature requests, visit the GitHub repository.
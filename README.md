# 🎯 Nexus Assistant

<div align="center">

![Nexus Logo](https://via.placeholder.com/200x200?text=NEXUS)

**A Proactive AI-Powered Personal Assistant**

[![Build Status](https://github.com/nexus-team/nexus-assistant/workflows/CI/badge.svg)](https://github.com/nexus-team/nexus-assistant/actions)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.16.0-02569B?logo=flutter)](https://flutter.dev)
[![NestJS Version](https://img.shields.io/badge/NestJS-10.3.0-E0234E?logo=nestjs)](https://nestjs.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

[Features](#-features) • [Demo](#-demo) • [Installation](#-installation) • [Architecture](#-architecture) • [Team](#-team) • [Contributing](#-contributing)

</div>

---

## 📖 About

Nexus is not just another to-do app—it's your intelligent life companion that proactively manages your mental load, optimizes your daily efficiency, and prevents the regret of missed opportunities and deadlines.

Unlike passive calendars and reminder apps, Nexus thinks ahead for you, combining AI-powered predictions with real-world context (location, weather, traffic) to provide timely, actionable insights.

### 🎥 Demo

> 🚧 **Coming Soon**: Video demo and screenshots will be added here

---

## ✨ Features

### 🤖 The Four Pillars of Nexus

<table>
<tr>
<td width="25%" align="center">

#### 📋 Intelligent Taskmaster
Smart scheduling with AI-powered priority predictions and escalating deadline reminders

</td>
<td width="25%" align="center">

#### 🗺️ Hyper-Aware Navigator
Location-based reminders and context-aware suggestions using real-time data

</td>
<td width="25%" align="center">

#### 🎯 Proactive Coach
Focus mode with distraction tracking and wellness monitoring for sustainable productivity

</td>
<td width="25%" align="center">

#### 🧠 Reflective Partner
Social memory, daily debriefs, and weekly analytics for continuous improvement

</td>
</tr>
</table>

### 🔥 Key Capabilities

- 🤖 AI-Powered Priority Scoring: Google Gemini analyzes your tasks and suggests optimal scheduling
- 📍 Geofenced Reminders: Get notified when you're near locations related to your tasks
- 🌤️ Weather-Aware Planning: Automatic adjustments based on weather forecasts
- ⏰ Smart Deadline Escalation: 1 week → 72 hours → 24 hours reminder system
- 🎯 Focus Mode: Pomodoro timer with distraction tracking and productivity analytics
- 💪 Wellness Watchdog: Break reminders, sleep tracking, and burnout prevention
- 📊 Weekly Analytics: Comprehensive insights into your productivity patterns
- 🎂 Social Memory: Never forget birthdays, calls, or important personal events
- 🔄 Real-time Sync: Seamless synchronization across all your devices

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     MOBILE APP (Flutter)                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │   Home   │  │  Tasks   │  │  Focus   │  │  Memory  │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
│                            ↕                                 │
│  ┌─────────────────────────────────────────────────────┐   │
│  │        Native Kotlin Services (Android)              │   │
│  │  • AI Engine  • Focus Manager  • Context Monitor    │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              ↕
┌─────────────────────────────────────────────────────────────┐
│                    BACKEND API (NestJS)                      │
│  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────────┐     │
│  │ Auth │  │Tasks │  │  AI  │  │Context│  │Analytics │     │
│  └──────┘  └──────┘  └──────┘  └──────┘  └──────────┘     │
└─────────────────────────────────────────────────────────────┘
                              ↕
┌─────────────────────────────────────────────────────────────┐
│                         DATABASES                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │  PostgreSQL  │  │   MongoDB    │  │    Redis     │     │
│  │  (Structured)│  │  (AI Logs)   │  │   (Cache)    │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
└─────────────────────────────────────────────────────────────┘
                              ↕
┌─────────────────────────────────────────────────────────────┐
│                    EXTERNAL SERVICES                         │
│  • Google Gemini AI  • Firebase (Auth/FCM)                  │
│  • Google Maps API   • OpenWeatherMap API                   │
└─────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Tech Stack

### Frontend (Mobile)
- **Framework**: Flutter 3.16.0 (Dart)
- **State Management**: Provider + BLoC
- **Native Integration**: Kotlin (Android)
- **UI Components**: Material Design 3

### Backend (API)
- **Framework**: NestJS 10.3.0 (Node.js + TypeScript)
- **API Style**: RESTful + WebSockets
- **Documentation**: Swagger/OpenAPI

### Databases
- **PostgreSQL 15**: Structured data (users, tasks, reminders)
- **MongoDB 7**: Unstructured logs, AI predictions
- **Redis 7**: Caching, sessions, real-time data

### AI & ML
- **Google Gemini API**: Natural language processing
- **TensorFlow Lite**: On-device ML models

### DevOps
- **Containerization**: Docker + Docker Compose
- **Orchestration**: Kubernetes (AWS EKS)
- **CI/CD**: GitHub Actions
- **Monitoring**: Prometheus + Grafana

### External APIs
- **Firebase**: Authentication, Cloud Messaging
- **Google Maps API**: Location services
- **OpenWeatherMap**: Weather data

---

## 🚀 Installation

### Prerequisites

- Flutter SDK: 3.16.0 or higher ([Install](https://docs.flutter.dev/get-started/install))
- Node.js: 20.x or higher ([Install](https://nodejs.org))
- Docker: Latest version ([Install](https://docs.docker.com/get-docker/))
- Android Studio: For Android development ([Install](https://developer.android.com/studio))
- Git: Version control ([Install](https://git-scm.com))

### Quick Start (Automated)

```bash
# Clone the repository
git clone https://github.com/nexus-team/nexus-assistant.git
cd nexus-assistant

# Run automated setup
chmod +x scripts/setup.sh
./scripts/setup.sh

# The script will:
# ✅ Install all dependencies
# ✅ Start Docker containers
# ✅ Run database migrations
# ✅ Configure environment variables
```

### Manual Setup

#### 1. Clone Repository
```bash
git clone https://github.com/nexus-team/nexus-assistant.git
cd nexus-assistant
```

#### 2. Setup Backend
```bash
cd backend
cp .env.example .env
# Edit .env with your API keys
npm install
```

#### 3. Setup Flutter
```bash
cd ..
flutter pub get
```

#### 4. Start Docker Services
```bash
docker-compose up -d
```

#### 5. Run Database Migrations
```bash
cd backend
npm run migration:run
```

#### 6. Start Development Servers

**Terminal 1 - Backend:**
```bash
cd backend
npm run start:dev
```

**Terminal 2 - Flutter:**
```bash
flutter run
```

#### 7. Access Services
- 📱 Mobile App: Running on connected device/emulator
- 🔧 Backend API: http://localhost:3000
- 📚 API Docs: http://localhost:3000/api/docs
- 🗄️ Database Admin: http://localhost:8080 (Adminer)

---

## 📁 Project Structure

```
nexus-assistant/
├── lib/                          # Flutter Frontend
│   ├── main.dart                 # App entry point
│   ├── screens/                  # UI Screens
│   │   ├── home_screen.dart
│   │   ├── task_screen.dart
│   │   ├── focus_screen.dart
│   │   └── memory_screen.dart
│   ├── services/                 # Business Logic
│   │   ├── api_service.dart
│   │   ├── firebase_service.dart
│   │   └── platform_service.dart
│   ├── models/                   # Data Models
│   ├── widgets/                  # Reusable Components
│   └── utils/                    # Helpers & Constants
│
├── android/                      # Android Native
│   └── app/src/main/kotlin/
│       └── com/nexus/assistant/
│           ├── MainActivity.kt
│           ├── TaskAIEngine.kt
│           ├── FocusManager.kt
│           └── ContextMonitor.kt
│
├── backend/                      # NestJS Backend
│   ├── src/
│   │   ├── main.ts               # Entry point
│   │   ├── app.module.ts         # Root module
│   │   ├── auth/                 # Authentication
│   │   ├── tasks/                # Task management
│   │   ├── ai/                   # AI services
│   │   ├── context/              # Context engine
│   │   ├── notifications/        # Push notifications
│   │   └── analytics/            # Analytics
│   └── test/                     # Backend tests
│
├── k8s/                          # Kubernetes configs
│   ├── staging/
│   └── production/
│
├── .github/workflows/            # CI/CD pipelines
│   └── ci-cd.yml
│
├── docker-compose.yml            # Local development
├── pubspec.yaml                  # Flutter dependencies
└── README.md                     # This file
```

---

## 🧪 Testing

### Run All Tests
```bash
# Flutter tests
flutter test

# Backend tests
cd backend
npm run test

# Integration tests
npm run test:e2e

# Coverage report
npm run test:coverage
```

### Run Specific Test Suites
```bash
# Unit tests only
flutter test test/unit/

# Widget tests
flutter test test/widget/

# API tests
cd backend && npm run test -- auth.service.spec.ts
```

---

## 📊 API Documentation

### Access Interactive API Docs

1. Start the backend server:
   ```bash
   cd backend && npm run start:dev
   ```

2. Open browser: http://localhost:3000/api/docs

### Sample API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/login` | User login |
| GET | `/api/tasks` | Get all tasks |
| POST | `/api/tasks` | Create new task |
| POST | `/api/ai/predict-priority` | Get AI priority predictions |
| GET | `/api/focus/analytics` | Get focus analytics |
| POST | `/api/context` | Update user context |

For complete API documentation, see [API_DOCUMENTATION.md](docs/API_DOCUMENTATION.md)

---

## 🔧 Configuration

### Environment Variables

Create `.env` file in backend directory:

```bash
# Application
NODE_ENV=development
PORT=3000

# Database
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/nexus_dev
MONGODB_URI=mongodb://localhost:27017/nexus_dev
REDIS_URL=redis://localhost:6379

# JWT
JWT_SECRET=your-secret-key
JWT_EXPIRATION=3600

# External APIs
GEMINI_API_KEY=your-gemini-api-key
GOOGLE_MAPS_API_KEY=your-maps-api-key
WEATHER_API_KEY=your-weather-api-key

# Firebase
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_PRIVATE_KEY=your-private-key
```

### Get API Keys

1. Google Gemini: https://ai.google.dev
2. Google Maps: https://console.cloud.google.com
3. OpenWeatherMap: https://openweathermap.org/api
4. Firebase: https://console.firebase.google.com

---

## 📱 Build & Deployment

### Build Android APK

```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Deploy Backend to Production

```bash
# Using Docker
docker build -t nexus-backend:latest ./backend
docker push your-registry/nexus-backend:latest

# Using Kubernetes
kubectl apply -f k8s/production/
kubectl set image deployment/nexus-backend nexus-backend=your-registry/nexus-backend:latest
```

---

## 👥 Team

<table>
  <tr>
    <td align="center">
      <img src="https://via.placeholder.com/100" width="100px;" alt=""/><br />
      <sub><b>Shashank</b></sub><br />
      <sub>Flutter + AI Lead</sub>
    </td>
    <td align="center">
      <img src="https://via.placeholder.com/100" width="100px;" alt=""/><br />
      <sub><b>Trinetra</b></sub><br />
      <sub>Lead Flutter Developer</sub>
    </td>
    <td align="center">
      <img src="https://via.placeholder.com/100" width="100px;" alt=""/><br />
      <sub><b>Aryan</b></sub><br />
      <sub>Integration Engineer</sub>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://via.placeholder.com/100" width="100px;" alt=""/><br />
      <sub><b>Rakshit</b></sub><br />
      <sub>Backend & DevOps</sub>
    </td>
    <td align="center">
      <img src="https://via.placeholder.com/100" width="100px;" alt=""/><br />
      <sub><b>Aadi</b></sub><br />
      <sub>Backend Developer</sub>
    </td>
    <td align="center">
      <img src="https://via.placeholder.com/100" width="100px;" alt=""/><br />
      <sub><b>Shantanu</b></sub><br />
      <sub>Full Stack & Admin</sub>
    </td>
  </tr>
</table>

---

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Quick Contribution Guide

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/AmazingFeature`)
3. **Commit** your changes (`git commit -m 'Add some AmazingFeature'`)
4. **Push** to the branch (`git push origin feature/AmazingFeature`)
5. **Open** a Pull Request

### Development Workflow

- Follow the [Flutter style guide](https://flutter.dev/docs/development/ui/widgets)
- Follow the [TypeScript style guide](https://github.com/Microsoft/TypeScript/wiki/Coding-guidelines)
- Write tests for new features
- Update documentation as needed
- Ensure CI/CD pipeline passes

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 📞 Support & Contact

- Documentation: [docs.nexus-assistant.com](https://docs.nexus-assistant.com)
- Issues: [GitHub Issues](https://github.com/nexus-team/nexus-assistant/issues)
- Discussions: [GitHub Discussions](https://github.com/nexus-team/nexus-assistant/discussions)
- Email: support@nexus-assistant.com

---

## 🗺️ Roadmap

### Phase 1 (Weeks 1-2) ✅
- [x] Project setup and architecture
- [x] Basic authentication
- [x] Task CRUD operations

### Phase 2 (Weeks 3-4) 🚧
- [ ] AI integration with Gemini
- [ ] Location services
- [ ] Weather integration

### Phase 3 (Weeks 5-6) ⏳
- [ ] Focus mode implementation
- [ ] Analytics dashboard
- [ ] Push notifications

### Phase 4 (Weeks 7-8) ⏳
- [ ] Testing and bug fixes
- [ ] Performance optimization
- [ ] Production deployment

### Future Enhancements 💡
- [ ] iOS support
- [ ] Web dashboard
- [ ] Voice commands
- [ ] Calendar integrations (Google, Outlook)
- [ ] Collaboration features
- [ ] Custom AI model training

---

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev) for the amazing framework
- [NestJS Team](https://nestjs.com) for the robust backend framework
- [Google AI](https://ai.google.dev) for Gemini API access
- All our contributors and supporters

---

## 📊 Project Stats

![GitHub stars](https://img.shields.io/github/stars/nexus-team/nexus-assistant?style=social)
![GitHub forks](https://img.shields.io/github/forks/nexus-team/nexus-assistant?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/nexus-team/nexus-assistant?style=social)
![GitHub repo size](https://img.shields.io/github/repo-size/nexus-team/nexus-assistant)
![Lines of code](https://img.shields.io/tokei/lines/github/nexus-team/nexus-assistant)

---

<div align="center">

**Made with ❤️ by the Nexus Team**

⭐ Star us on GitHub — it motivates us a lot!

[Report Bug](https://github.com/nexus-team/nexus-assistant/issues) · [Request Feature](https://github.com/nexus-team/nexus-assistant/issues) · [Documentation](https://docs.nexus-assistant.com)

</div>

# 🥷 Ninja Signal — Mobile App (Flutter + BLoC + Clean Architecture)

Cross-platform mobile application for **Ninja Signal** (Gold & Forex Scalping Intelligence) built with **Flutter**, **BLoC state management**, and **Clean Architecture**.

---

## 🏛 Clean Architecture Structure

The app strictly follows Uncle Bob's Clean Architecture pattern, decoupling business rules, data sources, and presentation:

```
mobile/lib/
├── core/                         # Shared kernel & primitives
│   ├── constants/                # App colors (dark glass theme), API endpoints
│   ├── di/                       # Dependency injection (GetIt service locator)
│   ├── errors/                   # Failures & Exception abstractions
│   ├── network/                  # Dio HTTP client, auth interceptor, cookie handler, mock engine
│   ├── theme/                    # Material 3 dark cyber-ninja theme
│   ├── utils/                    # Price/magnitude formatters, ICT timezone, currency
│   └── widgets/                  # Reusable cards, badges, chips, stat widgets
│
├── features/                     # Feature-sliced modules
│   ├── auth/                     # Authentication & Session
│   │   ├── domain/               # User entity, AuthRepository, UseCases
│   │   ├── data/                 # UserModel, AuthRemoteDataSource, AuthRepositoryImpl
│   │   └── presentation/         # AuthBloc, LoginPage, RegisterPage
│   │
│   ├── dashboard/                # Real-time Market Overview & Equity Curve
│   │   ├── domain/               # SystemStatus, LivePrice, DailyStats, EquityPoint entities
│   │   ├── data/                 # Models, RemoteDataSource, RepositoryImpl
│   │   └── presentation/         # DashboardBloc, DashboardPage (FL Chart equity curve)
│   │
│   ├── signals/                  # Scalping Signal Alerts & Confluence Rules
│   │   ├── domain/               # TradeSignal entity, GetSignalsUseCase
│   │   ├── data/                 # TradeSignalModel, SignalDataSource, RepositoryImpl
│   │   └── presentation/         # SignalBloc, SignalsPage (filters: all/active/closed)
│   │
│   ├── trades/                   # Active Positions & Manual Exit
│   │   ├── domain/               # Trade entity, GetTradesUseCase, CloseTradeUseCase
│   │   ├── data/                 # TradeModel, TradeDataSource, RepositoryImpl
│   │   └── presentation/         # TradeBloc, TradesPage, CloseTradeDialog ("I closed this")
│   │
│   ├── news/                     # Economic Calendar & Market Moving Headlines
│   │   ├── domain/               # CalendarEvent, NewsHeadline entities
│   │   ├── data/                 # NewsModels, NewsDataSource, RepositoryImpl
│   │   └── presentation/         # NewsBloc, NewsPage
│   │
│   ├── settings/                 # Risk Spec & Backend Connection
│   │   ├── domain/               # SystemConfig entity, UseCases
│   │   ├── data/                 # ConfigModel, SettingsDataSource, RepositoryImpl
│   │   └── presentation/         # SettingsBloc, SettingsPage (API URL switch, Mock mode)
│   │
│   └── navigation/               # Bottom Navigation Shell
│       └── presentation/         # MainNavigationPage
│
└── main.dart                     # App entry point, MultiBlocProvider, AuthGate
```

---

## 🚀 Key Features

1. **Dashboard & Live Market Feeds:**
   - Real-time price cards for XAU/USD, EUR/USD, GBP/JPY, BTC/USDT, USD/CAD with age timestamps ("12s ago") and change percentages.
   - Interactive Cumulative Equity Curve chart using `fl_chart`.
   - Today's performance metrics (Net P&L USD, Win Rate %, Total Trades, Profit Factor).
   - System active/paused status banner with admin toggle button.

2. **Signals Feed:**
   - Real-time scalping signals with clear BUY/SELL direction badges and confidence ratings (High / Medium / Low).
   - Dynamic price levels: Entry, Stop Loss (with ATR-based distance), Take Profit (Swing high/low target), Risk:Reward ratio.
   - Strategy confluence tags: e.g. `EMA 20/50 Cross`, `H4 Trend Bias`, `FVG Bounce`, `S&D Zone`.
   - Status filtering (All / Active / Closed).

3. **Trades & Manual Exit ("I closed this"):**
   - Active position cards showing lot size, entry price, current market price, unrealized P&L in USD, and P&L in R.
   - **Manual close dialog**: Allows recording manual exits executed on MT5/broker, mandating the actual exit price and optional MT5 profit/loss.
   - Trade history tab with closed trades and final exit prices.

4. **Economic News & Volatility Guard:**
   - Economic calendar events with country flags, impact level (High/Medium/Low), forecast vs previous metrics, and UTC+7 ICT timestamps.
   - Tier 1/2 breaking news events and signal pause status.

5. **Settings & Mock Mode:**
   - Change backend URL on the fly (Android emulator `http://10.0.2.2:8000`, iOS/Desktop `http://localhost:8000`, or remote cloud Railway URL).
   - **One-tap Mock Mode**: Allows running offline and showcasing UI with realistic synthetic trading data.
   - Live view of quant risk parameters: Risk per trade ($3), Max loss cap ($5), Exit rule (+1R BE + Trail 3x ATR), Max consecutive loss pause.

---

## 🛠 Running the App

### Prerequisites
- Flutter SDK (≥ 3.22.0)
- Dart SDK (≥ 3.4.0)

### Getting Started

```bash
cd mobile

# Install dependencies
flutter pub get

# Run unit tests
flutter test

# Run analyzer
flutter analyze

# Launch on Android Emulator, iOS Simulator, or Chrome/Windows Desktop
flutter run
```

### Network configuration notes:
- **Android Emulator**: Uses `http://10.0.2.2:8000` to talk to your PC's localhost.
- **Physical Device**: Set the Server URL in Settings or the Login dialog to your PC's local Wi-Fi IP (e.g. `http://192.168.1.50:8000`).
- **Demo / Offline**: Tap **"Explore Demo (Mock Mode)"** on the Login screen to try all features without starting the backend.

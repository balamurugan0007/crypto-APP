# 🪙 Crypto App - Mini CoinGecko

A Flutter crypto research app with a FastAPI backend, built using BLoC state management.

---

## 📁 Project Structure

```
crypto APP/
├── backend/                 ← FastAPI backend
│   ├── main.py             ← All API routes
│   ├── requirements.txt
│   └── venv/               ← Python virtual environment
│
└── cryto_app/              ← Flutter app
    └── lib/
        ├── main.dart           ← App entry, BLoC providers, nav
        ├── models/
        │   ├── coin_model.dart         ← Coin list data
        │   └── coin_detail_model.dart  ← Coin detail data
        ├── services/
        │   └── api_service.dart        ← HTTP calls to FastAPI
        ├── blocs/
        │   ├── coin_list/              ← Market list BLoC
        │   ├── coin_detail/            ← Detail + chart BLoC
        │   └── watchlist/              ← Watchlist (SharedPrefs) BLoC
        ├── screens/
        │   ├── coin_list_screen.dart   ← Home screen
        │   ├── coin_detail_screen.dart ← Coin details + chart
        │   ├── search_screen.dart      ← Search coins
        │   └── watchlist_screen.dart   ← Saved coins
        ├── widgets/
        │   ├── coin_list_tile.dart     ← Row in list
        │   ├── price_chart_widget.dart ← fl_chart line chart
        │   └── stat_card.dart          ← Market data card
        └── utils/
            ├── app_colors.dart         ← Color palette
            └── format_helper.dart      ← Number formatters
```

---

## 🚀 How to Run

### 1. Start the FastAPI backend

```bash
cd backend
source venv/bin/activate
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Open http://localhost:8000 in browser to verify it works.

### 2. Configure API URL in Flutter

Open `lib/services/api_service.dart` and update `baseUrl`:

| Where running Flutter | baseUrl |
|---|---|
| Android Emulator | `http://10.0.2.2:8000` ✅ (already set) |
| Physical Android device | `http://YOUR_LOCAL_IP:8000` |
| iOS Simulator | `http://localhost:8000` |

To find your local IP: `ip addr show` or `hostname -I`

### 3. Run the Flutter app

```bash
cd cryto_app
flutter pub get
flutter run
```

---

## ✨ Features

- 📋 **Market List** — Top 20 coins by market cap with live price + 24h change
- 🔍 **Search** — Search any crypto by name/symbol
- 📊 **Coin Detail** — Price, market stats grid, interactive chart (1D/7D/30D/90D)
- ⭐ **Watchlist** — Save favorite coins, persists across app restarts
- 🔄 **Pull to Refresh** — Swipe down to reload
- 📜 **Pagination** — Scroll to load more coins
- 🔀 **Sort** — Sort by market cap, price, 24h change, or name

---

## 🛠 Tech Stack

| Layer | Tech |
|---|---|
| Frontend | Flutter + BLoC |
| Backend | FastAPI (Python) |
| Data | CoinGecko public API (via backend) |
| Chart | fl_chart |
| Storage | SharedPreferences (watchlist) |
| HTTP | http (Flutter), httpx (FastAPI) |

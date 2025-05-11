# DailyBytes 📱📰  
A Flutter app that fetches and displays a list of articles from a public API.  
Users can search, mark favorites, view full article details, and enjoy a smooth, user-friendly interface.

## ✨ Features
- Fetch articles from a public API
- Client-side search functionality
- Detailed article view
- Favorites tab with persistence (SharedPreferences)
- Pull-to-refresh support
- Splash screen
- Custom app icon
- Smooth UI animations and transitions
- Comments section (UI only) with draggable sheet
- Share dialog (UI only) with modern design
- Responsive design and accessibility improvements

## 🚀 Setup Instructions
1. **Clone the repository**:
   ```bash
   git clone <your-repo-link>
   cd dailybytes
2.Get dependencies:
  flutter pub get
  
3.Run the app:
  flutter run
  
🛠️ Tech Stack
Flutter SDK: 3.x

State Management: Provider

HTTP Client: http

Persistence: SharedPreferences

🧠 State Management Explanation
This app uses the Provider package for state management.
The ArticleProvider class extends ChangeNotifier and manages article fetching, searching, and favorites.
Widgets listen to updates using Consumer or context.watch, enabling reactive UI updates and separating business logic from UI.

⚠️ Known Issues / Limitations
Comments feature is UI-only (not backed by a live database)

Share with friends feature is UI-only (no actual sharing implemented)

Articles are fetched from a static API (jsonplaceholder.typicode.com) without pagination

Client-side search is case-sensitive and limited to the fetched list

Favorites are stored locally and not synced across devices

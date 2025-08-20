# 🍽️ Meal Organizer

An offline-first recipe and meal planning app built with **Flutter**, featuring secure authentication and local data persistence.  
Meal Organizer helps you save recipes, plan meals, and keep everything organized in one place.

---

## ✨ Features

- 🔐 **Firebase Authentication** – Sign up, log in, and manage accounts securely.  
- 📦 **SQLite Local Storage** – Recipes stored locally for offline access.  
- ➕ **CRUD Operations** – Create, update, delete, and view recipes with ingredients and steps.  
- ⚡ **Streams for Live Updates** – UI updates instantly when data changes.  
- 🔎 **Search Recipes** – Quickly find saved recipes.  
- ❤️ **Favorites** – Mark recipes you love for faster access.  
- 📅 **Meal Planner** – Use a table calendar to plan meals throughout the week/month.  

---

## 🚧 Roadmap

Planned features:  
- 🛒 Shopping list generator  
- ⏱️ Cooking timers  
- 📲 Recipe sharing via QR code  

---

## 🛠️ Tech Stack

- **Framework:** Flutter  
- **Database:** SQLite  
- **Authentication:** Firebase Auth  
- **State Updates:** Streams  

---

## 📸 Screenshots

<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/b2a5d55e-6263-4054-a7fb-06ab90b81a47" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/4726368b-c860-42c6-a2dd-f8255126a2bf" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/d79dd5ab-e055-47a4-9733-c625b299b4e9" /> 
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/53d680bf-a496-42e8-b80f-be52283adbd8" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/84139ff4-090a-4c54-a939-55dda20f735b" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/03ededce-5f1b-4271-ab28-8dd0d4abc301" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/37f7d388-fd62-40b3-8a49-5d65e955308b" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/1ab376ef-9b24-459e-97f9-a41ef47a8080" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/3de47e35-5ade-4cca-a7c5-509196a824e2" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/85a55b1e-df5e-4940-be7b-a8de601dd010" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/5c290d82-b6dd-42e3-a140-b4991e7d237a" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/c83f7c00-3853-4673-b772-206b9bb0a19e" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/4ac31e56-94c8-4e24-b12f-15c2052267bb" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/5088b9c2-64dc-495d-8a2d-6061f76f1eef" />

---

## Project Sturcture

lib
├───exceptions
│   ├───auth
│   └───crud
├───models
├───services
│   ├───auth
│   └───crud
├───utils
│   ├───constants
│   │   └───enums
│   ├───dialogs
│   ├───extensions
│   └───navigation
├───views
│   ├───auth
│   ├───drawer
│   ├───recipes
│   └───splash
└───widgets
    ├───text_widgets
    └───waiting

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install)  
- Firebase project set up with Authentication enabled  
- Android/iOS emulator or physical device  

### Installation
```bash
# Clone the repository
git clone https://github.com/kalutm/MyRecipeBox.git
cd MyRecipeBox

# Install dependencies
flutter pub get

# Run on emulator/device
flutter run

🤝 Contributing
Contributions are welcome. Please fork the repo and submit a pull request.

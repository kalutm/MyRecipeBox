# MyRecipeBox - Your Personal Recipe Keeper

[![Flutter](https://img.shields.io/badge/Flutter-v3.x.x-blue?style=flat-square&logo=flutter)](https://flutter.dev)
[![SQLite](https://img.shields.io/badge/SQLite-3.x.x-green?style=flat-square&logo=sqlite)](https://www.sqlite.org/index.html)
[![Firebase](https://img.shields.io/badge/Firebase-9.x.x-orange?style=flat-square&logo=firebase)](https://firebase.google.com/)
[![Shared Preferences](https://img.shields.io/badge/Shared_Preferences-1.x.x-yellow?style=flat-square)](https://pub.dev/packages/shared_preferences)
[![Table Calendar](https://img.shields.io/badge/Table_Calendar-3.x.x-purple?style=flat-square)](https://pub.dev/packages/table_calendar)

## Overview

MyRecipeBox is a mobile application built with Flutter designed to be your comprehensive digital recipe companion. It empowers you to effortlessly **save, organize, discover, and manage your favorite recipes** in a user-friendly interface. Beyond just storage, MyRecipeBox offers features like **dynamic searching, favoriting, and a built-in meal planner** to streamline your cooking workflow and inspire your culinary adventures. Built with local data persistence using SQLite and secure user authentication via Firebase, MyRecipeBox ensures your recipes are always accessible and protected.

## Features

* **User Authentication:** Secure user registration, login, and email verification powered by Firebase Authentication.
* **Recipe Management:**
    * **Create:** Easily add new recipes with details such as title, ingredients, instructions, and category.
    * **View:** Browse your saved recipes with clear layouts and optional images.
    * **Update:** Modify existing recipes to correct information or add notes.
    * **Delete:** Remove recipes you no longer need.
* **Local Image Storage:** Store recipe images locally on your device, with the file paths saved in the SQLite database for efficient management.
* **Favorite Recipes:** Mark your most loved recipes as favorites for quick access.
* **Dynamic Recipe Search:** Quickly find recipes by title using a real-time, dynamic search functionality that updates results with each keystroke.
* **Settings:** Customize your app experience with a light/dark theme toggle, saved using Shared Preferences.
* **Meal Planner:** Schedule your meals for specific days using an integrated calendar view (powered by the `table_calendar` package). Plan your breakfast, lunch, dinner, and dessert with your saved recipes.
* **Coming Soon:** Meal sharing functionality via QR codes, allowing you to easily share your planned meals with others.
* **UI State Management:** Currently utilizing Flutter's built-in `setState` for managing the UI state. While functional, the project's complexity suggests that future iterations could benefit from a more robust state management solution.
* **Responsive UI:** Designed to provide a seamless experience across various screen sizes and orientations.

## Technologies Used

* **Flutter:** A UI toolkit by Google for building natively compiled applications for mobile, web, and desktop from a single codebase.
* **Dart:** The programming language used to write Flutter applications.
* **SQLite:** A self-contained, high-reliability, embedded, zero-configuration, transactional SQL database engine for local data persistence.
* **Firebase Authentication:** A service provided by Firebase to handle user authentication securely.
* **Shared Preferences:** A Flutter plugin for reading and writing simple data to local storage (used for theme preference).
* **`table_calendar`:** A Flutter package for displaying a highly customizable calendar UI (used for the Meal Planner).
* **`path_provider`:** A Flutter plugin for finding commonly used locations on the filesystem (used for accessing local image storage).
* **(Potentially other Flutter packages for UI, navigation, etc.)**

## Screenshots
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/7aaab973-e204-453f-817c-4fde55cd882f" /> 
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/fe23e3ed-5f37-42e2-98dd-34018a4b41ca" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/7e990d23-384e-4f2b-bba6-b481b23cf575" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/8c4db936-f25c-4d78-be73-f01c0e04fa85" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/4573469c-f0d9-4d80-83c8-31c6100bc9f2" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/30e0bd50-e06a-491a-ae44-5f6d9ea623e1" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/8cc9c999-c4dc-4f84-93d8-2abb70bf9833" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/7bf9235b-0dd0-4efb-8cc6-ade5e550b455" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/48318e0d-fb32-42ab-8355-2977abefc61f" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/b2d6bd90-a800-40e6-8fdd-164549d5ad69" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/1ba28217-9f23-4872-b58c-5fdc1d9dbda9" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/105d0756-3d16-49a1-a023-b22a9be93876" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/3076fd3e-9483-4f1e-9742-2d5a226e7f2c" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/5da393ee-3ae0-46e5-9b63-f5f2d43024e9" />
<img width="250" height="500" alt="image" src="https://github.com/user-attachments/assets/0d4e5968-433f-4e6c-8386-a0a9c6cb857f" />

## Installation

1.  **Clone the repository:**
    ```bash
    git clone <your_repository_url>
    ```
2.  **Navigate to the project directory:**
    ```bash
    cd my_recipe_box
    ```
3.  **Ensure Flutter is installed:** If you don't have Flutter installed, follow the instructions on the [official Flutter website](https://flutter.dev/docs/get-started/install).
4.  **Get the dependencies:**
    ```bash
    flutter pub get
    ```
5.  **Set up Firebase:**
    * Create a new project on the [Firebase Console](https://console.firebase.google.com/).
    * Register your Android and/or iOS app in your Firebase project.
    * Download the `google-services.json` (for Android) and `Runner-Info.plist` (for iOS) files and place them in the appropriate platform-specific directories (`android/app/` and `ios/Runner/`).
    * Enable the "Email/Password" sign-in method in the Firebase Authentication section.
6.  **Run the application:**
    ```bash
    flutter run
    ```

## Project Structure
my_recipe_box/
├── android/
├── ios/
├── lib/
│   ├── firebase_options.dart
│   ├── main.dart
│   │
│   ├── exceptions/
│   │   ├── auth/
│   │   │   └── auth_exceptions.dart
│   │   │
│   │   └── crud/
│   │       └── crud_exceptions.dart
│   │
│   ├── models/
│   │   ├── meal_plan.dart
│   │   ├── recipe.dart
│   │   └── recipe_user.dart
│   │
│   ├── services/
│   │   ├── auth/
│   │   │   ├── auth_interface.dart
│   │   │   ├── auth_service.dart
│   │   │   ├── auth_user.dart
│   │   │   └── firebase_auth.dart
│   │   │
│   │   └── crud/
│   │       ├── database_service.dart
│   │       ├── meal_planner_service.dart
│   │       ├── recipe_service.dart
│   │       └── recipe_user_service.dart
│   │
│   ├── utils/
│   │   ├── call_backs.dart
│   │   │
│   │   ├── constants/
│   │   │   ├── colors.dart
│   │   │   ├── databas_constants.dart
│   │   │   ├── hint_texts.dart
│   │   │   ├── route_constants.dart
│   │   │   ├── view_constants.dart
│   │   │   │
│   │   │   └── enums/
│   │   │       ├── active_bottom_nav.dart
│   │   │       ├── recipe_layout_enum.dart
│   │   │       └── recipe_view_actions_enum.dart
│   │   │
│   │   ├── dialogs/
│   │   │   ├── delete_dialog.dart
│   │   │   ├── error_dialog.dart
│   │   │   ├── generic_dialog.dart
│   │   │   └── logout_dialog.dart
│   │   │
│   │   ├── extensions/
│   │   │   └── arguments.dart
│   │   │
│   │   └── navigation/
│   │       └── navigation_helpers.dart
│   │
│   ├── views/
│   │   ├── meal_planner.dart
│   │   │
│   │   ├── auth/
│   │   │   ├── auth_wrapper.dart
│   │   │   ├── email_verifiaction.dart
│   │   │   ├── login_view.dart
│   │   │   └── register_view.dart
│   │   │
│   │   ├── drawer/
│   │   │   ├── about_view.dart
│   │   │   └── settings_view.dart
│   │   │
│   │   ├── recipes/
│   │   │   ├── create_update_recipe_view.dart
│   │   │   ├── detailed_recipe_view.dart
│   │   │   ├── recipe_list.dart
│   │   │   └── recipe_view.dart
│   │   │
│   │   └── splash/
│   │       └── splash_screen.dart
│   │
│   └── widgets/
│       ├── recipe_card.dart
│       ├── sized_box.dart
│       │
│       ├── text_widgets/
│       │   └── views_text_widgets.dart
│       │
│       └── waiting/
│           └── spinkit_rotating_circle.dart
│
└── test/
└── ...
## Future Enhancements

* Implement the meal sharing feature using QR codes.
* Explore and implement a dedicated state management solution (e.g., Provider, Riverpod, BLoC) to improve scalability and maintainability.
* Add more advanced filtering and sorting options for recipes.
* Explore cloud storage options (like Firebase Storage) for image backup and synchronization.
* Adding nutritional information or serving size details to recipes.
* Improve UI/UX based on user feedback.

## Contact

[Kaleb Tesfahun] - [kalebtesfahun@gmail.com] - [https://www.linkedin.com/in/kaleb-tsefahun-016677308/]

Thank you for taking the time to review my MyRecipeBox project!

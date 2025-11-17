# [cite_start]Assignment 02: Mobile Application Design and Development (SE4041) [cite: 6]

## Project Report: AquaLog

**Student Name:** [Your Name Here]
**Student ID:** [Your ID Here]
**Date:** November 17, 2025

---

## 1. Introduction

### [cite_start]1.1 Purpose [cite: 17]
**AquaLog** is a comprehensive mobile application designed to help users track their daily water intake efficiently. The primary goal of the application is to promote healthy hydration habits by providing a simple, intuitive, and visually engaging interface for logging water consumption.

### [cite_start]1.2 Target Audience [cite: 18]
The target audience includes health-conscious individuals, athletes, and anyone looking to improve their daily hydration habits. The app is designed to be accessible for users of all ages, featuring a clean interface and clear visual feedback.

---

## 2. Design Decisions & Visual Branding

### 2.1 Architecture Pattern
The application follows the **MVVM (Model-View-ViewModel)** architecture. This separates the business logic (data handling) from the UI code, making the application more testable, maintainable, and scalable.

### [cite_start]2.2 Visual Design & UX [cite: 23, 58]
* **Custom Components:** Instead of using static images, a custom **SwiftUI Water Bottle** component was developed using shapes. It dynamically fills up based on the user's progress, providing immediate visual satisfaction.
* **Animations:** Smooth animations were implemented for adding water and navigating between screens to enhance user engagement.
* **Color Scheme:** A cohesive blue color palette was selected to represent water and hydration, ensuring a calm and professional aesthetic.
* [cite_start]**Dark Mode:** The app fully supports Dark Mode, automatically adapting colors to reduce eye strain in low-light environments[cite: 59].

---

## 3. Technical Implementation

### 3.1 Advanced iOS App (Part A)
* [cite_start]**Framework:** The app is built entirely using **SwiftUI**[cite: 29].
* **Data Persistence:** **Core Data** is used for local storage. [cite_start]This ensures that users' water logs are saved securely on the device and are available offline[cite: 34].
* [cite_start]**Integration of Emerging Technology (HealthKit)[cite: 37, 44]:**
    * The application integrates **Apple HealthKit**.
    * **Functionality:** When a user adds water in AquaLog, the app requests permission to access the Health Store and writes the data directly to the Apple Health app. This allows AquaLog to function as a central part of the user's health ecosystem.

### [cite_start]3.2 Innovative tvOS Application (Part B) [cite: 81]
* **Concept:** A "Family Hydration Dashboard" designed for a shared living room environment.
* [cite_start]**Innovation:** The tvOS app leverages the **Multi-User** concept, allowing family members to switch profiles and view their daily goals on a large screen[cite: 94].
* [cite_start]**Navigation:** The app utilizes the **tvOS Focus Engine**, enabling intuitive navigation via the Siri Remote[cite: 97].

---

## 4. Development Challenges

During the development process, I encountered a specific challenge regarding the navigation architecture.

* **Navigation Structure:** The assignment requirements suggested using `NavigationStack`. However, my development environment is limited to **Xcode 12.5** (running on macOS Big Sur), which supports up to iOS 14.5.
* **Solution:** Since `NavigationStack` was introduced in iOS 16, it was not available in my environment. I successfully implemented a robust navigation structure using **`NavigationView`** and `NavigationLink`, which is the standard and stable solution for the target iOS version.

---

## [cite_start]5. Testing & Optimization Results [cite: 60]

### 5.1 Unit Testing
Unit testing was performed to verify the logic of the Data Manager.
* **Verified:** Correct calculation of daily total water intake.
* **Verified:** Successful saving and fetching of data entities from Core Data.

### 5.2 UI & Compatibility Testing
* [cite_start]The app was tested on multiple simulators, including **iPhone SE (2nd Gen)** and **iPhone 12 Pro Max**, to ensure the responsive layout adapts correctly to different screen sizes[cite: 24].

### [cite_start]5.3 Performance Optimization [cite: 64]
* **Memory Management:** The History List was optimized to handle multiple records without scrolling lag.
* **HealthKit:** The syncing process is performed on a background thread to prevent blocking the main UI thread.

---

## [cite_start]6. AI-Assisted Development [cite: 123]

As per the submission guidelines, AI tools were utilized to assist in the development process:

* **Tools Used:** ChatGPT / GitHub Copilot.
* **Usage:**
    * **Asset Generation:** AI was used to generate the "AquaLog" App Icon concept.
    * **Debugging:** AI assisted in resolving `EXC_BAD_ACCESS` errors encountered during the tvOS view implementation.
    * **Refinement:** AI helped refine the pitch script for the Viva presentation to ensure clarity and conciseness.
* **Verification:** All AI-generated code was reviewed, tested, and integrated manually to ensure it met the project requirements.

---

## [cite_start]7. User Guide (Brief) [cite: 68]

1.  **Set Goal:** On the *Settings* tab, enter your daily water goal (e.g., 3000ml).
2.  **Add Water:** On the *Home* screen, tap the "+ 250ml" button. Long-press for larger amounts.
3.  **View History:** Navigate to the *History* tab to see past logs.
4.  **Sync:** Check the Apple Health app to see your synced data automatically.
5.  **TV Dashboard:** Open the tvOS app, use the remote to select your profile, and view your summary.

---

## 8. Conclusion & Reflection

This assignment provided a valuable opportunity to explore the full lifecycle of iOS development. Integrating **HealthKit** was a significant learning experience, understanding how to handle user permissions and write to the system's health store. Furthermore, developing for **tvOS** challenged me to think about user interaction differently, moving from touch gestures to remote-based focus navigation. Despite environmental limitations with Xcode, I successfully delivered a functional, persistent, and integrated application.

<p align="center">
<img src="https://img.icons8.com/color/96/000000/lotus.png" height="80" alt="Ayurveda App Icon"/>
</p>

<h1 align="center">🪷 Ayurvedic Digital Compendium</h1>
<p align="center">
A comprehensive Android application engineered to bridge ancient Ayurvedic wisdom with modern digital accessibility.
</p>

<p align="center">
<img src="https://img.shields.io/badge/Platform-Android-green.svg" alt="Platform: Android"/>
<img src="https://img.shields.io/github/license/rishigupta2004/ISE-Ayurveda-App" alt="License: MIT"/>
<img src="https://img.shields.io/github/languages/top/rishigupta2004/ISE-Ayurveda-App" alt="Top Language: Kotlin"/>
<img src="https://img.shields.io/github/last-commit/rishigupta2004/ISE-Ayurveda-App" alt="Last Commit"/>
</p>

---

## 📜 Abstract

This project presents a robust mobile application designed to serve as a digital compendium of traditional Ayurvedic medicine. The **ISE Ayurveda App** provides a structured, intuitive, and scholarly platform for users to explore, learn, and integrate the principles of Ayurveda into their daily lives. The application is built with a clean architecture and a user-centric design, focusing on delivering credible information and practical wellness tools. Its primary objective is to make the profound knowledge of Ayurveda accessible to a global audience, from laypersons to academic researchers.

---

## ✨ Core Features

| Feature                 | Description                                                                                             |
|-------------------------|---------------------------------------------------------------------------------------------------------|
| 🌿 **Herbal Database** | A comprehensive catalog of Ayurvedic herbs, detailing their botanical properties, therapeutic applications, and relevant scientific data. |
| 🩺 **Practitioner Connect** | A streamlined scheduling module for booking consultations with licensed Ayurvedic practitioners.           |
| 📰 **Knowledge Repository** | A curated collection of scholarly articles and educational content on diverse topics within Ayurvedic science. |
| 💬 **AI Assistant** | (Optional Implementation) An AI-driven conversational agent for preliminary health inquiries and herb-based suggestions. |
| 🔔 **Wellness Scheduler** | A configurable notification system to promote adherence to daily routines (e.g., hydration, meditation) and deliver insightful aphorisms. |
| 🌓 **Ergonomic UI/UX** | Dynamic theme adaptation (Light/Dark Mode) for enhanced user comfort and reduced eye strain during extended use. |

---

## 🔩 Technical Architecture

| Layer                   | Technology & Rationale                                                                        |
|-------------------------|-----------------------------------------------------------------------------------------------|
| **Presentation (UI)** | Android Native UI (XML Layouts & Jetpack Components) for optimal performance and platform consistency. |
| **Data & Persistence** | Local persistence via **Room Database**; optional cloud synchronization with **Firebase Firestore**. |
| **Core Language** | **Kotlin**, adhering to modern Android development paradigms for type-safety and conciseness.     |
| **Version Control** | **Git** & **GitHub** for collaborative development and source code management.                  |
| **Development IDE** | Android Studio (Latest Stable Build).                                                         |
| **Key Libraries** | **Glide** for efficient image loading, **Retrofit** for type-safe network operations (optional).        |

---

## 📁 Project Directory Structure

```bash
ISE-Ayurveda-App/
├── android/
│   └── app/
│       └── src/
│           ├── main/
│           │   ├── java/com/ise/ayurveda_app/  # Core application logic
│           │   │   └── MainActivity.kt
│           │   ├── res/                        # UI layouts, drawables, and values
│           │   │   ├── layout/
│           │   │   ├── drawable/
│           │   │   └── values/
│           │   └── AndroidManifest.xml         # App configuration
├── metadata/
├── .gitignore
├── README.md
└── LICENSE
```

---

## ⚙️ Build Instructions

To compile and run this project locally, please follow these steps:

1. **Prerequisites**: Ensure you have Android Studio (latest stable version), the Android SDK, and Git installed.
2. **Clone Repository**:
   ```bash
   git clone https://github.com/rishigupta2004/ISE-Ayurveda-App.git
   ```
3. **Import Project**: Open the cloned directory in Android Studio.
4. **Synchronize Dependencies**: Allow Gradle to sync and download the required project dependencies.
5. **Deploy Application**: Build and run the app on a physical Android device or an emulated one.
6. **(Optional)**: For full functionality, configure a Firebase project and connect it to the app for backend services, or ensure the Room database is correctly initialized for local persistence.

---

## 📈 Roadmap & Future Enhancements

| Domain                      | Planned Feature                                                                                               |
|-----------------------------|---------------------------------------------------------------------------------------------------------------|
| **Geospatial Services** | Integration with Google Maps API to locate and provide directions to affiliated Ayurvedic centers.              |
| **Artificial Intelligence** | Development of a machine-learning model to provide personalized herb and lifestyle recommendations.           |
| **Data Analytics** | A personal health dashboard for tracking key metrics, lifestyle habits, and treatment progress over time.     |
| **Interoperability** | Secure digital prescription management, utilizing PDF generation or QR codes for portability.                 |
| **Internationalization** | Full localization (i18n) to support multiple languages, including Hindi and Sanskrit, for broader accessibility. |

---

## 👥 Target Audience & Value Proposition

| Target User                 | Value Proposition                                                                                               |
|-----------------------------|-----------------------------------------------------------------------------------------------------------------|
| **Health-Conscious Individuals** | Provides a structured, credible resource for self-education and the adoption of Ayurvedic wellness practices.       |
| **Students & Researchers** | Offers a quick-reference digital tool for accessing information on Ayurvedic herbs and classical references. |
| **Ayurveda Clinics** | Presents a scalable framework for digital patient management, appointment scheduling, and community outreach. |

---

## 👨‍💻 Author

**Rishi Gupta**

* B.Tech, Information Science & Engineering | Class of 2026
* **LinkedIn**: [Connect with Rishi](https://www.linkedin.com/in/rishigupta2004)
* **Email**: [rishi.gupta.2004.2004@gmail.com](mailto:rishi.gupta.2004.2004@gmail.com)

---

## 📄 License

This project is distributed under the **MIT License**. Please see the `LICENSE` file for full details regarding rights and limitations.

---

## 🙏 Acknowledgements

* Guidance from the faculty of the Information Science and Engineering Department.
* Utilization of public datasets from the Ministry of AYUSH, Government of India (where applicable).
* The global Open Source community for its invaluable tools and libraries.

---

> "Let food be thy medicine and medicine be thy food." – Hippocrates

---

## 🤝 Contributing & Support

We welcome contributions to enhance the project. Please adhere to the following guidelines:

🌟 **Star** this repository to acknowledge its value.  
🍴 **Fork** the repository and submit a pull request for any contributions.  
🧵 **Report** bugs or suggest enhancements by creating an issue on the repository page.

# Barangay Profiling System

## 📚 Description

The **Barangay Profiling System** is a data-driven project designed to empower barangay officials with actionable insights for more efficient resource allocation. Developed as a capstone for Data Visualization and Business Intelligence courses (BSCS Major in Data Science), this system provides a comprehensive view of resident and document trends within a barangay.

By leveraging a multi-component architecture, the system collects vital demographic and purpose-related data via a user-friendly web survey. This data is then processed and visualized on an interactive online dashboard, enabling officials to understand patterns in document requests, client demographics (age, gender), and their purposes. This understanding facilitates informed decision-making, ensuring resources are distributed wisely to meet community needs.

---

## ✨ Features

This system comprises two main components that work in tandem to provide end-to-end data collection and visualization:

### Web Survey (Data Collection)

- User-friendly interface for residents to provide their profile information and document-related details.
- Designed for easy data input and submission.
- Collects demographic data (age, gender) and purpose of document requests.

### Online Dashboard (Data Visualization & Business Intelligence)

- Interactive dashboard providing visual representations of collected data.
- Displays trends related to barangay documents, client demographics, and their purposes.
- Aids barangay officials in understanding community needs and optimizing resource allocation.
- Provides insights into which barangay areas or client segments require specific attention.

---

## 🛠️ Technologies Used

This project utilizes a robust stack of **Google-centric technologies** for seamless data flow and visualization:

### Frontend (Web Survey)

- **Flutter (with Dart)**: For building the responsive and cross-platform web-based survey.

### Backend & Database

- **Firebase Hosting**: For deploying and hosting the Flutter web survey.
- **Firebase Firestore (NoSQL Database)**: For securely storing the raw survey responses.

### Data Pipeline & Transformation

- **Google Apps Script**: Custom scripts to automatically collect data from Firestore and transfer it to Google Sheets.
- **Google Sheets**: Serves as an intermediate, structured data source for the dashboard, allowing for potential pre-processing.

### Data Visualization & Business Intelligence

- **Google Looker Studio** (formerly Google Data Studio): For creating the interactive and insightful online dashboard.

> **Note on Repository Languages**: You may observe other languages like C++, CMake, Swift, C, and HTML in the repository. These are typically part of Flutter's underlying build process for different platforms (e.g., native compilation, build system configurations, web entry points) and do not represent direct coding contributions in those languages for the primary application logic.

---

## 🚀 Setup and Installation

Setting up this project involves configuring each component of the data pipeline.

### 1. Web Survey (Flutter) Setup

**Clone the repository:**

```
git clone https://github.com/melee45/barangay-profiling-system.git
cd barangay-profiling-system
```

**Install Flutter dependencies:**

```
flutter pub get
```

**Configure Firebase:**
- Create a new Firebase project in the Firebase Console.
- Add a web app and follow instructions to add Firebase config (usually in lib/main.dart or firebase_options.dart).
- Enable Firestore in your Firebase project.

**Run the web survey locally (for development):**

```
flutter run -d chrome
```

**Deploy the web survey to Firebase Hosting:**

```
firebase deploy --only hosting
```

### 2. Firebase Firestore Configuration
- Set up Firestore collections/documents to store survey responses.
- Write rules to allow writes from your app and reads for Apps Script.

### 3. Google Apps Script Setup (Data Transfer)
- Create a new Google Sheet (this will receive data).
- Open Google Apps Script:
- In your Sheet, go to Extensions > Apps Script.
- Example (conceptual, actual implementation will vary based on Firestore data structure and desired Sheet format):
```
function fetchDataFromFirestore() {
  const firestore = FirestoreApp.getFirestoreByEmail(
    "YOUR_FIREBASE_SERVICE_ACCOUNT_EMAIL", 
    "YOUR_FIREBASE_PRIVATE_KEY"
  ); // Or use FirebaseApp for public data

  const collectionName = "surveyResponses";
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("RawData");

  if (!sheet) {
    Logger.log("Sheet 'RawData' not found.");
    return;
  }

  sheet.clearContents();
  sheet.appendRow(["Timestamp", "Age", "Gender", "Purpose", "Barangay"]);

  const documents = firestore.getDocuments(collectionName);

  documents.forEach(doc => {
    const data = doc.getFields();
    sheet.appendRow([
      data.timestamp || '',
      data.age || '',
      data.gender || '',
      data.purpose || '',
      data.barangay || ''
    ]);
  });

  Logger.log("Data successfully transferred to Google Sheet.");
}

// Set up a time-driven trigger for this function
// Go to Triggers (clock icon on left sidebar in Apps Script editor)
// Add Trigger -> Choose function to run: fetchDataFromFirestore
// Select event source: Time-driven -> Select type of time based trigger: Day timer / Hour timer etc.
```
Set up a trigger:
- In Apps Script editor, click the clock icon.
- Add Trigger:
    - Function to run: fetchDataFromFirestore
    - Event source: Time-driven
    - Type: Daily/hourly (as needed)
> Important: Ensure you enable Firestore API access and permissions in Apps Script.

### 4. Google Looker Studio Dashboard Setup
- Go to Looker Studio.
- Create a report and add Google sheets as a data source.
- Connect your sheet from the previous step.
- Design charts, tables, and filters for:
    - Age distribution
    - Gender trends
    - Document purpose insights
- Share the report link with barangay officials

# SupportKit

Easy Firebase-powered support system for iOS apps.

## Requirements

- iOS 14.0+ / macOS 11.0+
- Firebase project with Firestore enabled
- Firebase iOS SDK already added to your project

## Installation

### 1. Add Firebase to Your Project First

In Xcode: **File → Add Package Dependencies**

Add Firebase SDK:
```
https://github.com/firebase/firebase-ios-sdk
```

Select these products:
- `FirebaseCore`
- `FirebaseFirestore`

### 2. Add SupportKit

Add SupportKit package:
```
https://github.com/yourusername/SupportKit
```

## Setup

### 1. Configure Firebase and SupportKit

```swift
import SwiftUI
import FirebaseCore
import SupportKit

@main
struct MyApp: App {
    init() {
        FirebaseApp.configure() // Required for SupportKit
        
        // Option 1: Default appearance
        SupportKit.configure()
        
        // Option 2: Custom appearance
        SupportKit.configure(SupportConfiguration(
            title: "Help & Support",
            primaryColor: .purple,
            buttonStyle: .filled,
            showCloseButton: true
        ))
        
        // Option 3: Predefined themes
        SupportKit.configure(.brand)    // Purple theme
        SupportKit.configure(.minimal)  // Gray theme
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 2. Customization Options

```swift
SupportConfiguration(
    title: "Your Title",           // Navigation title
    primaryColor: .blue,           // Accent color throughout
    buttonStyle: .filled,          // .filled, .bordered, or .plain
    showCloseButton: true          // Show/hide close button
)
```

### 3. Button Styles

- **`.filled`**: Solid background button (default)
- **`.bordered`**: Outlined button  
- **`.plain`**: Text-only button

### 4. Predefined Themes

```swift
.default  // Blue theme, filled buttons
.brand    // Purple theme, filled buttons  
.minimal  // Gray theme, plain buttons
```

### 2. Add Firestore Security Rules

In Firebase Console → Firestore Database → Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow support feedback submission
    match /support_feedback/{document} {
      allow write: if 
        request.resource.data.keys().hasAll(['email', 'feedbackType', 'description', 'timestamp']) &&
        request.resource.data.email is string &&
        request.resource.data.email.matches('.*@.*') &&
        request.resource.data.feedbackType in ['bug', 'feedback', 'suggestion'] &&
        request.resource.data.description is string &&
        request.resource.data.description.size() > 0;
      
      allow read: if false; // Users can't read others' feedback
    }
    
    // Block everything else
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

## Usage

### Present Support UI

```swift
import SupportKit

struct ContentView: View {
    @State private var showingSupport = false
    
    var body: some View {
        VStack {
            Button("Contact Support") {
                showingSupport = true
            }
        }
        .sheet(isPresented: $showingSupport) {
            SupportKit.presentSupport()
        }
    }
}
```

### Programmatic Submission

```swift
import SupportKit

func submitBugReport() {
    SupportKit.submitFeedback(
        email: "user@example.com",
        type: .bug,
        description: "App crashes when opening settings"
    ) { result in
        switch result {
        case .success():
            print("Feedback submitted successfully")
        case .failure(let error):
            print("Failed to submit feedback: \(error)")
        }
    }
}
```

### Available Feedback Types

```swift
.bug         // Bug Report
.feedback    // General Feedback  
.suggestion  // Feature Suggestion
```

## Data Structure

Feedback is stored in Firestore under the `support_feedback` collection:

```
support_feedback/
  └── {feedbackId}/
      ├── id: String
      ├── email: String
      ├── feedbackType: String ("bug", "feedback", "suggestion")
      ├── description: String
      └── timestamp: Timestamp
```

## Features

- ✅ Simple 3-field form (email, type, description)
- ✅ Input validation
- ✅ Loading states
- ✅ Error handling
- ✅ Success feedback
- ✅ Programmatic API
- ✅ SwiftUI native
- ✅ Firebase Firestore integration

## Requirements for Your Firebase Project

1. Create a Firestore database
2. Set up the security rules above
3. Your app must call `FirebaseApp.configure()` before using SupportKit

That's it! SupportKit handles everything else automatically.

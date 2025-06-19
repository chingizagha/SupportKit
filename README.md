# SupportKit

Easy Firebase-powered support system for iOS apps.

## Requirements

- iOS 14.0+ / macOS 11.0+
- Firebase project with Firestore enabled
- Firebase iOS SDK already added to your project

## Installation

### ⚠️ Important: Add Firebase First!

**Step 1: Add Firebase SDK to your app**

In Xcode: **File → Add Package Dependencies**

```
https://github.com/firebase/firebase-ios-sdk
```

**Required Firebase products for your app target:**
- ✅ `FirebaseCore`
- ✅ `FirebaseFirestore`

**Step 2: Add SupportKit**

Then add SupportKit package:
```
https://github.com/chingizagha/SupportKit
```

### Complete Package.swift Example

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "YourApp",
    platforms: [.iOS(.v14)],
    products: [
        .executable(name: "YourApp", targets: ["YourApp"])
    ],
    dependencies: [
        // Add Firebase FIRST
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.0.0"),
        // Then add SupportKit
        .package(url: "https://github.com/chingizagha/SupportKit", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "YourApp",
            dependencies: [
                // Firebase dependencies for your app
                .product(name: "FirebaseCore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                // SupportKit dependency
                .product(name: "SupportKit", package: "SupportKit")
            ]
        )
    ]
)
```

## Setup

### 1. Create Firebase Provider in Your App

Create a file `FirebaseProvider.swift` in your app:

```swift
import Foundation
import Combine
import FirebaseFirestore
import SupportKit

class MyFirebaseProvider: SupportFirebaseProtocol {
    private let db = Firestore.firestore()
    
    func submitFeedback(_ feedback: SupportFeedback) -> AnyPublisher<Void, Error> {
        return Future { promise in
            do {
                let feedbackData = try Firestore.Encoder().encode(feedback)
                
                self.db.collection("support_feedback").document(feedback.id).setData(feedbackData) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
```

### 2. Configure Firebase and SupportKit

```swift
import SwiftUI
import FirebaseCore
import SupportKit

@main
struct MyApp: App {
    init() {
        // Configure Firebase first
        FirebaseApp.configure()
        
        // Configure SupportKit with your Firebase provider
        SupportKit.configure(
            firebaseProvider: MyFirebaseProvider(),
            configuration: .brand
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 3. Customization Options

```swift
// Option 1: Default appearance
SupportKit.configure(
    firebaseProvider: MyFirebaseProvider()
)

// Option 2: Custom appearance
SupportKit.configure(
    firebaseProvider: MyFirebaseProvider(),
    configuration: SupportConfiguration(
        title: "Help & Support",
        primaryColor: .purple,
        buttonStyle: .filled,
        showCloseButton: true
    )
)

// Option 3: Predefined themes
SupportKit.configure(
    firebaseProvider: MyFirebaseProvider(),
    configuration: .brand    // Purple theme
)

SupportKit.configure(
    firebaseProvider: MyFirebaseProvider(),
    configuration: .minimal  // Gray theme
)
```

### 4. Customization Settings

```swift
SupportConfiguration(
    title: "Your Title",           // Navigation title
    primaryColor: .blue,           // Accent color throughout
    buttonStyle: .filled,          // .filled, .bordered, or .plain
    showCloseButton: true          // Show/hide close button
)
```

### 5. Button Styles

- **`.filled`**: Solid background button (default)
- **`.bordered`**: Outlined button  
- **`.plain`**: Text-only button

### 6. Predefined Themes

```swift
.default  // Blue theme, filled buttons
.brand    // Purple theme, filled buttons  
.minimal  // Gray theme, plain buttons
```

### 7. Add Firestore Security Rules

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
- ✅ Customizable appearance
- ✅ Multiple themes
- ✅ Protocol-based architecture

## Troubleshooting

### Error: "Missing required modules: 'FirebaseCore', 'FirebaseCoreExtension'"

This means Firebase isn't properly added to your app. Fix:

1. **Check Package Dependencies**: Ensure Firebase SDK is added to your **app target** (not just the package)
2. **Required Firebase Products**: Add `FirebaseCore` and `FirebaseFirestore` to your app target
3. **Build Order**: Add Firebase first, then SupportKit
4. **Clean Build**: Product → Clean Build Folder, then rebuild

### Error: "No such module 'FirebaseFirestore'"

Your app target is missing FirebaseFirestore:
1. Select your app target in Xcode
2. Go to **Build Phases → Link Binary With Libraries**  
3. Add `FirebaseFirestore` if missing

### Error: "SupportKit not configured"

Make sure you create and configure the Firebase provider:

```swift
// Create provider
class MyFirebaseProvider: SupportFirebaseProtocol { ... }

// Configure SupportKit
SupportKit.configure(firebaseProvider: MyFirebaseProvider())
```

### Error: App crashes on Firebase methods

Make sure you call `FirebaseApp.configure()` in your App.swift:

```swift
import FirebaseCore

@main
struct YourApp: App {
    init() {
        FirebaseApp.configure() // ← Required!
    }
    // ...
}
```

### Still having issues?

1. Restart Xcode
2. Delete derived data: `~/Library/Developer/Xcode/DerivedData`
3. Clean and rebuild project
4. Make sure you created the Firebase provider class in your app
5. Verify Firebase rules are set up correctly

## Requirements for Your Firebase Project

1. Create a Firestore database
2. Set up the security rules above
3. Your app must call `FirebaseApp.configure()` before using SupportKit
4. Create a class implementing `SupportFirebaseProtocol` in your app

That's it! SupportKit handles everything else automatically.

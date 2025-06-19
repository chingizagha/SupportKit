# SupportKit

Firebase-powered support system for iOS apps with 3 lines of setup.

## Features

- Customizable UI with multiple themes
- SwiftUI native with smooth animations  
- Firebase Firestore integration
- Easy 3-line setup
- Full Swift type safety
- Programmatic API

## Quick Start

### 1. Add Dependencies

**Firebase first:**
```
https://github.com/firebase/firebase-ios-sdk
```
Select: `FirebaseCore` + `FirebaseFirestore`

**Then SupportKit:**
```  
https://github.com/chingizagha/SupportKit
```

### 2. Setup (3 lines)

```swift
// App.swift
import FirebaseCore
import SupportKit

@main
struct MyApp: App {
    init() {
        FirebaseApp.configure()
        SupportKit.configure(firebaseProvider: MyFirebaseProvider())
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 3. Create Firebase Provider

```swift
// MyFirebaseProvider.swift
import FirebaseFirestore
import SupportKit

final class MyFirebaseProvider: SupportFirebaseProtocol {
    func submitFeedback(_ feedback: SupportFeedback) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            let data: [String: Any] = [
                "email": feedback.email,
                "type": feedback.feedbackType.rawValue,
                "description": feedback.description,
                "timestamp": Timestamp(date: feedback.timestamp)
            ]
            
            Firestore.firestore()
                .collection("support_feedback")
                .document(feedback.id)
                .setData(data) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
```

### 4. Show Support UI

```swift
// ContentView.swift
import SupportKit

struct ContentView: View {
    @State private var showSupport = false
    
    var body: some View {
        Button("Help & Support") {
            showSupport = true
        }
        .sheet(isPresented: $showSupport) {
            SupportKit.presentSupport()
        }
    }
}
```

## Customization

### Built-in Themes

```swift
SupportKit.configure(firebaseProvider: provider, configuration: .default)  // Blue
SupportKit.configure(firebaseProvider: provider, configuration: .brand)    // Purple  
SupportKit.configure(firebaseProvider: provider, configuration: .minimal)  // Gray
```

### Custom Configuration

```swift
SupportKit.configure(
    firebaseProvider: MyFirebaseProvider(),
    configuration: SupportConfiguration(
        title: "Get Help",
        primaryColor: .red,
        buttonStyle: .bordered,
        showCloseButton: true
    )
)
```

### Button Styles

- `.filled` - Solid background button
- `.bordered` - Outlined button
- `.plain` - Text only button

## Firebase Setup

### Firestore Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /support_feedback/{document} {
      allow write: if 
        request.resource.data.email is string &&
        request.resource.data.email.matches('.*@.*');
      allow read: if false;
    }
  }
}
```

### Data Structure

```
support_feedback/
  └── {feedbackId}/
      ├── email: "user@example.com"
      ├── type: "bug" | "feedback" | "suggestion"  
      ├── description: "App crashes when..."
      └── timestamp: Timestamp
```

## Programmatic Usage

```swift
SupportKit.submitFeedback(
    email: "user@example.com",
    type: .bug,
    description: "App crashes on startup"
) { result in
    switch result {
    case .success():
        print("Feedback sent")
    case .failure(let error):
        print("Error: \(error)")
    }
}
```

## Troubleshooting

**Can't see protocol?**
- Make sure Firebase is added to your app target
- Clean build folder and rebuild

**App crashes?**
- Add `FirebaseApp.configure()` in App.swift
- Check Firebase provider implementation

**Firebase errors?**
- Verify Firestore rules are set up
- Check internet connection

## Requirements

- iOS 14.0+


# AquaLog Technical Architecture

## Project Structure

```
AquaLog/
├── AquaLog-iOS/
│   ├── AquaLog.xcodeproj
│   ├── AquaLog/
│   │   ├── Models/
│   │   │   ├── WaterEntry+CoreDataClass.swift
│   │   │   ├── WaterEntry+CoreDataProperties.swift
│   │   │   └── CoreDataManager.swift
│   │   ├── Views/
│   │   │   ├── HomeView.swift
│   │   │   ├── HistoryView.swift
│   │   │   ├── SettingsView.swift
│   │   │   └── Components/
│   │   │       └── WaterBottleView.swift
│   │   ├── ViewModels/
│   │   │   ├── HomeViewModel.swift
│   │   │   ├── HistoryViewModel.swift
│   │   │   └── SettingsViewModel.swift
│   │   ├── Services/
│   │   │   ├── HealthKitManager.swift
│   │   │   └── UserDefaultsManager.swift
│   │   ├── Resources/
│   │   │   ├── Assets.xcassets
│   │   │   └── Info.plist
│   │   └── AquaLogApp.swift
│   └── AquaLog.xcdatamodeld
└── AquaLog-tvOS/
    ├── AquaLogTV.xcodeproj
    └── AquaLogTV/
        ├── Views/
        │   ├── ProfileSelectionView.swift
        │   ├── DashboardView.swift
        │   └── Components/
        │       └── WaterBottleView.swift
        ├── Models/
        │   └── UserProfile.swift
        └── AquaLogTVApp.swift
```

## Core Data Model

### WaterEntry Entity
```swift
Entity: WaterEntry
Attributes:
- id: UUID (required, indexed)
- date: Date (required, indexed)
- amount: Double (required)
- createdAt: Date (required)
```

### Core Data Stack
```swift
class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // CRUD operations for WaterEntry
    func saveWaterEntry(amount: Double, date: Date) throws
    func fetchWaterEntries(for date: Date) -> [WaterEntry]
    func fetchWaterEntries(for dateRange: DateInterval) -> [WaterEntry]
    func deleteWaterEntry(_ entry: WaterEntry) throws
}
```

## iOS App Architecture

### Navigation Flow
```
NavigationView (Root)
├── HomeView (Tab 1)
│   ├── WaterBottleView (Custom Component)
│   ├── Progress Text
│   ├── Add Water Button (+250ml)
│   └── NavigationLinks to:
│       ├── HistoryView
│       └── SettingsView
├── HistoryView (Tab 2)
└── SettingsView (Tab 3)
```

### View Models

#### HomeViewModel
```swift
class HomeViewModel: ObservableObject {
    @Published var todayProgress: Double = 0
    @Published var dailyGoal: Double = 2500
    @Published var todayEntries: [WaterEntry] = []
    
    func loadTodayData()
    func addWater(amount: Double)
    func updateProgress()
}
```

#### HistoryViewModel
```swift
class HistoryViewModel: ObservableObject {
    @Published var entries: [WaterEntry] = []
    @Published var groupedEntries: [Date: [WaterEntry]] = [:]
    
    func loadHistory()
    func groupEntriesByDate()
}
```

#### SettingsViewModel
```swift
class SettingsViewModel: ObservableObject {
    @Published var dailyGoal: Double = 2500
    
    func loadGoal()
    func saveGoal(_ goal: Double)
}
```

### Services

#### HealthKitManager
```swift
class HealthKitManager {
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void)
    func writeWaterEntry(amount: Double, date: Date, completion: @escaping (Bool, Error?) -> Void)
}
```

#### UserDefaultsManager
```swift
struct UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let dailyGoalKey = "dailyGoal"
    
    var dailyGoal: Double {
        get { UserDefaults.standard.double(forKey: dailyGoalKey) }
        set { UserDefaults.standard.set(newValue, forKey: dailyGoalKey) }
    }
}
```

## Custom Components

### WaterBottleView
```swift
struct WaterBottleView: View {
    @Binding var progress: Double // 0.0 to 1.0
    let bottleHeight: CGFloat
    let bottleWidth: CGFloat
    
    var body: some View {
        // Custom shape with fill animation
        ZStack {
            // Bottle outline
            BottleShape()
                .stroke(Color.blue, lineWidth: 2)
            
            // Water fill
            BottleShape()
                .fill(Color.blue.opacity(0.6))
                .scaleEffect(x: 1.0, y: progress, anchor: .bottom)
                .animation(.easeInOut(duration: 0.5), value: progress)
        }
    }
}
```

## tvOS App Architecture

### Navigation Flow
```
ProfileSelectionView (Root)
└── DashboardView (Selected Profile)
    ├── User Name Header
    ├── Daily Goal Display
    ├── Current Progress
    └── WaterBottleView (Large)
```

### Models

#### UserProfile
```swift
struct UserProfile: Identifiable {
    let id = UUID()
    let name: String
    let dailyGoal: Double
    let currentProgress: Double
}
```

### Views

#### ProfileSelectionView
```swift
struct ProfileSelectionView: View {
    @State private var selectedProfile: UserProfile?
    let profiles: [UserProfile] = [
        UserProfile(name: "User 1", dailyGoal: 3000, currentProgress: 1500),
        UserProfile(name: "User 2", dailyGoal: 2500, currentProgress: 2000),
        UserProfile(name: "Guest", dailyGoal: 2000, currentProgress: 800)
    ]
    
    var body: some View {
        // Grid of profile cards with focus states
    }
}
```

#### DashboardView
```swift
struct DashboardView: View {
    let profile: UserProfile
    @State private var isFocused: Bool = false
    
    var body: some View {
        // Full-screen dashboard with large WaterBottleView
        // Focusable elements for Siri Remote navigation
    }
}
```

## Data Flow

### iOS App Data Flow
1. User taps "Add Water" button
2. HomeViewModel creates WaterEntry with current date/amount
3. CoreDataManager saves entry to Core Data
4. HealthKitManager writes same entry to HealthKit
5. HomeViewModel updates UI with new progress
6. SettingsViewModel loads/saves dailyGoal from UserDefaults

### tvOS App Data Flow
1. User selects profile from ProfileSelectionView
2. DashboardView displays hard-coded data for selected profile
3. WaterBottleView animates based on progress value
4. Focus states update based on Siri Remote navigation

## Platform-Specific Considerations

### iOS
- Core Data for persistent storage
- HealthKit integration for health data sync
- UserDefaults for simple settings
- NavigationView for iOS 14.5 compatibility
- Dark Mode and Dynamic Type support

### tvOS
- Hard-coded data for prototype
- Focus states for remote navigation
- Large, readable UI elements
- Shared WaterBottleView component
- Multi-user profile selection

## Testing Strategy

### Unit Tests
- Core Data CRUD operations
- HealthKit authorization and data writing
- ViewModel business logic
- UserDefaults persistence

### UI Tests
- Navigation flow verification
- Water entry addition workflow
- Settings persistence
- Dark Mode appearance
- Dynamic Type scaling

### tvOS Tests
- Profile selection navigation
- Focus state management
- Remote control navigation
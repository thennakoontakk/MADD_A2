# AquaLog - Water Tracking App

## Project Overview

AquaLog is a comprehensive water tracking solution consisting of an iOS app for personal hydration tracking and a tvOS companion app for household dashboard viewing.

### Concept
A simple, user-friendly iOS app for tracking daily water intake with a companion tvOS app that acts as a passive, multi-user dashboard for a household.

### Target Environment
- **iOS App**: iOS 14.5 (due to Xcode 12.5 limitations)
- **tvOS App**: tvOS 14
- **Core Technologies**: SwiftUI, Core Data, HealthKit

## Part A: AquaLog iOS App

### Core Purpose & Audience
**Purpose**: Help users track their daily water consumption against a personal goal.
**Audience**: Health-conscious individuals or anyone needing to monitor their hydration.

### Screens & Navigation

#### Screen 1: Home View (Main Screen)
**Purpose**: Show today's progress and allow users to add water.
**UI Components**:
- Text label showing progress (e.g., "1200ml / 2500ml")
- Custom SwiftUI Component (WaterBottleView): Water bottle/glass custom shape with fill animation
- Button ("+ 250ml") to add a standard glass of water
- LongPressGesture on "+" button to add larger amount (e.g., 500ml)

**Navigation**: NavigationLinks to History View and Settings View

#### Screen 2: History View
**Purpose**: Show past water intake records.
**UI Components**:
- List view with each row displaying date and total water consumed
- Data populated from Core Data

#### Screen 3: Settings View
**Purpose**: Allow users to set their daily hydration goal.
**UI Components**:
- Text label: "Set Your Daily Goal (ml)"
- TextField or Stepper for goal input
- Data saved to UserDefaults

### Key Technologies & Features

#### Data Persistence (Core Data)
- **Entity**: WaterEntry
- **Attributes**:
  - date: Date
  - amount: Double
- **Logic**: Create WaterEntry object on "Add Water" button click, save to Core Data

#### HealthKit Integration
- Request authorization for HKQuantityTypeIdentifier.dietaryWater
- Write water entries to Apple Health app when user adds water

#### Visual Design & Accessibility
- Clean, blue-themed design
- Full Dark Mode support
- Dynamic Type support for font scaling

## Part B: AquaLog TV Prototype

### Innovative Concept
**Purpose**: "Lean-back" dashboard for living room TV that passively reminds household members of hydration goals
**Platform**: tvOS
**Core Innovation**: Multi-user context leveraging shared TV environment

### Prototype Features

#### Feature 1: Multi-User Profile Selection
- Simple selection screen with profiles (User 1, User 2, Guest)
- Hard-coded profiles for prototype (no iOS syncing required)

#### Feature 2: User-Specific Dashboard
- Full-screen dashboard showing:
  - User's Name (e.g., "User 1's Hydration")
  - Daily Goal (hard-coded value like "3000ml")
  - Current Progress (hard-coded value like "1500ml")
  - Large animated WaterBottleView from iOS app

#### UX & Interaction
- Navigable only using Siri Remote
- Clear focus states for all selectable items (scaling, glow effects)

### Pitch Presentation Points
- **Value Proposition**: "AquaLog TV turns your family's hydration goals into a visible, shared household habit."
- **Target Market**: Health-conscious families, people working from home
- **Revenue Model**: iOS app is free; tvOS companion app is premium feature

## Technical Implementation Notes

### Navigation Challenge Solution
- Using NavigationView instead of NavigationStack due to Xcode 12.5 iOS 16 support limitations
- This will be documented in the "Challenges" section

### Architecture
- iOS app: SwiftUI + Core Data + HealthKit
- tvOS app: SwiftUI with hard-coded data for prototype
- Shared components: WaterBottleView can be reused across platforms
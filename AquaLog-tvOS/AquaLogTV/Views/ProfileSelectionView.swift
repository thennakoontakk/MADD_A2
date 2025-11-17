import SwiftUI

struct ProfileSelectionView: View {
    let onProfileSelected: (UserProfile) -> Void
    @State private var focusedProfile: UserProfile?
    
    let profiles = UserProfile.sampleProfiles
    
    var body: some View {
        VStack(spacing: 60) {
            // Header
            VStack(spacing: 20) {
                Image(systemName: "drop.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                Text("AquaLog TV")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Select a profile to view hydration dashboard")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 80)
            
            // Profile Grid
            HStack(spacing: 60) {
                ForEach(profiles) { profile in
                    Button(action: {
                        onProfileSelected(profile)
                    }) {
                        ProfileCard(
                            profile: profile,
                            isFocused: false,
                            isSelected: false
                        )
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    .focusable(true)
                }
            }
            .padding(.horizontal, 100)
            
            Spacer()
            
            // Instructions
            VStack(spacing: 12) {
                Text("Use Siri Remote to navigate")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.secondary)
                
                HStack(spacing: 20) {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 24))
                    Text("Swipe up/down to select")
                        .font(.system(size: 16))
                }
                
                HStack(spacing: 20) {
                    Image(systemName: "playpause.fill")
                        .font(.system(size: 24))
                    Text("Click to select profile")
                        .font(.system(size: 16))
                }
            }
            .padding(.bottom, 60)

            // Prototype-only UI: direct navigation handled on card tap
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.95))
        .onAppear {
            focusedProfile = nil
        }
    }
}

struct ProfileCard: View {
    let profile: UserProfile
    let isFocused: Bool
    let isSelected: Bool
    
    private var color: Color {
        switch profile.color {
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        default: return .blue
        }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            // Avatar
            ZStack {
                Circle()
                    .fill((isSelected ? Color.blue : color).opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "person.fill")
                    .font(.system(size: 60))
                    .foregroundColor(isSelected ? .blue : color)
            }
            
            // Name
            Text(profile.name)
                .font(.system(size: 28, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
            
            // Progress
            VStack(spacing: 8) {
                Text("\(Int(profile.currentProgress))ml / \(Int(profile.dailyGoal))ml")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.secondary)
                
                ProgressView(value: profile.progressPercentage)
                    .accentColor(color)
                    .frame(width: 120, height: 8)
                    .scaleEffect(x: 1, y: 2, anchor: .center)
            }
            
            // Status
            Text(profile.progressPercentage >= 1.0 ? "Goal Reached!" : "\(Int(profile.remainingAmount))ml remaining")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(profile.progressPercentage >= 1.0 ? .green : .orange)
        }
        .padding(40)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        .scaleEffect(1.0)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.clear, lineWidth: 0)
        )
    }
}

// Prototype-only: summary removed; navigation happens on card click

struct ProfileSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSelectionView { profile in
            print("Selected: \(profile.name)")
        }
    }
}
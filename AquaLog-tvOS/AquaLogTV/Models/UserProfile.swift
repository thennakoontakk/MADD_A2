import Foundation

struct UserProfile: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let dailyGoal: Double
    let currentProgress: Double
    let color: String
    
    var progressPercentage: Double {
        return min(currentProgress / dailyGoal, 1.0)
    }
    
    var remainingAmount: Double {
        return max(dailyGoal - currentProgress, 0)
    }
}

extension UserProfile {
    static let sampleProfiles = [
        UserProfile(name: "User 1", dailyGoal: 3000, currentProgress: 1500, color: "blue"),
        UserProfile(name: "User 2", dailyGoal: 2500, currentProgress: 2000, color: "green"),
        UserProfile(name: "Guest", dailyGoal: 2000, currentProgress: 800, color: "orange")
    ]
}
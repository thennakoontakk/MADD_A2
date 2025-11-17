import Foundation

struct UserDefaultsManager {
    static var shared = UserDefaultsManager()
    
    private let dailyGoalKey = "dailyGoal"
    private let healthKitAuthorizedKey = "healthKitAuthorized"
    
    var dailyGoal: Double {
        get { 
            let storedValue = UserDefaults.standard.double(forKey: dailyGoalKey)
            return storedValue > 0 ? storedValue : 2500.0 // Default 2500ml
        }
        set { UserDefaults.standard.set(newValue, forKey: dailyGoalKey) }
    }
    
    var isHealthKitAuthorized: Bool {
        get { UserDefaults.standard.bool(forKey: healthKitAuthorizedKey) }
        set { UserDefaults.standard.set(newValue, forKey: healthKitAuthorizedKey) }
    }
}
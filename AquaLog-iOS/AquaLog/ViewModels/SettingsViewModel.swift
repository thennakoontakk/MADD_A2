import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    @Published var dailyGoal: Double = 2500
    @Published var isHealthKitAuthorized = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadSettings()
    }
    
    func loadSettings() {
        dailyGoal = UserDefaultsManager.shared.dailyGoal
        isHealthKitAuthorized = HealthKitManager.shared.isAuthorized()
    }
    
    func saveDailyGoal(_ goal: Double) {
        UserDefaultsManager.shared.dailyGoal = goal
        self.dailyGoal = goal
    }
    
    func requestHealthKitAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        HealthKitManager.shared.requestAuthorization { success, error in
            DispatchQueue.main.async {
                self.isHealthKitAuthorized = HealthKitManager.shared.isAuthorized()
                UserDefaultsManager.shared.isHealthKitAuthorized = self.isHealthKitAuthorized
                completion(success, error)
            }
        }
    }
}
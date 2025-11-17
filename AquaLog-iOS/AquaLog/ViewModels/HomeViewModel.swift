import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var todayProgress: Double = 0
    @Published var dailyGoal: Double = 2500
    @Published var todayEntries: [WaterEntry] = []
    @Published var isHealthKitAuthorized = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadTodayData()
        loadDailyGoal()
        checkHealthKitAuthorization()
    }
    
    func loadTodayData() {
        todayEntries = CoreDataManager.shared.fetchWaterEntries(for: Date())
        updateProgress()
    }
    
    func loadDailyGoal() {
        dailyGoal = UserDefaultsManager.shared.dailyGoal
    }
    
    func checkHealthKitAuthorization() {
        isHealthKitAuthorized = HealthKitManager.shared.isAuthorized()
    }
    
    func addWater(amount: Double) {
        do {
            try CoreDataManager.shared.saveWaterEntry(amount: amount)
            
            if isHealthKitAuthorized {
                HealthKitManager.shared.writeWaterEntry(amount: amount) { success, error in
                    if let error = error {
                        print("HealthKit write error: \(error.localizedDescription)")
                    }
                }
            }
            
            loadTodayData()
        } catch {
            print("Error saving water entry: \(error)")
        }
    }
    
    func updateProgress() {
        let totalWater = todayEntries.reduce(0) { $0 + $1.amount }
        todayProgress = min(totalWater / dailyGoal, 1.0)
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
import Foundation
import HealthKit

class HealthKitManager {
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()
    
    private init() {}
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, NSError(domain: "HealthKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available on this device"]))
            return
        }

        let waterType = HKQuantityType.quantityType(forIdentifier: .dietaryWater)!
        let typesToShare: Set<HKSampleType> = [waterType]
        let typesToRead: Set<HKObjectType> = [waterType]

        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }
    
    func writeWaterEntry(amount: Double, date: Date = Date(), completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, NSError(domain: "HealthKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available on this device"]))
            return
        }

        let waterType = HKQuantityType.quantityType(forIdentifier: .dietaryWater)!

        guard healthStore.authorizationStatus(for: waterType) == .sharingAuthorized else {
            completion(false, NSError(domain: "HealthKit", code: 2, userInfo: [NSLocalizedDescriptionKey: "Not authorized to write dietary water"]))
            return
        }

        let quantity = HKQuantity(unit: .literUnit(with: .milli), doubleValue: amount)
        let sample = HKQuantitySample(type: waterType, quantity: quantity, start: date, end: date)

        healthStore.save(sample) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }
    
    func isAuthorized() -> Bool {
        let waterType = HKQuantityType.quantityType(forIdentifier: .dietaryWater)!
        return healthStore.authorizationStatus(for: waterType) == .sharingAuthorized
    }

    func authorizationStatus() -> HKAuthorizationStatus {
        let waterType = HKQuantityType.quantityType(forIdentifier: .dietaryWater)!
        return healthStore.authorizationStatus(for: waterType)
    }

    func isHealthDataAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
}
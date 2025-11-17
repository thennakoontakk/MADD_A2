import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AquaLog")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func saveWaterEntry(amount: Double, date: Date = Date()) throws {
        let entry = WaterEntry(context: context)
        entry.id = UUID()
        entry.amount = amount
        entry.date = date
        entry.createdAt = Date()
        
        saveContext()
    }
    
    func fetchWaterEntries(for date: Date) -> [WaterEntry] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let fetchRequest: NSFetchRequest<WaterEntry> = WaterEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching water entries: \(error)")
            return []
        }
    }
    
    func fetchWaterEntries(for dateRange: DateInterval) -> [WaterEntry] {
        let fetchRequest: NSFetchRequest<WaterEntry> = WaterEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@", dateRange.start as NSDate, dateRange.end as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching water entries: \(error)")
            return []
        }
    }
    
    func deleteWaterEntry(_ entry: WaterEntry) throws {
        context.delete(entry)
        saveContext()
    }
    
    func getTotalWaterForDate(_ date: Date) -> Double {
        let entries = fetchWaterEntries(for: date)
        return entries.reduce(0) { $0 + $1.amount }
    }
}
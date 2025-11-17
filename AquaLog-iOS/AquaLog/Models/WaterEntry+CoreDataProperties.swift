import Foundation
import CoreData

extension WaterEntry {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WaterEntry> {
        return NSFetchRequest<WaterEntry>(entityName: "WaterEntry")
    }

    @NSManaged public var amount: Double
    @NSManaged public var createdAt: Date
    @NSManaged public var date: Date
    @NSManaged public var id: UUID

}

extension WaterEntry : Identifiable {
    
}
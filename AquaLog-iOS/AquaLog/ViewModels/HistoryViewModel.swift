import Foundation
import Combine

class HistoryViewModel: ObservableObject {
    @Published var entries: [WaterEntry] = []
    @Published var groupedEntries: [Date: [WaterEntry]] = [:]
    @Published var dailyTotals: [Date: Double] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadHistory()
    }
    
    func loadHistory() {
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        let dateInterval = DateInterval(start: thirtyDaysAgo, end: Date())
        
        entries = CoreDataManager.shared.fetchWaterEntries(for: dateInterval)
        groupEntriesByDate()
        calculateDailyTotals()
    }
    
    func groupEntriesByDate() {
        groupedEntries = Dictionary(grouping: entries) { entry in
            Calendar.current.startOfDay(for: entry.date)
        }
    }
    
    func calculateDailyTotals() {
        dailyTotals = [:]
        for (date, dayEntries) in groupedEntries {
            dailyTotals[date] = dayEntries.reduce(0) { $0 + $1.amount }
        }
    }
    
    func getSortedDates() -> [Date] {
        return groupedEntries.keys.sorted(by: >)
    }
    
    func getFormattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    func deleteEntry(_ entry: WaterEntry) {
        do {
            try CoreDataManager.shared.deleteWaterEntry(entry)
            loadHistory()
        } catch {
            print("Error deleting entry: \(error)")
        }
    }
}
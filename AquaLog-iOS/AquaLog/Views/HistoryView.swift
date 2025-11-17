import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.getSortedDates(), id: \.self) { date in
                Section(header: Text(viewModel.getFormattedDate(date))) {
                    if let total = viewModel.dailyTotals[date] {
                        HStack {
                            Label("Total Intake", systemImage: "drop.fill")
                                .foregroundColor(.blue)
                            
                            Spacer()
                            
                            Text("\(Int(total))ml")
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }
                        .padding(.vertical, 8)
                    }
                    
                    if let entries = viewModel.groupedEntries[date] {
                        ForEach(entries) { entry in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                
                                Text("\(Int(entry.amount))ml")
                                    .font(.body)
                                
                                Spacer()
                                
                                Text(entry.createdAt, style: .time)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete { indexSet in
                            deleteEntries(at: indexSet, from: date)
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.loadHistory()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        .overlay(
            Group {
                if viewModel.entries.isEmpty {
                    EmptyStateView()
                } else {
                    EmptyView()
                }
            }
        )
    }
    
    private func deleteEntries(at offsets: IndexSet, from date: Date) {
        guard let entries = viewModel.groupedEntries[date] else { return }
        
        for index in offsets {
            if index < entries.count {
                viewModel.deleteEntry(entries[index])
            }
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "drop")
                .font(.system(size: 60))
                .foregroundColor(.blue.opacity(0.5))
            
            Text("No Water Entries Yet")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Start tracking your hydration by adding water entries from the Home tab.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HistoryView()
        }
    }
}
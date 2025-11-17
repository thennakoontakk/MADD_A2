import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showingHealthKitAlert = false
    private let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .none
        nf.minimum = 0
        nf.maximum = 10000
        return nf
    }()
    
    var body: some View {
        List {
            // Daily Goal Section
            Section(header: Text("Daily Goal")) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Set Your Daily Goal (ml)")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack {
                        TextField("Daily Goal", value: $viewModel.dailyGoal, formatter: numberFormatter)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                        
                        Text("ml")
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Stepper("", value: $viewModel.dailyGoal, in: 500...5000, step: 250)
                            .labelsHidden()
                    }
                    
                    Text("Recommended: 2000-3000ml per day")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
            
            // HealthKit Section
            Section(header: Text("Health Integration")) {
                if viewModel.isHealthKitAuthorized {
                    HStack {
                        Label {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Apple Health")
                                    .font(.body)
                                Text("Connected")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        } icon: {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                } else {
                    Button(action: {
                        viewModel.requestHealthKitAuthorization { success, error in
                            if let error = error {
                                print("HealthKit authorization error: \(error.localizedDescription)")
                            }
                        }
                    }) {
                        HStack {
                            Label {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Connect to Apple Health")
                                        .font(.body)
                                    Text("Sync your water intake")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            } icon: {
                                Image(systemName: "heart")
                                    .foregroundColor(.red)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
            
            // App Information Section
            Section(header: Text("App Information")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Build")
                    Spacer()
                    Text("2024.1")
                        .foregroundColor(.secondary)
                }
            }
            
            // Quick Actions Section
            Section(header: Text("Quick Actions")) {
                Button(action: {
                    addQuickEntry(250)
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                        Text("Add 250ml")
                        Spacer()
                        Text("Quick Add")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Button(action: {
                    addQuickEntry(500)
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                        Text("Add 500ml")
                        Spacer()
                        Text("Quick Add")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .onChange(of: viewModel.dailyGoal) { newValue in
            viewModel.saveDailyGoal(newValue)
        }
    }
    
    private func addQuickEntry(_ amount: Double) {
        do {
            try CoreDataManager.shared.saveWaterEntry(amount: amount)
            
            if viewModel.isHealthKitAuthorized {
                HealthKitManager.shared.writeWaterEntry(amount: amount) { success, error in
                    if let error = error {
                        print("HealthKit write error: \(error.localizedDescription)")
                    }
                }
            }
        } catch {
            print("Error saving water entry: \(error)")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}
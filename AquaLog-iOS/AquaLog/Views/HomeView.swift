import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showingAddWaterOptions = false
    @State private var showingHealthKitAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                headerSection
                
                // Water Bottle Visualization
                waterBottleSection
                
                // Progress Information
                progressSection
                
                // Action Buttons
                actionButtonsSection
                
                // Quick Stats
                quickStatsSection
            }
            .padding()
        }
        .navigationTitle("AquaLog")
        .navigationBarTitleDisplayMode(.large)
        .alert(isPresented: $showingHealthKitAlert) {
            Alert(
                title: Text("HealthKit Authorization"),
                message: Text("Would you like to sync your water intake with Apple Health?"),
                primaryButton: .default(Text("Authorize")) {
                    viewModel.requestHealthKitAuthorization { success, error in
                        if let error = error {
                            print("HealthKit authorization error: \(error.localizedDescription)")
                        }
                    }
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            if HealthKitManager.shared.isHealthDataAvailable() {
                let status = HealthKitManager.shared.authorizationStatus()
                if status == .notDetermined {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showingHealthKitAlert = true
                    }
                } else {
                    showingHealthKitAlert = false
                }
            } else {
                showingHealthKitAlert = false
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Today's Hydration")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text(Date(), style: .date)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var waterBottleSection: some View {
        VStack(spacing: 20) {
            WaterBottleView(progress: $viewModel.todayProgress, bottleHeight: 250, bottleWidth: 125)
                .frame(height: 250)
            
            Text("\(Int(viewModel.todayProgress * 100))% of daily goal")
                .font(.headline)
                .foregroundColor(.blue)
        }
    }
    
    private var progressSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Progress")
                    .font(.headline)
                Spacer()
            }
            
            ProgressView(value: viewModel.todayProgress)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .scaleEffect(x: 1, y: 2, anchor: .center)
                .frame(height: 8)
            
            HStack {
                Text("\(Int(CoreDataManager.shared.getTotalWaterForDate(Date())))ml")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(Int(viewModel.dailyGoal))ml")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    private var actionButtonsSection: some View {
        HStack(spacing: 20) {
            // Add 250ml Button
            Button(action: {
                viewModel.addWater(amount: 250)
            }) {
                VStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    Text("+ 250ml")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0.5)
                    .onEnded { _ in
                        viewModel.addWater(amount: 500)
                    }
            )
            
            // Add 500ml Button
            Button(action: {
                viewModel.addWater(amount: 500)
            }) {
                VStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.green)
                    Text("+ 500ml")
                        .font(.headline)
                        .foregroundColor(.green)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var quickStatsSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Quick Stats")
                    .font(.headline)
                Spacer()
            }
            
            HStack(spacing: 20) {
                VStack(spacing: 4) {
                    Text("\(viewModel.todayEntries.count)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    Text("Entries Today")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                
                VStack(spacing: 4) {
                    Text("\(Int(viewModel.dailyGoal - CoreDataManager.shared.getTotalWaterForDate(Date())))ml")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                    Text("Remaining")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
    }
}
import SwiftUI

struct ContentView: View {
    @State private var selectedProfile: UserProfile?
    @State private var navigateToDashboard = false
    
    var body: some View {
        NavigationView {
            VStack {
                ProfileSelectionView { profile in
                    selectedProfile = profile
                    navigateToDashboard = true
                }
                NavigationLink(destination: DashboardView(), isActive: $navigateToDashboard) { EmptyView() }
            }
        }
    }
}
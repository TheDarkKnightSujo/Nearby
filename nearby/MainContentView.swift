import SwiftUI

struct MainContentView: View {
    @State private var showSplash = true
    @StateObject private var viewModel = LocationViewModel()
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .transition(.opacity)
                    .zIndex(1)
            } else {
                NavigationStack {
                    HomeView()
                }
                .environmentObject(viewModel)
                .transition(.opacity)
                .zIndex(0)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                    showSplash = false
                }
            }
        }
    }
}

#Preview {
    MainContentView()
}

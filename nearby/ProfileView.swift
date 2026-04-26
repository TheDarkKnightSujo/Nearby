import SwiftUI

struct ProfileView: View {
    @AppStorage("userName") var userName: String = "User"
    
    var body: some View {
        VStack(spacing: 30) {
            // App Name & Logo
            VStack(spacing: 10) {
                Image(systemName: "location.magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                
                Text("NearBy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .padding(.top, 40)
            
            // Name Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Name")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                TextField("Enter your name", text: $userName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Connect to Apple ID Button
            Button(action: {
                // Dummy action for connecting to Apple ID
            }) {
                HStack {
                    Image(systemName: "applelogo")
                    Text("Connect to Apple ID")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}

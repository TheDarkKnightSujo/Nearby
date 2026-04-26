import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: LocationViewModel
    @State private var navigateToResults = false
    @State private var navigateToProfile = false
    @AppStorage("userName") var userName: String = "User"
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "location.magnifyingglass")
                                .foregroundColor(.blue)
                                .font(.title3)
                            Text("NearBy")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        .padding(.bottom, 2)
                        
                        Text("Good Morning, \(userName)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("Explore the city")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    Spacer()
                    Button(action: {
                        navigateToProfile = true
                    }) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search for pizza, gym...", text: $viewModel.searchQuery)
                        .onSubmit {
                            navigateToResults = true
                        }
                    if !viewModel.searchQuery.isEmpty {
                        Button(action: {
                            viewModel.searchQuery = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .padding(.horizontal)
                
                // Categories
                VStack(alignment: .leading) {
                    Text("Categories")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(PlaceCategory.allCases.filter { $0 != .all }) { category in
                            CategoryButton(category: category) {
                                viewModel.selectedCategory = category
                                navigateToResults = true
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Popular Locations
                VStack(alignment: .leading) {
                    HStack {
                        Text("Popular Nearby")
                            .font(.headline)
                        Spacer()
                        Button("See All") {
                            viewModel.selectedCategory = .all
                            navigateToResults = true
                        }
                        .font(.subheadline)
                    }
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.filteredPlaces.prefix(5)) { place in
                                Button(action: {
                                    // Normally you'd navigate to a place detail here, but for demo we just show results
                                    viewModel.searchQuery = place.name
                                    navigateToResults = true
                                }) {
                                    PopularPlaceCard(place: place)
                                        .frame(width: 200)
                                        .multilineTextAlignment(.leading)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
        }
        .navigationDestination(isPresented: $navigateToResults) {
            ResultsView()
        }
        .navigationDestination(isPresented: $navigateToProfile) {
            ProfileView()
        }
        .navigationBarHidden(true)
    }
}

struct CategoryButton: View {
    let category: PlaceCategory
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 60, height: 60)
                    Image(systemName: category.iconName)
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                Text(category.rawValue)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
    }
}

struct PopularPlaceCard: View {
    let place: Place
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(Color.blue.opacity(0.8))
                    .frame(height: 120)
                    .cornerRadius(15)
                    .overlay(
                        Image(systemName: place.category.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                            .opacity(0.8)
                    )
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", place.rating))
                        .font(.caption)
                        .fontWeight(.bold)
                }
                .padding(6)
                .background(Color.white.opacity(0.9))
                .cornerRadius(8)
                .padding(8)
            }
            
            Text(place.name)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            Text(place.address)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(1)
            
            HStack {
                Text(place.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(4)
                
                Spacer()
                
                Text("\(String(format: "%.1f", place.distance)) km")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            .padding(.top, 4)
        }
    }
}

#Preview {
    NavigationStack {
        HomeView().environmentObject(LocationViewModel())
    }
}

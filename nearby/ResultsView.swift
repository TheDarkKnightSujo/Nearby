import SwiftUI
import MapKit

struct ResultsView: View {
    @EnvironmentObject var viewModel: LocationViewModel
    @State private var isMapView = true
    @State private var showFilter = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header / Search Bar
            HStack {
                TextField("Search...", text: $viewModel.searchQuery)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                Button(action: {
                    showFilter = true
                }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            
            // Category Selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(PlaceCategory.allCases) { category in
                        Button(action: {
                            withAnimation {
                                viewModel.selectedCategory = category
                            }
                        }) {
                            Text(category.rawValue)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(viewModel.selectedCategory == category ? Color.blue : Color(.systemGray5))
                                .foregroundColor(viewModel.selectedCategory == category ? .white : .primary)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 10)
            
            // View Toggle
            Picker("View Mode", selection: $isMapView) {
                Text("Map").tag(true)
                Text("List").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            // Content
            if isMapView {
                Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.filteredPlaces) { place in
                    MapAnnotation(coordinate: place.coordinate) {
                        VStack {
                            Image(systemName: place.category.iconName)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                            
                            Text(place.name)
                                .font(.caption)
                                .foregroundColor(.black)
                                .padding(4)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(4)
                        }
                    }
                }
                .ignoresSafeArea(edges: .bottom)
            } else {
                List(viewModel.filteredPlaces) { place in
                    HStack {
                        Image(systemName: place.category.iconName)
                            .frame(width: 40, height: 40)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(place.name)
                                .font(.headline)
                            Text(place.address)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .font(.caption2)
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", place.rating))
                                    .font(.caption)
                            }
                            Text("\(String(format: "%.1f", place.distance)) km")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showFilter) {
            FilterView()
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    NavigationStack {
        ResultsView().environmentObject(LocationViewModel())
    }
}

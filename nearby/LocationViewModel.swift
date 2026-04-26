import Foundation
import Combine
import CoreLocation
import MapKit

class LocationViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var selectedCategory: PlaceCategory = .all
    @Published var filteredPlaces: [Place] = []
    
    // Filter State
    @Published var maxDistance: Double = 10.0 // 10 km
    @Published var minRating: Double = 0.0
    
    // Map State
    @Published var region = MKCoordinateRegion(
        center: MockData.userLocation,
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    private var allPlaces: [Place] = MockData.places
    private var cancellables = Set<AnyCancellable>()
    private let locationManager = CLLocationManager()
    
    init() {
        locationManager.requestWhenInUseAuthorization()
        
        Publishers.CombineLatest4($searchQuery, $selectedCategory, $maxDistance, $minRating)
            .receive(on: RunLoop.main)
            .sink { [weak self] query, category, maxDist, minRat in
                guard let self = self else { return }
                let newFilteredPlaces = self.allPlaces.filter { place in
                    let matchesCategory = category == .all || place.category == category
                    let matchesSearch = query.isEmpty || place.name.lowercased().contains(query.lowercased()) || place.category.rawValue.lowercased().contains(query.lowercased())
                    let matchesDistance = place.distance <= maxDist
                    let matchesRating = place.rating >= minRat
                    
                    return matchesCategory && matchesSearch && matchesDistance && matchesRating
                }
                self.filteredPlaces = newFilteredPlaces
                
                // Recenter map on the first result if available, otherwise default location
                if let firstPlace = newFilteredPlaces.first {
                    self.region = MKCoordinateRegion(
                        center: firstPlace.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )
                } else {
                    self.region = MKCoordinateRegion(
                        center: MockData.userLocation,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )
                }
            }
            .store(in: &cancellables)
    }
    
    func applyFilters() {
        // Filters are now automatically applied reactively via Combine in init().
        // This function is kept to satisfy existing calls (e.g. from FilterView button).
    }
}

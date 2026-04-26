import Foundation
import CoreLocation

enum PlaceCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case restaurant = "Restaurant"
    case cafe = "Cafe"
    case hospital = "Hospital"
    case atm = "ATM"
    case gym = "Gym"
    case park = "Park"
    case medical = "Medical"
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .all: return "square.grid.2x2.fill"
        case .restaurant: return "fork.knife"
        case .cafe: return "cup.and.saucer.fill"
        case .hospital: return "cross.case.fill"
        case .atm: return "dollarsign.circle.fill"
        case .gym: return "dumbbell.fill"
        case .park: return "leaf.fill"
        case .medical: return "heart.text.square.fill"
        }
    }
}

struct Place: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let category: PlaceCategory
    let rating: Double
    let distance: Double // in kilometers
    let address: String
}

// Dummy Data
struct MockData {
    // Let's assume user location is San Francisco (37.7749, -122.4194)
    static let userLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    
    static let places: [Place] = [
        Place(name: "Sightglass Coffee", coordinate: CLLocationCoordinate2D(latitude: 37.7766, longitude: -122.4087), category: .cafe, rating: 4.8, distance: 1.2, address: "270 7th St"),
        Place(name: "UCSF Medical Center", coordinate: CLLocationCoordinate2D(latitude: 37.7631, longitude: -122.4580), category: .hospital, rating: 4.5, distance: 4.5, address: "505 Parnassus Ave"),
        Place(name: "Chase Bank ATM", coordinate: CLLocationCoordinate2D(latitude: 37.7816, longitude: -122.4156), category: .atm, rating: 3.5, distance: 0.8, address: "1330 Market St"),
        Place(name: "Golden Gate Park", coordinate: CLLocationCoordinate2D(latitude: 37.7690, longitude: -122.4862), category: .park, rating: 4.9, distance: 6.0, address: "San Francisco, CA"),
        Place(name: "Equinox Sports Club", coordinate: CLLocationCoordinate2D(latitude: 37.7885, longitude: -122.4034), category: .gym, rating: 4.7, distance: 2.1, address: "747 Market St"),
        Place(name: "Tartine Bakery", coordinate: CLLocationCoordinate2D(latitude: 37.7614, longitude: -122.4241), category: .restaurant, rating: 4.6, distance: 1.6, address: "600 Guerrero St"),
        Place(name: "Zuni Cafe", coordinate: CLLocationCoordinate2D(latitude: 37.7736, longitude: -122.4216), category: .restaurant, rating: 4.5, distance: 0.3, address: "1658 Market St"),
        Place(name: "Blue Bottle Coffee", coordinate: CLLocationCoordinate2D(latitude: 37.7764, longitude: -122.4233), category: .cafe, rating: 4.6, distance: 0.4, address: "1355 Market St"),
        Place(name: "Kaiser Permanente", coordinate: CLLocationCoordinate2D(latitude: 37.7823, longitude: -122.4411), category: .hospital, rating: 4.2, distance: 2.3, address: "2425 Geary Blvd"),
        Place(name: "Bank of America ATM", coordinate: CLLocationCoordinate2D(latitude: 37.7701, longitude: -122.4036), category: .atm, rating: 3.8, distance: 1.5, address: "501 Brannan St"),
        Place(name: "City Clinic", coordinate: CLLocationCoordinate2D(latitude: 37.7772, longitude: -122.4053), category: .medical, rating: 4.0, distance: 1.0, address: "356 7th St")
    ]
}

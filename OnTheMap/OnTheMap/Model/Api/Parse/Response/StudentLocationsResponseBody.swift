import Foundation

// MARK: - StudentLocations
struct StudentLocationsResponseBody: Codable {
    let results: [StudentLocation]?
    
    struct StudentLocation: Codable {
        let firstName : String?
        let lastName : String?
        let longitude : Double?
        let latitude : Double?
        let mapString: String?
        let mediaURL: String?
        let uniqueKey : String?
        let objectId : String?
        let createdAt: String?
        let updatedAt: String?
    }
}

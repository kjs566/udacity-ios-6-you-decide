import Foundation

// MARK: - StudentLocations
struct StudentLocations: Codable {
    let results: [StudentLocation]?
}

// MARK: - StudentLocation
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

import Foundation

struct RouteConfig: Codable {
    struct Route: Codable {
        let stop: [Stop]
        let direction: [Direction]
    }
    let route: Route
}

struct Stop: Codable {
    let tag: String
    let title: String
}

struct Direction: Codable {
    let stop: [StopTag]
    let title : String 
}

struct StopTag: Codable {
    let tag: String
}


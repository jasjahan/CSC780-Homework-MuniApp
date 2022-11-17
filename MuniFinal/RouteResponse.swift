import Foundation

struct RoutesResponse: Codable{
    let copyright: String
    let route:[Route]
}

struct Route: Codable{
    let tag: String
    let title: String
}

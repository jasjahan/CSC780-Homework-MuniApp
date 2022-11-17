import Foundation

struct RoutePrediction: Codable {
    let predictions:Predictions
}

struct Predictions: Codable {
    let routeTag: String
    let stopTag: String
    let direction: Dir
}

struct Dir: Codable {
    let title:String
    let prediction: [Prediction]
}

struct Prediction : Codable{
    let minutes: String
}

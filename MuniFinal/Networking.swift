import Foundation

struct Networking {
    
    let baseURLString = "https://retro.umoiq.com/service/publicJSONFeed?"
    
    
    func fetchRoutes(callback: @escaping ([Route]) -> ()) {
        guard let url = URL(string: "\(baseURLString)command=routeList&a=sf-muni") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { maybeData, maybeResponse, maybeError in
            guard let data: Data = maybeData else {
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(RoutesResponse.self, from: data)
                let routes: [Route] = response.route
                callback(routes)
            } catch {
                
            }
        }
        task.resume()
    }
    
    
    func fetchRouteConfig(routeTag: String) async throws -> RouteConfig {
        let url = URL(string: "\(baseURLString)command=routeConfig&a=sf-muni&r=\(routeTag)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(RouteConfig.self, from: data)
    }
    
    
    func fetchPrediction(routeTag: String,stopTag: String) async throws -> RoutePrediction{
        let url = URL(string: "\(baseURLString)command=predictions&a=sf-muni&r=\(routeTag)&s=\(stopTag)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(RoutePrediction.self, from: data)
    }
    
}



import UIKit

class DirectionCell: UITableViewCell {
    
}

class DirectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var route: Route?
    var stops: [Stop] = []
    var directions: [Direction] = []
    var myDict = [String: Stop]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let networking = Networking()
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DirectionCell.self, forCellReuseIdentifier: "DirectionCell")
        navigationItem.title = route?.title
        
        guard let route = route else {
            return
        }
        
        Task {
            do {
                let routeConfig = try await networking.fetchRouteConfig(routeTag: route.tag)
                for stopage in routeConfig.route.stop {
                    myDict[stopage.tag] = stopage
                }
                await MainActor.run {
                    directions = routeConfig.route.direction
                    tableView.reloadData()
                    
                }
            } catch {
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        directions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DirectionCell") as? DirectionCell else {
            return UITableViewCell()
        }
        let dir = directions[indexPath.row]
        cell.textLabel?.text = dir.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       performSegue(withIdentifier: "ToStationsSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let stationViewController = segue.destination as? StationsViewController else{
            return
        }
        
        guard let indexPath = sender as? IndexPath else{
            return
        }
        
        var stopDict: [Stop] = []
        
        for stop_tag in directions[indexPath.row].stop {
          stopDict.append(myDict[stop_tag.tag]!)
        }
        
        stationViewController.stops = stopDict
        stationViewController.route = route
        }
        

    }


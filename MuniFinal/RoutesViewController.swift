import UIKit

class RouteCell: UITableViewCell{
    
}

class RoutesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var routes: [Route] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    let networking  = Networking()
    
        override func viewDidLoad() {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(RouteCell.self, forCellReuseIdentifier: "RouteCell")
            super.viewDidLoad()
            networking.fetchRoutes{ routes in
                self.update(with: routes)
            }
        }

        func update (with routes: [Route]){
                DispatchQueue.main.async {
                    self.routes = routes
                    self.tableView.reloadData()
                }
        }
        
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell") as? RouteCell else{
                return UITableViewCell()
            }
            let route = routes[indexPath.row]
            cell.textLabel?.text = "\(route.title)"
            return cell
            
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return routes.count
        }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            performSegue(withIdentifier: "ToDirectionsSegue", sender: indexPath)
        }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            guard let directionViewController = segue.destination as? DirectionViewController else{
                return
            }

            guard let indexPath = sender as? IndexPath else{
                return
            }
            let route = routes[indexPath.row]
            directionViewController.route = route
        }

}


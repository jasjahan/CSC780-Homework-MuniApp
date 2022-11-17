import UIKit

class StopCell: UITableViewCell {
    
}

class StationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var route: Route?
    var stops: [Stop] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(StopCell.self, forCellReuseIdentifier: "StopCell")

            Task {
               await MainActor.run {
                 tableView.reloadData()
                 }
               }
            }
    
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                stops.count
            }
        
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StopCell") as? StopCell else {
                return UITableViewCell()
            }
            let stop = stops[indexPath.row]
            cell.textLabel?.text = stop.title
            return cell
        }
        
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "ToPredictionsSegue", sender: indexPath)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            guard let predictionViewController = segue.destination as? PredictionsViewController else{
                return
            }

            guard let indexPath = sender as? IndexPath else{
                return
            }
                let stop = stops[indexPath.row]
                predictionViewController.stop = stop
                predictionViewController.route = route
        }
    

}

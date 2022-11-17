import UIKit

class PredictionCell: UITableViewCell {
    
}

class PredictionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var stop: Stop?
    var route: Route?
    var predictions : [Prediction] = []


    @IBOutlet weak var tableView: UITableView!

    let networking = Networking()

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PredictionCell.self, forCellReuseIdentifier: "PredictionCell")
        navigationItem.title = stop?.title
        guard let route = route else {
            return
        }
        guard let stop = stop else {
            return
        }
        Task {
            do {
                let routePrediction = try await networking.fetchPrediction(routeTag: route.tag, stopTag: stop.tag)
                await MainActor.run {
                    predictions = routePrediction.predictions.direction.prediction
                    tableView.reloadData()
                }
            } catch {
                print(error)
            }
        }
   }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        predictions.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PredictionCell") as? PredictionCell else {
            return UITableViewCell()
        }
        let pred = predictions[indexPath.row]
        cell.textLabel?.text = pred.minutes + "  Minutes"
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

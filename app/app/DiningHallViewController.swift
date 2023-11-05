//
//  DiningHallViewController.swift
//  app
//
//  Created by Dev Langaliya on 11/4/23.
//

import UIKit

class DiningHallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var station_views: UITableView!
    @IBOutlet weak var diningHall_name: UILabel!
    var selectedData: String?
    var stationArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        diningHall_name.text = selectedData
        configureItems()
    }
    
    private func configureItems() {
        station_views.dataSource = self
        station_views.delegate = self
        addStationsToTable()
    }
    
    func addStationsToTable() {
        let stations: [String] = DINING_HALLS[diningHall_name.text!]!
        for station in stations {
            stationArray.append(station)
        }
        station_views.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 // Set the desired height here
    }
    
    func getWaitTime() async throws -> Int {
        let url = URL(string: "http://10.193.89.254:5000/getWaitTime")!
        var request = URLRequest(url: url)
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let waitTime = try JSONDecoder().decode(Int.self, from: data)
            return waitTime
        } catch {
            print("Failed to fetch wait time: \(error)")
            throw error
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let randomInt = Int(arc4random_uniform(30)) + 5
        let cell = tableView.dequeueReusableCell(withIdentifier: "station_view", for: indexPath)
        let rowData = stationArray[indexPath.row]
        cell.textLabel?.text = rowData
        cell.selectionStyle = .none
        if (cell.textLabel?.text != "Sky Garden"){
            cell.detailTextLabel?.text = String(randomInt) + " minutes"
        } else {
            Task {
                do {
                    let waitTime = try await getWaitTime()
                    cell.detailTextLabel?.text = String(waitTime) + " minutes"
                } catch {
                    print("Failed to fetch users wait time: \(error)")
                    cell.detailTextLabel?.text = ""
               }
            }
        }
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18.5)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15.5)
        return cell
    }
    
    let DINING_HALLS: [String : [String]] = ["Field of Greens" : [],
                                             "Lincoln/Allen Dining Hall" : [],
                                             "ISR Dining Center" : ["Cafe a la Crumb","Fusion 48",
                                                                    "Grains & Greens",
                                                                    "Grillworks",
                                                                    "Saporito Pizza"],
                                             "Ikenberry Dining Center" : ["Baked Expectations",
                                                                          "Euclid Street Deli",
                                                                          "Gregory Drive Diner",
                                                                          "IKE InclusiveSolutions",
                                                                          "Penne Lane",
                                                                          "Prarie Fire",
                                                                          "Soytainly"],
                                             "PAR Dining Hall" : ["Sky Garden",                           
                                                                  "Abbondante",
                                                                  "Abbondante Grill",
                                                                  "Arugula's",
                                                                  "La Avenida",
                                                                  "Provolone"]
    ]

}

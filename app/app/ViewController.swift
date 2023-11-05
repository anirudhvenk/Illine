//
//  ViewController.swift
//  app
//
//  Created by Anirudh Venkatraman on 11/3/23.
//

import UIKit
import MultipeerConnectivity
import Foundation

class ViewController: UIViewController, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate,  UITableViewDataSource, UITableViewDelegate{
    
    var peers: [MCPeerID] = []
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcNearbyServiceBrowser: MCNearbyServiceBrowser!
    var mcNearbyServiceAdvertiser: MCNearbyServiceAdvertiser!
    var isHead: Bool = false
    var diningHallArray: [String] = []
    
    @IBOutlet weak var diningHall: UITableViewCell!
    @IBOutlet weak var diningHalls: UITableView!
    @IBOutlet weak var searchDiningHall: UISearchBar!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diningHallArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 // Set the desired height here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = diningHalls.dequeueReusableCell(withIdentifier: "diningHallCell", for: indexPath)
        let rowData = diningHallArray[indexPath.row]
        cell.textLabel?.text = rowData
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18.5)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle row selection here
        let selectedRowData = diningHallArray[indexPath.row]
        performSegue(withIdentifier: "get_info", sender: selectedRowData)
        print("Selected row data: \(selectedRowData)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "get_info" {
            if let destinationVC = segue.destination as? DiningHallViewController {
                if let selectedElement = sender as? UITableViewCell {
                    destinationVC.selectedData = selectedElement.textLabel?.text
                } else if let selectedText = sender as? String {
                    destinationVC.selectedData = selectedText
                }
            }
        }
    }


   func startHosting() {
       mcNearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "foobar")
       mcNearbyServiceAdvertiser.delegate = self
       mcNearbyServiceAdvertiser.startAdvertisingPeer()

       mcNearbyServiceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: "foobar")
       mcNearbyServiceBrowser.delegate = self
       mcNearbyServiceBrowser.startBrowsingForPeers()
   }
    
    private func sendPeersToServer() {
        var displayNames: [String] = []
        for peer in peers {
            displayNames.append(peer.displayName)
        }
        
        let neighbors_dict: [String: [String]] = [self.peerID.displayName: displayNames]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: neighbors_dict)
        
        let url = URL(string: "http://10.193.89.254:5000/add")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
          if let error = error {
              print("Error: \(error)")
          } else if let data = data {
              let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
              if let responseJSON = responseJSON as? [String: Any] {
                  print(responseJSON)
              }
          }
        }

        task.resume()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) { [weak self] in
            self?.sendPeersToServer()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        if let displayName = defaults.string(forKey: "displayName") {
            self.peerID = MCPeerID(displayName: displayName)
        } else {
            let newDisplayName = UUID().uuidString
            self.peerID = MCPeerID(displayName: newDisplayName)
            defaults.set(newDisplayName, forKey: "displayName")
        }
        
        mcNearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "foobar")
        mcNearbyServiceAdvertiser.delegate = self
        mcNearbyServiceAdvertiser.startAdvertisingPeer()
        
        mcNearbyServiceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: "foobar")
        mcNearbyServiceBrowser.delegate = self
        mcNearbyServiceBrowser.startBrowsingForPeers()
        
        sendPeersToServer()
        configureItems()
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
       peers.append(peerID)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
       if let index = peers.firstIndex(of: peerID) {
           peers.remove(at: index)
       }
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
       invitationHandler(true, mcSession)
    }
    
    private func configureItems() {
        diningHalls.dataSource = self
        diningHalls.delegate = self
        addHallsToTable()
    }
    
    func addHallsToTable() {
        for (key, _) in DINING_HALLS {
            diningHallArray.append(key)
        }
        diningHalls.reloadData()
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
                                             "PAR Dining Hall" : ["Abbondante",
                                                                  "Abbondante Grill",
                                                                  "Arugula's",
                                                                  "La Avenida",
                                                                  "Provolone"]
    ]
}



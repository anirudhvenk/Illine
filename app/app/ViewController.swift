//
//  ViewController.swift
//  app
//
//  Created by Anirudh Venkatraman on 11/3/23.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
    var peers: [MCPeerID] = []
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcNearbyServiceBrowser: MCNearbyServiceBrowser!
    var mcNearbyServiceAdvertiser: MCNearbyServiceAdvertiser!
    
    @IBOutlet weak var debug: UIButton!
    @IBOutlet weak var testConnect: UIButton!

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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) { [weak self] in
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
        navigationItem.rightBarButtonItem = UIBarButtonItem (
            barButtonSystemItem: .search,
            target: self,
            action: nil
        )
    }
}

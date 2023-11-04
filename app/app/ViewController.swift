//
//  ViewController.swift
//  app
//
//  Created by Anirudh Venkatraman on 11/3/23.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    @IBOutlet weak var debug: UIButton!
    @IBOutlet weak var testConnect: UIButton!
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
            case .connected: print ("connected \(peerID)")
            case .connecting: print ("connecting \(peerID)")
            case .notConnected: print ("not connected \(peerID)")
            default: print("unknown status for \(peerID)")
        }
    }
    
    @IBAction func testDebug(_ sender: Any) {
        if mcSession.connectedPeers.count > 0 {
            let message = "Hello, world!"
            if let safeData = message.data(using: .utf8) {
                do {
                    try mcSession.send(safeData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch let error as NSError {
                    print("\(error.localizedDescription)")
                }
            }
        }
    }
    
    @IBAction func testConnect(_ sender: Any) {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType:  "foobar", discoveryInfo: nil, session: self.mcSession)
        self.mcAdvertiserAssistant.start()
        ac.addAction(UIAlertAction(title: "Join a session", style: .default) {_ in //here we will add a closure to join a session
            let mcBrowser = MCBrowserViewController(serviceType: "foobar", session: self.mcSession)
            mcBrowser.delegate = self
            self.present(mcBrowser, animated: true, completion: nil)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bar Items"
        view.backgroundColor = .systemBlue
        configureItems()
        peerID = MCPeerID(displayName: UUID().uuidString)
        mcSession = MCSession(peer: peerID, securityIdentity: nil,  encryptionPreference:.required)
        mcSession.delegate = self
    }
    
    private func configureItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem (
            barButtonSystemItem: .search,
            target: self,
            action: nil
        )
    }
}

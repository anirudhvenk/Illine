//
//  ConnectionViewController.swift
//  app
//
//  Created by Dev Langaliya on 11/4/23.
//

import UIKit

class ConnectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeView",
            let connectionViewController = segue.destination as? ConnectionViewController {
                connectionViewController.title = "Connections"
            }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}

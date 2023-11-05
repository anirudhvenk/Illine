//
//  DiningHallViewController.swift
//  app
//
//  Created by Dev Langaliya on 11/4/23.
//

import UIKit

class DiningHallViewController: UIViewController {
    @IBOutlet weak var diningHall_name: UILabel!
    var selectedData: String?

        override func viewDidLoad() {
            super.viewDidLoad()
            diningHall_name.text = selectedData
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

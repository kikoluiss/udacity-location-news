//
//  ViewController.swift
//  LocationNews
//
//  Created by Kiko Santos on 09/01/19.
//  Copyright © 2019 Kiko Santos. All rights reserved.
//

import UIKit

let tabMapNotificationKey = "br.com.fkl.tabMapNotificationKey"
let tabTableNotificationKey = "br.com.fkl.tabTableNotificationKey"

class MainViewController: UITabBarController {

    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddLocationSegue" {
            let navController = segue.destination as! UINavigationController
            let vc = navController.topViewController as! AddLocationViewController
            vc.dataController = dataController
        }
    }
    
    @IBAction func editAction(_ sender: Any) {
        editButton.title = editButton.title == "Edit" ? "Done" : "Edit"
        NotificationCenter.default.post(name: Notification.Name(rawValue: tabMapNotificationKey), object: self)
        NotificationCenter.default.post(name: Notification.Name(rawValue: tabTableNotificationKey), object: self)
    }
}


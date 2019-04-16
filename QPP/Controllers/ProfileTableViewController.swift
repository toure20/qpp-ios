//
//  ProfileTableViewController.swift
//  QPP
//
//  Created by Абай Жунус on 4/11/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.setupGradientBackground(
            [UIColor.init(hex: "4754A5"), UIColor.init(hex: "2C367A")]
        )
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        switch indexPath.row {
        case 1:
            self.performSegue(withIdentifier: "MyOrdersVC", sender: nil)
        default:
            break
        }
    }

}

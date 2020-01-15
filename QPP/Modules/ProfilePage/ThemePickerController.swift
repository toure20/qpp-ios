//
//  ThemePickerController.swift
//  QPP
//
//  Created by Toremurat on 10/11/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit

class ThemePickerController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Выберите тему"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            UserDefaults.standard.set("Theme1", forKey: "AppTheme")
        case 1:
            UserDefaults.standard.set("Theme2", forKey: "AppTheme")
        case 2:
            UserDefaults.standard.set("Theme3", forKey: "AppTheme")
        case 3:
            UserDefaults.standard.set("Theme4", forKey: "AppTheme")
        default:
            break
        }
        
        if let theme = UserDefaults.standard.value(forKey: "AppTheme") as? String {
            switch theme {
            case "Theme1":
                UITabBar.appearance().tintColor = UIColor(hex: "D75E4D")
            case "Theme2":
                UITabBar.appearance().tintColor =  UIColor(hex: "212226")
            case "Theme3":
                UITabBar.appearance().tintColor = UIColor(hex: "34343D")
            case "Theme4":
                UITabBar.appearance().tintColor = UIColor(named: "tabBarTint")
            default:
                UITabBar.appearance().tintColor = UIColor(named: "tabBarTint")
            }
        } else {
            UITabBar.appearance().tintColor = UIColor(named: "tabBarTint")
        }
        self.navigationController?.popViewController(animated: true)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

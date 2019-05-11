//
//  ProfileTableViewController.swift
//  QPP
//
//  Created by Абай Жунус on 4/11/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    private var isLogged: Bool = false
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var authCellLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if !isLogged {
            let vc = LoginController.instantiate()
            self.present(vc, animated: true, completion: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let cachedObject: User = cache.object(forKey: "CachedProfileObject") {
            authCellLabel.text = "Выйти из аккаунта"
            isLogged = true
            fillUserViews(user: cachedObject)
        } else {
            // Reset state
            isLogged = false
            authCellLabel.text = "Войти/Регистрация"
        }
    }
    
    private func fillUserViews(user: User) {
        userNameLabel.text = !user.name.isEmpty ? user.name : "Профиль"
        phoneNumberLabel.text = user.phone
        addressLabel.text = user.address
        cityLabel.text = user.city
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        switch indexPath.row {
        case 1:
            self.performSegue(withIdentifier: "MyOrdersVC", sender: nil)
        case 4:
            if isLogged {
                // Logout case
            } else {
                let vc = LoginController.instantiate()
                self.present(vc, animated: true, completion: nil)
            }
        default:
            break
        }
    }

}

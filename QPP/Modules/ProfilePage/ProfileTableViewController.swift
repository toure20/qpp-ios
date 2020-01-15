//
//  ProfileTableViewController.swift
//  QPP
//
//  Created by Абай Жунус on 4/11/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit
import SVProgressHUD

class ProfileTableViewController: UITableViewController {
    
    private var isLogged: Bool = false
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var authCellLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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
            [addressLabel, phoneNumberLabel, cityLabel].forEach { (label) in
                label?.text = nil
            }
        }
    }
    
    // MARK: - Setup views
    private func setupViews() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = UIColor(named: "navBarColor")
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Edit profile action
    @IBAction func editBarButtonPressed(_ sender: Any) {
        if let user = cache.object(forKey: "CachedProfileObject") {
            let vc = UIStoryboard.init(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "EditProfileTableViewController") as! EditProfileTableViewController
            vc.userInfo = user
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            SVProgressHUD.showError(withStatus: "Вы не авторизованы!")
        }
        
    }
    
    private func fillUserViews(user: User) {
        userNameLabel.text = !user.name.isEmpty ? user.name : "Профиль"
        phoneNumberLabel.text = user.phone
        addressLabel.text = user.address
        cityLabel.text = user.city
    }
    
    private func open(scheme: String) {
        if let url = URL(string: scheme) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        switch indexPath.row {
        case 1:
            if let cachedObject: User = cache.object(forKey: "CachedProfileObject") {
                let vc = MyOrdersViewController.instantiate()
                vc.orders = cachedObject.userOrders
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                SVProgressHUD.showError(withStatus: "Авторизируйтесь, чтобы посмотреть список заказов")
            }
        case 2:
            let phoneScheme = "tel://\(+77087042247)"
            open(scheme: phoneScheme)
        case 3:
            if isLogged {
                // Logout case
                UserDefaults.standard.removeObject(forKey: "USER_TOKEN")
                cache.removeObject(forKey: "CachedProfileObject")
                self.viewWillAppear(true)
            } else {
                let vc = LoginController.instantiate()
                self.present(vc, animated: true, completion: nil)
            }
        default:
            break
        }
    }

}

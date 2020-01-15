//
//  EditProfileTableViewController.swift
//  QPP
//
//  Created by Toremurat on 5/15/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit
import SVProgressHUD

class EditProfileTableViewController: UITableViewController {

    var userInfo: User?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.text = userInfo?.name
        cityField.text = userInfo?.city
        addressField.text = userInfo?.address
        phoneField.text = userInfo?.phone
        
        let saveBarItem = UIBarButtonItem(
            title: "Сохранить",
            style: .plain,
            target: self,
            action: #selector(saveButtonPressed)
        )
        self.navigationItem.rightBarButtonItem = saveBarItem
        hideKeyboardWhenTappedAround()
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
    }

    @objc private func saveButtonPressed() {
        guard let name = nameField.text, !name.isEmpty,
            let phone = phoneField.text, !phone.isEmpty,
            let address = addressField.text, !address.isEmpty,
            let city = cityField.text, !city.isEmpty else {
                SVProgressHUD.showError(withStatus: "Заполните все данные")
                return
        }
        SVProgressHUD.show()
        let params = ["token": userInfo!.token,
                      "name": name,
                      "city": city,
                      "address": address,
                      "phone": phone
        ]
        APIManager.makeRequest(target: .editProfile(params: params), success: { [weak self] _ in
            SVProgressHUD.dismiss()
            SVProgressHUD.showSuccess(withStatus: "Успешно обновлено!")
            self?.updateCachedInfo(params: params)
        }) { _ in
             SVProgressHUD.showSuccess(withStatus: "Ошибка сервера... Что-то пошло не так")
        }
    }
    
    private func updateCachedInfo(params: [String: String]) {
        if let cachedObject: User = cache.object(forKey: "CachedProfileObject") {
            cachedObject.name = params["name"] ?? ""
            cachedObject.city = params["city"] ?? ""
            cachedObject.address = params["address"] ?? ""
            cachedObject.phone = params["phone"] ?? ""
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }


}

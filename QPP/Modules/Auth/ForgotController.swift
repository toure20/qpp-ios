//
//  ForgotController.swift
//  QPP
//
//  Created by Toremurat on 4/29/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Moya

class ForgotController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var restoreButton: UIButton!
    
    static func instantiate() -> ForgotController {
        return UIStoryboard(name: "Auth", bundle:nil).instantiateViewController(withIdentifier: "ForgotController") as! ForgotController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Восстановление пароля"
        restoreButton.layer.cornerRadius = 5.0
        configureEvents()
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARL: Actions
    @IBAction func restoreButtonPressed(_ sender: UIButton) {
        guard let email = emailField.text, !email.isEmpty else {
            SVProgressHUD.showError(withStatus: "Заполните все поля!")
            return
        }
//        APIManager.makeRequest(target: .resetPassword(["email" : email]), success: { (json) in
//            SVProgressHUD.showError(withStatus: json["message"].stringValue)
//        }) { (json) in
//            SVProgressHUD.showError(withStatus: json["errors"][0].string ?? json["error"].stringValue)
//        }
    }
    func configureEvents() {
        // Keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(sender: Notification) {
        self.view.frame.origin.y = -50
    }
    
    @objc func keyboardWillHide(sender: Notification) {
        self.view.frame.origin.y = 0
    }
    
}

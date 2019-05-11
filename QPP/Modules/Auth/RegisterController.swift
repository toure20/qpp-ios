//
//  RegisterController.swift
//  QPP
//
//  Created by Toremurat on 4/29/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit
import SVProgressHUD

class RegisterController: UIViewController {
    
    // TextFields
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    static func instantiate() -> RegisterController {
        return UIStoryboard(name: "Auth", bundle:nil).instantiateViewController(withIdentifier: "RegisterController") as! RegisterController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Регистрация"
        configureUI()
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: Actions
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        guard let email = emailField.text, !email.isEmpty, email.contains("@"), let name = nameField.text, !name.isEmpty, let pass = passwordField.text, !pass.isEmpty else {
            SVProgressHUD.showError(withStatus: "Заполните все поля!")
            return
        }
        /// Request for registering user
        SVProgressHUD.show()
        let signUpTarget = APITarget.signUp(name: name, email: email, password: pass)
        APIManager.makeRequest(target: signUpTarget, success: { [weak self] (json) in
            guard let self = self else { return }
            let user = User(json: json["data"]["user"])
            cache.setObject(user, forKey: "CachedProfileObject")
            SVProgressHUD.dismiss()
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }) { (json) in
            SVProgressHUD.showError(withStatus:
                json["error"].string ??
                json["errors"]["email"][0].string ??
                json["errors"]["password"][0].stringValue
            )
        }
    }
    
    // MARK: Config UI
    func configureUI() {
        setEmptyBackTitle()
        registerButton.layer.cornerRadius = 5.0
    }
    
    
}

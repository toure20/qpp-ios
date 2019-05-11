//
//  LoginController.swift
//  QPP
//
//  Created by Toremurat on 4/29/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginController: UIViewController {
    
    // TextFields
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // Buttons
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    static func instantiate() -> LoginController {
        return UIStoryboard(name: "Auth", bundle:nil).instantiateViewController(withIdentifier: "LoginController") as! LoginController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureEvents()
        hideKeyboardWhenTappedAround()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Actions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailField.text, !email.isEmpty, let pass = passwordField.text, !pass.isEmpty else {
            SVProgressHUD.showError(withStatus: "Заполните все поля!")
            return
        }
        SVProgressHUD.show()
        APIManager.makeRequest(target: .signIn(email: email, password: pass), success: { (json) in
            SVProgressHUD.dismiss()
            let user = User(json: json["data"]["user"])
            self.cacheUser(user)
            self.dismiss(animated: true, completion: nil)
        }) { (json) in
            if let baseError = json["error"].string {
                SVProgressHUD.showError(withStatus: baseError)
            }
            if let emailError = json["errors"]["email"][0].string {
                SVProgressHUD.showError(withStatus: emailError)
            }
        }
    }
    
    private func cacheUser(_ object: User) {
        cache.setObject(object, forKey: "CachedProfileObject")
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        let vc = RegisterController.instantiate()
        self.show(vc, sender: nil)
    }
    
    @IBAction func agreementPressed(_ sender: UITapGestureRecognizer) {
        
    }
    
    @IBAction func forgotButtonPressed(_ sender: UIButton) {
        let vc = ForgotController.instantiate()
        self.show(vc, sender: nil)
    }
    
    // MARK: Base funtions
    func configureUI() {
        // Transparent Navigation bar
        navBarTransparent()
        
        // Corder radius for buttons
        loginButton.layer.cornerRadius = 5
        registerButton.layer.cornerRadius = 5
    }
    
    func configureEvents() {
        // Keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(sender: Notification) {
        self.view.frame.origin.y = -60
    }
    
    @objc func keyboardWillHide(sender: Notification) {
        self.view.frame.origin.y = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

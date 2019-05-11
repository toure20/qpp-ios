//
//  OrderViewController.swift
//  QPP
//
//  Created by Абай Жунус on 4/23/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit
import SVProgressHUD

class OrderViewController: UIViewController {

    // A little hack
    var cartRepository: CartRepositoryProtocol = serloc.getService(CartRepositoryProtocol.self)
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Заполните данные"
        self.hideKeyboardWhenTappedAround()
        setEmptyBackTitle()
        configureViews()
        
        if let cachedObject: User = cache.object(forKey: "CachedProfileObject") {
            let username = !cachedObject.name.isEmpty ?
                cachedObject.name : nil
            let address = !cachedObject.address.isEmpty ?
                cachedObject.address : nil
            let phone = !cachedObject.phone.isEmpty ?
                cachedObject.phone : nil
            
            nameTextField.text = username
            addressTextField.text = address
            phoneTextField.text = phone
            
            cartRepository.setUserName(username)
            cartRepository.setShippingAddress(address)
            cartRepository.setPhoneNumber(phone)
        } else {
            let vc = LoginController.instantiate()
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    deinit {
        cartRepository.setUserName(nil)
        cartRepository.setShippingAddress(nil)
        cartRepository.setPhoneNumber(nil)
    }
    
    private func configureViews() {
        [nameTextField, addressTextField, phoneTextField].forEach { textField in
            textField?.setBottomBorder()
            textField?.addTarget(
                self, action:
                #selector(textFieldEditing(_:)),
                for: .allEditingEvents
            )
        }
    }
    
    @objc private func textFieldEditing(_ sender: UITextField) {
        switch sender {
        case nameTextField:
            cartRepository.setUserName(sender.text)
        case addressTextField:
            cartRepository.setShippingAddress(sender.text)
        case phoneTextField:
            cartRepository.setPhoneNumber(sender.text)
        default: break
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if cartRepository.isValid {
            let vc = PaymentOptionsController.instantiate()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            SVProgressHUD.showError(withStatus: "Заполните данные")
        }
    }
    
}

//
//  PaymentOptionsController.swift
//  QPP
//
//  Created by Toremurat on 4/29/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit
import SVProgressHUD

class PaymentOptionsController: UITableViewController, CartRepositoryOutput {
    
    var cartRepository: CartRepositoryProtocol = serloc.getService(CartRepositoryProtocol.self)
    
    var userData: [String] = []
    var totalPrice: Int = 0
    var promocodes: String = ""
    var isPickup: Bool = true {
        didSet {
            deliveryButton.isHidden = !isPickup //isDelivery = 1 true
            pickupButton.isHidden = isPickup //isPickup = 0 false
        }
    }
    var isPay: Bool = true { //
        didSet {
            cashPayment.isHidden = isPay // isPay = 0 for cash payments
            onlinePayment.isHidden = !isPay //isPay = 1 for online payments
        }
    }
    
    // Outlets
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var paymentButton: UIButton!
    
    @IBOutlet weak var deliveryButton: UIButton!
    @IBOutlet weak var pickupButton: UIButton!
    @IBOutlet weak var cashPayment: UIButton!
    @IBOutlet weak var onlinePayment: UIButton!
    
    static func instantiate() -> PaymentOptionsController {
        return UIStoryboard(name: "Main", bundle:nil)
            .instantiateViewController(withIdentifier: "PaymentOptionsController") as! PaymentOptionsController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setEmptyBackTitle()
        self.title = "Оплата"
        configureUI()
        cartRepository.output = self
    }
    
    func configureUI() {
        
        self.tableView.tableFooterView = UIView()
        pickupButton.isHidden = isPickup
        cashPayment.isHidden = isPay
        paymentButton.layer.cornerRadius = 5.0
        
        totalLabel.text = "Итого: \(totalPrice) ₸"
    }
    
    @IBAction func paymentButtonPressed(_ sender: UIButton) {
        if let cachedObject: User = cache.object(forKey: "CachedProfileObject") {
            cartRepository.makeOrder(
                user: cachedObject,
                shipping_method: .withDelivery,
                payment_method: .online
            )
        } else {
            let vc = LoginController.instantiate()
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func orderDidCreate() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
// MARK: - TableView delegate/data source

extension PaymentOptionsController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return 2
        case 2: return 2
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 { // with delivery
                isPickup = true
            } else if indexPath.row == 1 { // without
                isPickup = false
            }
        case 1:
            if indexPath.row == 0 { // cash
                isPay = false
            } else if indexPath.row == 1 { // online
                isPay = true
            }
        default:
            break
        }
    }
}


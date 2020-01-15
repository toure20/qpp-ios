//
//  WebPaymentController.swift
//  QPP
//
//  Created by Toremurat on 5/15/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit
import WebKit

class WebPaymentController: UIViewController, WKUIDelegate {
    
    var orderId: Int = 0
    
    private var cartRepo = serloc.getService(CartRepositoryProtocol.self)
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        self.title = "Онлайн оплата"
        if let url = URL(string: "https://quickphoto.org/payment-init/\(orderId)") {
            let request = URLRequest(url: url)
            webView.uiDelegate = self
            webView.load(request)
        }
    }
    
    // - TODO: Did load payment delegate
    
    /// Make order requeist
    func createOrder() {
        guard let cachedObject: User = cache
            .object(forKey: "CachedProfileObject") else { return }
        cartRepo.makeOrder(
           user: cachedObject,
           shipping_method: .withDelivery,
           payment_method: .online
        )
    }
}


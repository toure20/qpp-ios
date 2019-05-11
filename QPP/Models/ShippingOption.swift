//
//  ShippingOption.swift
//  QPP
//
//  Created by Toremurat on 5/11/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import Foundation

enum ShippingOption: String {
    /// with devivery service option
    case withDelivery = "home"
    /// getting order by himself option (may be from tastamat, kazpost etc. shipment services)
    case byHimself = "shop"
}

enum PaymentOption: String {
    case offline
    case online
}

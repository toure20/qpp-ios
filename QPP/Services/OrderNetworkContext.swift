//
//  OrderNetworkContext.swift
//  QPP
//
//  Created by Toremurat on 5/11/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import Foundation

struct Photo {
    var imageData: Data
}

public struct OrderNetworkContext {
    var email: String
    var name: String
    var phone: String
    var city: String
    var address: String
    var shipping_method: ShippingOption
    var payment_method: PaymentOption
    var price: String
    var photos: [Int: PhotoCart]
    
    func getPhotosData() -> [(index: Int, data: Data)] {
        return photos.compactMap({ (key, value) -> (index: Int, data: Data)? in
            if let imgData = value.image?.jpegData(compressionQuality: 0.5) {
                return (index: key, data: imgData)
            }
            return nil
        })
    }
    
    func getParameters() -> [String: String] {
        var params: [String: String] = [
            "email": email,
            "name": name,
            "phone": phone,
            "city": city,
            "address": address,
            "shipping_method": shipping_method.rawValue,
            "payment_method": payment_method.rawValue,
            "price": price
        ]
        for (index, item) in photos {
            params["photos[\(index)][size_id]"] = "\(index)" // item.size.id
            params["photos[\(index)][count]"] = "\(item.quantity)"
        }
        return params
    }
}

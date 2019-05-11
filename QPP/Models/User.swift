//
//  User.swift
//  QPP
//
//  Created by Toremurat on 5/11/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import Foundation
import SwiftyJSON

class User: NSObject, NSCoding {
    var id: Int
    var email: String
    var token: String
    var name: String
    var phone: String
    var city: String
    var address: String
    var created_at: String
    var userOrders: [UserOrder]
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.email = json["email"].stringValue
        self.token = json["token"].stringValue
        self.name = json["name"].stringValue
        self.phone = json["phone"].stringValue
        self.city = json["city"].stringValue
        self.address = json["address"].stringValue
        self.created_at = json["created_at"].stringValue
        
        var orders: [UserOrder] = []
        json["orders"].forEach { (_, subJson) in
           orders.append(UserOrder(json: subJson))
        }
        self.userOrders = orders
    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! Int
        self.email = aDecoder.decodeObject(forKey: "email") as! String
        self.token = aDecoder.decodeObject(forKey: "token") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.phone = aDecoder.decodeObject(forKey: "phone") as! String
        self.address = aDecoder.decodeObject(forKey: "address") as! String
        self.city = aDecoder.decodeObject(forKey: "city") as! String
        self.created_at = aDecoder.decodeObject(forKey: "created_at") as! String
        self.userOrders = []
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(created_at, forKey: "created_at")
        
    }
}


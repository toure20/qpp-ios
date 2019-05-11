//
//  UserOrder.swift
//  QPP
//
//  Created by Toremurat on 5/11/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import Foundation
import SwiftyJSON


struct UserOrder {
    var id: Int
    var status: String
    var date: String
    var photos: [OrderPhotos] = []
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.status = json["status"].stringValue
        self.date = json["date"].stringValue
        json["photos"].forEach { (_, subJson) in
            self.photos.append(OrderPhotos(json: subJson))
        }
        
    }
}

struct OrderPhotos {
    var count: Int
    var items: [String] = []
    
    init(json: JSON) {
        self.count = json["count"].intValue
        json["items"].forEach { (_, subJson) in
            self.items.append(subJson.stringValue)
        }
    }
}

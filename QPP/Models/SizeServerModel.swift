//
//  SizeServerModel.swift
//  QPP
//
//  Created by Toremurat on 5/15/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import Foundation
import SwiftyJSON

class SizeAmountContainer: NSObject, NSCoding {
    
    static let shared: SizeAmountContainer = SizeAmountContainer()
    
    var sizes: [SizeServerModel]
    var prices: [PriceServerModel]
    
    init(sizes: [SizeServerModel] = [], prices: [PriceServerModel] = []) {
        self.sizes = sizes
        self.prices = prices
    }
    
    func set(sizes: [SizeServerModel]) {
        self.sizes = sizes
    }
    
    func set(prices: [PriceServerModel]) {
        self.prices = prices
    }
    
    func getPrices() -> [PriceServerModel] {
        return prices
    }
    
    required init(coder aDecoder: NSCoder) {
        self.sizes = aDecoder.decodeObject(forKey: "sizes") as! [SizeServerModel]
        self.prices = aDecoder.decodeObject(forKey: "prices") as! [PriceServerModel]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(sizes, forKey: "sizes")
        aCoder.encode(prices, forKey: "prices")
    }
}

class SizeServerModel: NSObject, NSCoding {
    var id: Int
    var name: String
    var photoUrl: String
    var desc: String
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.photoUrl = json["photo_url"].stringValue
        self.desc = json["description"].stringValue
    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! Int
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.photoUrl = aDecoder.decodeObject(forKey: "photo_url") as! String
        self.desc = aDecoder.decodeObject(forKey: "description") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(photoUrl, forKey: "photo_url")
        aCoder.encode(desc, forKey: "description")
    }
}

class PriceServerModel: NSObject, NSCoding {
    var id: Int
    var sizeId: Int
    var amount: Double
    var currency: String
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.sizeId = json["size_id"].intValue
        self.amount = json["amount"].doubleValue
        self.currency = json["currency"].stringValue
    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! Int
        self.sizeId = aDecoder.decodeObject(forKey: "size_id") as! Int
        self.amount = aDecoder.decodeObject(forKey: "amount") as! Double
        self.currency = aDecoder.decodeObject(forKey: "currency") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(sizeId, forKey: "size_id")
        aCoder.encode(amount, forKey: "amount")
        aCoder.encode(currency, forKey: "currency")
        
    }
}

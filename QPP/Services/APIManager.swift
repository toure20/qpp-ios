//
//  APIManager.swift
//  QPP
//
//  Created by Toremurat on 4/29/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import Foundation
import UIKit
import Moya
import Alamofire
import SVProgressHUD
import SwiftyJSON

typealias Success = (JSON) -> Void
typealias FailureNetwork = (JSON) -> Void

struct APIManager {
    
    //Сalling all requests through this provider class:
    static let provider = MoyaProvider<APITarget>()
    
    static func makeRequest(target: APITarget, success: @escaping Success, failure: @escaping FailureNetwork) {
        SVProgressHUD.show()
        provider.request(target) { (result) in
            switch result {
            case .success(let response):
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    let json = try! JSON(data: response.data)
                    //print(json)
                    SVProgressHUD.dismiss()
                    if json["success"].bool == true || !(json["data"].array?.isEmpty ?? true) {
                        success(json)
                    } else {
                        failure(json)
                    }
                } else {
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: "Server error - \(response.statusCode)")
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: error.errorDescription!)
            }
        }
    }
    
}

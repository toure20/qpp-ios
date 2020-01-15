//
//  APITarget.swift
//  QPP
//
//  Created by Toremurat on 4/29/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import Alamofire

//typealias Success = (_ data: Any?) -> Void
//typealias Failure = (_ responseError: APIResponseError) -> Void

let tmProvider = MoyaProvider<APITarget>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

public enum APITarget {
    
    // Account
    case createOrder(context: OrderNetworkContext)
    case signUp(name: String, email: String, password: String)
    case signIn(email: String, password: String)
    case resetPassword(email: String)
    case profileInfo(token: String)
    case editProfile(params: [String: Any])
    case getSizes
    case getPriceList
}

extension APITarget: TargetType {
    
    public var headers: [String : String]? {
        return nil
    }
    
    public var baseURL: URL { return URL(string: "https://quickphoto.org/api/")! }
    
    public var path: String {
        switch self {
        // Account
        case .signUp:
            return "register"
        case .signIn:
            return "login"
        case .resetPassword:
            return "resetPassword"
        case .createOrder:
            return "add-order"
        case .getSizes:
            return "data/sizes"
        case .getPriceList:
            return "data/amounts"
        case .profileInfo, .editProfile:
            return "data/profile"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .signUp, .signIn, .resetPassword, .createOrder, .profileInfo, .editProfile:
            return .post
        default:
            return .get
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
        case  .getSizes, .getPriceList:
            return CompositeEncoding()
        default:
            return CompositeJsonEncoding()
        }
    }
    
    public var sampleData: Data {
        return "Default sample data".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
        case .createOrder(let context):
            var multipartData = context.getPhotosData().compactMap {
                MultipartFormData(provider: .data($0.data), name: "photos[\($0.index)][file]", fileName: "photo.jpg", mimeType: "image/jpeg")
            }
            let multipartParams = context.getParameters().compactMap {
                MultipartFormData(provider: .data($0.value.data(using: .utf8)!), name: $0.key)
            }
            multipartData.append(contentsOf: multipartParams)
            return .uploadMultipart(multipartData)
        case .signIn(let email, let password):
            return .requestCompositeParameters(
                bodyParameters: ["email": email, "password": password],
                bodyEncoding: URLEncoding.httpBody, urlParameters: [:]
            )
        case .signUp(let name, let email, let password):
             return .requestCompositeParameters(
                bodyParameters: ["name": name, "email": email, "password": password],
                bodyEncoding: URLEncoding.httpBody, urlParameters: [:]
            )
        case .profileInfo(let token):
            return .requestCompositeParameters(
                bodyParameters: ["token": token],
                bodyEncoding: URLEncoding.httpBody, urlParameters: [:]
            )
        case .editProfile(let params):
            return .requestCompositeParameters(
                bodyParameters: params,
                bodyEncoding: URLEncoding.httpBody, urlParameters: [:]
            )
        default:
            return .requestPlain
        }
    }
    
    public var validate: Bool {
        return true
    }
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}



extension Moya.Response {
    func mapNSArray() throws -> NSArray {
        let any = try self.mapJSON()
        guard let array = any as? NSArray else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}

struct CompositeEncoding: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        guard let parameters = parameters else {
            return try urlRequest.asURLRequest()
        }
        
        let queryParameters = (parameters["query"] as! Parameters)
        var queryRequest = try URLEncoding(destination: .queryString).encode(urlRequest, with: queryParameters)
        
        if let body = parameters["body"] {
            let bodyParameters = (body as! Parameters)
            
            let req = try URLEncoding(destination: .queryString).encode(urlRequest, with: bodyParameters)
            if let url = req.url, let query = url.query {
                queryRequest.httpBody = query.data(using: .utf8)
            }
            return queryRequest
        } else {
            return queryRequest
        }
        
    }
}

struct CompositeJsonEncoding: ParameterEncoding {
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        guard let parameters = parameters else {
            return try urlRequest.asURLRequest()
        }
        
        let queryParameters = (parameters["query"] as! Parameters)
        var queryRequest = try URLEncoding(destination: .queryString).encode(urlRequest, with: queryParameters)
        
        if let body = parameters["body"] {
            let bodyParameters = (body as! Parameters)
            do {
                let data = try JSONSerialization.data(withJSONObject: bodyParameters, options: [])
                
                if queryRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                    queryRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }
                
                queryRequest.httpBody = data
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
            
        }
        
        return queryRequest
    }
}

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

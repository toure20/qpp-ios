//
//  ServiceLocator.swift
//  QPP
//
//  Created by Toremurat on 4/29/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import Foundation
import UIKit

protocol ServiceLocator {
    func getService<T>(_: T.Type) -> T
    func getService<T>() -> T
}

extension ServiceLocator {
    
    func getService<T>() -> T {
        return getService(T.self)
    }
}

final class LazyServiceLocator: ServiceLocator {
    
    enum RegistryRecord {
        case instance(Any)
        case recipe(() -> Any)
    }
    
    fileprivate lazy var registry: [String: RegistryRecord] = [:]
    
    func addService<T>(_ recipe: @escaping () -> T) {
        let key = typeName(T.self)
        registry[key] = .recipe(recipe)
    }
    
    func addService<T>(_ instance: T) {
        let key = typeName(T.self)
        registry[key] = .instance(instance)
    }
    
    func getService<T>(_: T.Type) -> T {
        let instanceToFind: T?
        if let registryRec = registry[typeName(T.self)] {
            switch registryRec {
            case .instance(let _instance):
                instanceToFind = _instance as? T
            case .recipe(let recipe):
                instanceToFind = recipe() as? T
                if let instance = instanceToFind {
                    addService(instance)
                }
            }
        } else {
            instanceToFind = nil
        }
        
        return instanceToFind!
    }
    
}

func typeName(_ some: Any) -> String {
    return (some is Any.Type) ? "\(some)" : "\(type(of: some))"
}

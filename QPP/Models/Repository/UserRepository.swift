//
//  UserRepository.swift
//  QPP
//
//  Created by Toremurat on 5/11/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import Foundation

protocol UserRepositoryProtocol {
    func set(user: User)
    func getUser() -> User?
}

class UserRepository: UserRepositoryProtocol {
    
    private var user: User?
    
    func set(user: User) {
        self.user = user
    }
    
    func getUser() -> User? {
        return self.user
    }
}

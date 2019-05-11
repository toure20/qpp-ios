//
//  Collection+Extension.swift
//  QPP
//
//  Created by Toremurat on 4/29/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

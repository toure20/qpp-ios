//
//  FrameViewManager.swift
//  QPP
//
//  Created by Toremurat on 9/4/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit

enum FrameType: String {
    case black = "Black"
    case white = "White"
    
    var bgColor: UIColor {
        switch self {
        case .black: return UIColor.black
        case .white: return UIColor.white
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .black: return UIColor.white
        case .white: return UIColor.black
        }
    }
}

protocol FrameViewManagerOutput: BaseViewManagerOutput {
    func changeCurrentFrame(with type: FrameType)
}

class FrameViewManager: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    weak var output: FrameViewManagerOutput?
    var frames: [FrameType] = [.white, .black]
    var selectedIndex: Int = 0
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return frames.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FrameCell", for: indexPath) as! FrameCell
        cell.titleLabel.text = frames[indexPath.row].rawValue
        cell.titleLabel.textColor = frames[indexPath.row].titleColor
        cell.isSelected = selectedIndex == indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        output?.changeCurrentFrame(with: frames[indexPath.row])
    }
}

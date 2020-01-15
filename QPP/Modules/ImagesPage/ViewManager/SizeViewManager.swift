//
//  SizeViewManager.swift
//  QPP
//
//  Created by Toremurat on 9/4/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit

protocol SizeViewManagerOutput: BaseViewManagerOutput {
    func changeCurrentSize(_ type: PhotoSize)
}

class SizeViewManager: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    weak var output: SizeViewManagerOutput?
    
    var sizes: [PhotoSize] = []
    var selectedIndex: Int = 0
    var currentSize: PhotoSize?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sizes.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeCell", for: indexPath) as! SizeCell
       // cell.isCurrent = currentFilterType == filters[indexPath.item]
        cell.sizeLabel.text = sizes[indexPath.item].rawValue
        cell.titleLabel.text = sizes[indexPath.item].title
        cell.isSelected = selectedIndex == indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        output?.didSelectCurrentCell(at: indexPath, manager: self)
        output?.changeCurrentSize(sizes[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: collectionView.frame.height)
    }
}

//
//  FilterViewManager.swift
//  QPP
//
//  Created by Toremurat on 8/23/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit

protocol BaseViewManagerOutput: class {
    func didSelectCurrentCell(at indexPath: IndexPath, manager: NSObject)
}

protocol FilterViewManagerOutput: BaseViewManagerOutput {
    func changeCurrentFilter(_ type: ImageFilterType)
}

class FilterViewManager: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    weak var output: FilterViewManagerOutput?
    
    var filters: [ImageFilterType] = ImageFilterType.filters
    var currentFilterType: ImageFilterType = .original
    
    private var imageManager: ImageManagerProtocol
    
    init(imageManager: ImageManagerProtocol) {
        self.imageManager = imageManager
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
        cell.imageManager = imageManager
        cell.isCurrent = currentFilterType == filters[indexPath.item]
        cell.setupFilterType(filters[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if filters[indexPath.item] == currentFilterType {
            return
        }
        
        let path = IndexPath(item: filters.index(of: currentFilterType)!, section: 0)
        if let lastCell = collectionView.cellForItem(at: path) as? FilterCell {
            lastCell.isCurrent = false
        }
        currentFilterType = filters[indexPath.item]
        if let cell = collectionView.cellForItem(at: indexPath) as? FilterCell {
            cell.isCurrent = true
            //output?.didSelectCurrentCell(at: indexPath)
        }
        //output?.changeCurrentFilter(currentFilterType)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
}

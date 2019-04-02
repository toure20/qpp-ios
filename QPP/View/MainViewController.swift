//
//  ViewController.swift
//  QPP
//
//  Created by Toremurat on 4/1/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit
import Gallery

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var pickedImages: [UIImage?] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        configureGallery()
    }
    
    func configureGallery() {
        // Gallery Picker Configs
        Config.initialTab = Config.GalleryTab.imageTab
        Config.Camera.recordLocation = false
        Config.VideoEditor.savesEditedVideoToLibrary = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pickedImages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == pickedImages.count {
            //plus icon
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionIdentifier", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
            cell.plusIcon.isHidden = false
            cell.bgImage.image = UIImage(named: "rounded_rect")
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionIdentifier", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
            cell.bgImage.image = pickedImages[indexPath.row]
            cell.plusIcon.isHidden = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == pickedImages.count {
            // TODO: open gallery
            let gallery = GalleryController()
            gallery.delegate = self
            self.present(gallery, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width/4 - 16
        return CGSize.init(width: size, height: size)
    }
}

extension MainViewController: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        Image.resolve(images: images) { (resolvedImages) in
            if let images = resolvedImages as? [UIImage] {
                self.pickedImages = images
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        self.dismiss(animated: true, completion: nil)
    }

}

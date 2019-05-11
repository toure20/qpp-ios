//
//  ViewController.swift
//  QPP
//
//  Created by Toremurat on 4/1/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit
import Gallery

class MainViewController: UIViewController {
    
    /// Collection of images which picked from gallery
    var pickedImages: [UIImage?] = [] {
        didSet {
            let title = pickedImages.isEmpty ? "Выбрать фотографии" : "Далее"
            nextButton.setTitle(title, for: .normal)
            collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageCollectionContrainerView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        configureGallery()
        self.navigationController?.navigationBar.topItem?.title = ""
        nextButton.setTitle("Выбрать фотографии", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func aboutSizesAction(_ sender: UITapGestureRecognizer) {
        let vc = DetailArticleViewController.instantiate("Details", DetailArticleViewController.self)
        vc.data = (image: UIImage(named: "image_1"), title: "Все о размерах", text: "some text here")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func aboutPartnersAction(_ sender: UITapGestureRecognizer) {
        let vc = DetailArticleViewController.instantiate("Details", DetailArticleViewController.self)
        vc.data = (image: UIImage(named: "image_1"), title: "Наши партнеры", text: "some text here")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if pickedImages.isEmpty {
        /// Open images picker
            let gallery = GalleryController()
            gallery.delegate = self
            self.present(gallery, animated: true, completion: nil)
        } else {
        /// Push to next screen
            let imageController = UIStoryboard.byName("Details")
                .instantiateViewController(withIdentifier: "ImagesViewController") as! ImagesViewController
            imageController.pickedImages = self.pickedImages
            self.navigationController?.pushViewController(imageController, animated: true)
        }
        
    }
    
    func configureGallery() {
        // Gallery Picker Configs
        Config.initialTab = Config.GalleryTab.imageTab
        Config.Camera.recordLocation = false
        Config.VideoEditor.savesEditedVideoToLibrary = false
        Config.tabsToShow = [.imageTab, .cameraTab]
        
        imageCollectionContrainerView.layer.shadowColor = UIColor.gray.cgColor
        imageCollectionContrainerView.layer.shadowRadius = 4.0
        imageCollectionContrainerView.layer.shadowOpacity = 0.2
        imageCollectionContrainerView.layer.shadowOffset = CGSize.zero
        
        nextButton.layer.shadowColor = UIColor.blue.cgColor
        nextButton.layer.shadowRadius = 4.0
        nextButton.layer.shadowOpacity = 0.3
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {}
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {}
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        self.dismiss(animated: true, completion: nil)
    }

}

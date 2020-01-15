//
//  ViewController.swift
//  QPP
//
//  Created by Toremurat on 4/1/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit
import Gallery
import SVProgressHUD
import Photos

class MainViewController: UIViewController {
    /// Collection of images which picked from gallery
    var pickedImages: [UIImage?] = [] {
        didSet {
            let title = pickedImages.isEmpty ? "Выбрать фотографии" : "Далее"
            nextButton.setTitle(title, for: .normal)
            collectionView.reloadData()
        }
    }
    private var images: [Image] = []
    
    @IBOutlet weak var emptyPlaceholder: UILabel!
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
        loadUserInfo()
        loadSizesAndAmounts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeItems), name: NSNotification.Name("cartUpdate"), object: nil)
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = UIColor(named: "navBarColor")
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            self.navigationController?.navigationBar.barTintColor = UIColor(named: "navBarColor")
        }
    }
    
    @objc private func removeItems() {
        pickedImages.removeAll()
    }
    
    private func loadUserInfo() {
        SVProgressHUD.show(withStatus: "Подгружаем необходимые данные...")
        guard let token = UserDefaults.standard.string(forKey: "USER_TOKEN") else { return }
        APIManager.makeRequest(target: .profileInfo(token: token), success: { (json) in
            let user = User(json: json["data"]["user"])
            SVProgressHUD.dismiss()
            cache.setObject(user, forKey: "CachedProfileObject")
        }) { _ in }
    }
    
    private func loadSizesAndAmounts() {
        APIManager.makeRequest(target: .getSizes, success: { (json) in
            let sizes = json["data"].arrayValue.compactMap({ SizeServerModel(json: $0) })
            print(json)
            let container = SizeAmountContainer.shared
            container.set(sizes: sizes)
            cacheContainer.setObject(container, forKey: "CachedSizeAmount")
        }) { _ in }
        APIManager.makeRequest(target: .getPriceList, success: { (json) in
            let prices = json["data"].arrayValue.compactMap({ PriceServerModel(json: $0) })
            SizeAmountContainer.shared.set(prices: prices)
            cacheContainer.setObject(SizeAmountContainer.shared, forKey: "CachedSizeAmount")
        }) { _ in }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
       
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    @IBAction func aboutSizesAction(_ sender: UITapGestureRecognizer) {
        let vc = AboutSizesViewController.instantiate("Details", AboutSizesViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func aboutPartnersAction(_ sender: UITapGestureRecognizer) {
        let vc = CompaniesViewController.instantiate("Details", CompaniesViewController.self)
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
            routeToPhotoEditor()
        }
        
    }
    
    func routeToPhotoEditor() {
        let sb = UIStoryboard.byName("Details")
        let vc = sb.instantiateViewController(withIdentifier: "ImagesViewController") as! ImagesViewController
        vc.pickedAssets = images
        self.navigationController?.pushViewController(vc, animated: true)
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
        
        nextButton.layer.shadowColor = UIColor.darkGray.cgColor
        nextButton.layer.shadowRadius = 4.0
        nextButton.layer.shadowOpacity = 0.3
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pickedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionIdentifier", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        cell.bgImage.image = pickedImages[indexPath.row]
        cell.plusIcon.isHidden = true
        return cell
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
        Image.resolve(images: images) { [weak self] (resolvedImages) in
            guard let self = self else { return }
            if let images = resolvedImages as? [UIImage] {
                self.pickedImages = images
                self.routeToPhotoEditor()
            }
        }
        self.emptyPlaceholder.isHidden = !images.isEmpty
        self.images = images
        self.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {}
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {}
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MainViewController: CartRepositoryOutput {
    func orderDidCreate() {
        let alert = UIAlertController(title: "Заказ успешно создан", message: "Вы можете отслеживать статус заказа в разделе «Меню - Мои заказы»", preferredStyle: .alert)
        let ordersAction = UIAlertAction(title: "Перейти в мои заказы", style: .default) { [weak self] _ in
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "MyOrdersViewController") as! MyOrdersViewController
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        let callAction = UIAlertAction(title: "Позвонить", style: .default) { [weak self] _ in
            // call
            let phoneScheme = "tel://\(+77087042247)"
            if let url = URL(string: phoneScheme) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        let cancelAction =  UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        alert.addAction(ordersAction)
        alert.addAction(callAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

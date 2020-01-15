//
//  ImagesViewController.swift
//  QPP
//
//  Created by Toremurat on 4/2/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit
import SVProgressHUD
import Photos
import Gallery

class ImagesViewController: UIViewController {

    enum LocalConstants {
        static let previewMaxHeight: CGFloat = UIScreen.main.bounds.height * 0.3
        static let animationDuration: Double = 0.25
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContainerView: UIView!
    @IBOutlet weak var scrollImageView: FAScrollView!
    @IBOutlet weak var imageBottomOffset: NSLayoutConstraint!
    
    @IBOutlet var imageOtherOffsets: [NSLayoutConstraint]!
    /// Preview photo view containts
    @IBOutlet weak var previewFrameView: UIView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var previewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var previewWidth: NSLayoutConstraint!
    @IBOutlet weak var previewHeight: NSLayoutConstraint!
    
    /// Collection views outlets
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var filtersСollectionView: UICollectionView!
    @IBOutlet weak var sizesCollectionView: UICollectionView!
    @IBOutlet weak var frameCollectionView: UICollectionView!
    
    /// UIButtons
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    
    private let imageManager = ImageManager()
    private var photosViewManager = PhotosViewManager()
    private var filterViewManager: FilterViewManager?
    private var sizeViewManager = SizeViewManager()
    private var frameViewManager = FrameViewManager()
    var cartRepository = serloc.getService(CartRepositoryProtocol.self)
    
    var pickedAssets: [Image] = []
    private var selectedItemIndex: Int = 0
    private var selectedSource: [Int: PhotoCart] = [:]
    
    // Constants
    var photosSizes: [PhotoSize] = [.polaroidSix, .polaroidNine, .eight, .nine, .ten]
    var quatities: [Int] = (1...100).map { Int($0) }
   
    fileprivate var addedToCard: Bool = false {
        didSet {
            if addedToCard {
                cartButton.setTitle("Перейти в корзину", for: .normal)
            } else {
                cartButton.setTitle("Добавить в корзину", for: .normal)
            }
        }
    }
    
    fileprivate var quantityRightItem: UIBarButtonItem?
    fileprivate let collectionItemHeight: CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Редактирование"
        
        self.filterViewManager = FilterViewManager(imageManager: imageManager)
        
        configurePhotosCollection()
        configureSizesCollection()
        scrollImageView.output = self
        filtersСollectionView.delegate = filterViewManager
        filtersСollectionView.dataSource = filterViewManager
        filterViewManager?.output = self
        
        frameCollectionView.delegate = frameViewManager
        frameCollectionView.dataSource = frameViewManager
        frameViewManager.output = self
        
        shareButton.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = UIColor.clear
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
//        self.scrollView.contentInset = UIEdgeInsets(top: -44, left: 0, bottom: 0, right: 0)
    }
    
    private func setupViews() {
        quantityRightItem = UIBarButtonItem(
            title: "1/\(pickedAssets.count)", style: .plain, target: self, action: nil
        )
        navigationItem.rightBarButtonItem = quantityRightItem
        previewContainerHeight.constant = LocalConstants.previewMaxHeight
    }
    
    private func configurePhotosCollection() {
        /// Photos collectionView
        Image.resolve(images: pickedAssets) { [weak self] (resolvedImages) in
            guard let self = self else { return }
            if let images = resolvedImages as? [UIImage] {
                self.photosViewManager.photos = images
                self.photosCollectionView.reloadData()
                
                /// Add to card all imagges with default configurations
                /// like image size .standar and frame is white
                for (index, image) in images.enumerated() {
                    self.selectedSource[index] = PhotoCart(image: image)
                }
                
                if !images.isEmpty {
                    self.photosViewManager.selectedIndex = 0
                    self.selectImageFromAssetAtIndex(0)
                    self.updateCurrentStates()
                }
            }
        }
        photosViewManager.output = self
        photosCollectionView.delegate = photosViewManager
        photosCollectionView.dataSource = photosViewManager
        photosCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
    }
    
    private func configureSizesCollection() {
        /// Sizes collectionView
        sizesCollectionView.delegate = sizeViewManager
        sizesCollectionView.dataSource = sizeViewManager
        sizeViewManager.sizes = photosSizes
        sizeViewManager.output = self
        sizesCollectionView.reloadData()
        if !sizeViewManager.sizes.isEmpty {
            previewWidth.constant = LocalConstants.previewMaxHeight
            previewHeight.constant = LocalConstants.previewMaxHeight
            imageBottomOffset.constant = 5
            imageOtherOffsets.forEach({ $0.constant = 5 })
            sizesCollectionView.selectItem(
                at: IndexPath(row: 0, section: 0),
                animated: true,
                scrollPosition: .left
            )
        }
    }
    
    /// MARK: - Add to cart button action
    @IBAction func nextButtonPressed(_ sender: Any) {
        if selectedSource.isEmpty {
            SVProgressHUD.showError(withStatus: "Выберите размеры и количество")
            return
        }
        cartRepository.set(cartItems: selectedSource)
        let vc = UIStoryboard.init(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        vc.hidesBottomBarWhenPushed = false
        self.navigationController?.show(vc, sender: nil)
            
        
        SVProgressHUD.showSuccess(withStatus: "Добавлено в корзину")
        cartRepository.set(cartItems: selectedSource)
        addedToCard = true
        /// Adding badge to cart tabbar item
        if let tabItems = tabBarController?.tabBar.items {
            tabItems[1].badgeValue = "\(pickedAssets.count)"
        }
    }
    
    @objc func shareButtonPressed() {
        scrollImageView.gridView.isHidden = true
        let imageToSave = previewFrameView.asImage()
        UIImageWriteToSavedPhotosAlbum(imageToSave, self,  #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        } else {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            SVProgressHUD.showSuccess(withStatus: "Текущая фотография сохранена в галерее")
        }
    }
    
    func selectImageFromAssetAtIndex(_ index: NSInteger){
        FAImageLoader.imageFrom(
            asset: pickedAssets[index].asset,
            size: PHImageManagerMaximumSize) { (image) in
            DispatchQueue.main.async {
                self.displayImageInScrollView(image: image)
            }
        }
    }
    
    func displayImageInScrollView(image: UIImage){
        scrollImageView.imageToDisplay = image
        scrollImageView.resizeWithNoSpace()
        
        scrollImageView.gridView.isHidden = true
        selectedSource[selectedItemIndex]?.image = scrollImageView.asImage()
        scrollImageView.gridView.isHidden = false
    }
    
    /// Cropping
    private func captureVisibleRect() -> UIImage {
        var croprect = CGRect.zero
        let xOffset = (scrollImageView.imageToDisplay?.size.width ?? 1.0) / scrollImageView.contentSize.width
        let yOffset = (scrollImageView.imageToDisplay?.size.height ?? 1.0) / scrollImageView.contentSize.height
        
        croprect.origin.x = scrollImageView.contentOffset.x * xOffset
        croprect.origin.y = scrollImageView.contentOffset.y * yOffset
        
        let normalizedWidth = (scrollImageView?.frame.width)! / (scrollImageView?.contentSize.width)!
        let normalizedHeight = (scrollImageView?.frame.height)! / (scrollImageView?.contentSize.height)!
        
        croprect.size.width = scrollImageView.imageToDisplay!.size.width * normalizedWidth
        croprect.size.height = scrollImageView.imageToDisplay!.size.height * normalizedHeight
        
        let toCropImage = scrollImageView.imageView.image?.fixImageOrientation()
        let cr: CGImage? = toCropImage?.cgImage?.cropping(to: croprect)
        let cropped = UIImage(cgImage: cr!)
        
        return cropped
    }
    
    private func updateCurrentStates() {
        if let selectedOption = selectedSource[selectedItemIndex],
            let sizeIndex = sizeViewManager.sizes.index(of: selectedOption.size) {
            sizeViewManager.selectedIndex = sizeIndex
            //sizesCollectionView.deleteItems(at: sizesCollectionView.indexPathsForVisibleItems)
            //sizesCollectionView.insertItems(at: sizesCollectionView.indexPathsForVisibleItems)
            sizesCollectionView.reloadItems(at: sizesCollectionView.indexPathsForVisibleItems)
            DispatchQueue.main.async {
                self.changeCurrentSize(selectedOption.size)
            }
        }
        if let selectedOption = selectedSource[selectedItemIndex],
            let frameIndex = frameViewManager.frames.index(of: selectedOption.frame) {
            frameViewManager.selectedIndex = frameIndex
            sizesCollectionView.reloadItems(at: sizesCollectionView.indexPathsForVisibleItems)
            changeCurrentFrame(with: selectedOption.frame)
        }
    }

}

extension ImagesViewController: BaseViewManagerOutput {
    func didSelectCurrentCell(at indexPath: IndexPath, manager: NSObject) {
        switch manager {
        case photosViewManager:
            self.quantityRightItem?.title = "\(indexPath.row + 1)/\(pickedAssets.count)"
            self.selectImageFromAssetAtIndex(indexPath.row)
            self.selectedItemIndex = indexPath.row
            photosCollectionView.reloadItems(at: photosCollectionView.indexPathsForVisibleItems)
            updateCurrentStates()
        case filterViewManager:
            filtersСollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        case sizeViewManager:
            sizesCollectionView.reloadItems(at: sizesCollectionView.indexPathsForVisibleItems)
        default: break
        }
    }
}

extension ImagesViewController: FilterViewManagerOutput {
    func changeCurrentFilter(_ type: ImageFilterType) {
        //self.currentFilterType = type
    }
}

extension ImagesViewController: SizeViewManagerOutput {
    func changeCurrentSize(_ type: PhotoSize) {
        switch type {
        case .polaroidSix:
            /// 8x8
            imageOtherOffsets.forEach({ $0.constant = 10 })
            imageBottomOffset.constant = 20
            UIView.animate(withDuration: LocalConstants.animationDuration) {
                self.previewWidth.constant = LocalConstants.previewMaxHeight * 6/9
                self.previewHeight.constant = LocalConstants.previewMaxHeight
                self.view.layoutIfNeeded()
            }
            scrollImageView.resizeWithNoSpace()
        case .polaroidNine:
            /// 8x8
            imageOtherOffsets.forEach({ $0.constant = 10 })
            imageBottomOffset.constant = 20
            UIView.animate(withDuration: LocalConstants.animationDuration) {
                self.previewWidth.constant = LocalConstants.previewMaxHeight * 9/10
                self.previewHeight.constant = LocalConstants.previewMaxHeight
                self.view.layoutIfNeeded()
            }
            scrollImageView.resizeWithNoSpace()
        case .eight:
            /// 8x8
            imageOtherOffsets.forEach({ $0.constant = 5 })
            imageBottomOffset.constant = 5
            UIView.animate(withDuration: LocalConstants.animationDuration) {
                self.previewWidth.constant = LocalConstants.previewMaxHeight
                self.previewHeight.constant = LocalConstants.previewMaxHeight
                self.view.layoutIfNeeded()
            }
            scrollImageView.resizeWithNoSpace()
        case .nine:
            /// 9x13
            imageOtherOffsets.forEach({ $0.constant = 5 })
            imageBottomOffset.constant = 5
            self.previewWidth.constant = LocalConstants.previewMaxHeight
            self.previewHeight.constant = LocalConstants.previewMaxHeight * 9/13
            self.view.layoutIfNeeded()
            scrollImageView.resizeWithNoSpace()
        case .ten:
            /// 10x15
            imageOtherOffsets.forEach({ $0.constant = 5 })
            imageBottomOffset.constant = 5
            scrollImageView.resizeWithNoSpace()
            self.previewWidth.constant = LocalConstants.previewMaxHeight
            self.previewHeight.constant = LocalConstants.previewMaxHeight * 10/15
            self.view.layoutIfNeeded()
        }
        
        selectedSource[selectedItemIndex]?.size = type
        scrollImageView.gridView.isHidden = true
        selectedSource[selectedItemIndex]?.image = self.scrollImageView.asImage()
        scrollImageView.gridView.isHidden = false
    }
}

extension ImagesViewController: FrameViewManagerOutput {
    func changeCurrentFrame(with type: FrameType) {
        previewFrameView.backgroundColor = type.bgColor
        //frameCollectionView.reloadData()
        frameCollectionView.reloadItems(at: frameCollectionView.indexPathsForVisibleItems)
        selectedSource[selectedItemIndex]?.frame = type
    }
}

extension ImagesViewController: FAScrollViewOutput {
    func didEndImageDeceleration() {
        scrollImageView.gridView.isHidden = true
        selectedSource[selectedItemIndex]?.image = scrollImageView.asImage()
        scrollImageView.gridView.isHidden = false
    }
}

//
//  ImagesViewController.swift
//  QPP
//
//  Created by Toremurat on 4/2/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit
import SVProgressHUD

class ImagesViewController: UIViewController {
    
    var cartRepository = serloc.getService(CartRepositoryProtocol.self)
    
    var pickedImages: [UIImage?] = [] {
        didSet {
            for (index, img) in self.pickedImages.enumerated() {
                selectedSource[index] = PhotoCart(image: img)
            }
        }
    }
    private var selectedItemIndex: Int = 0
    private var selectedSource: [Int: PhotoCart] = [:]
    
    // Constants
    var photosSizes: [PhotoSize] = [.nine, .ten, .thirteen, .fifteen, .twenty, .twentyOne, .thirty]
    var quatities: [Int] = (1...20).map { Int($0) }
    
    var collectionView: UICollectionView
    @IBOutlet weak var currentNumberLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var sizeButton: UIButton!
    @IBOutlet weak var quantityButton: UIButton!
    
    fileprivate let collectionItemHeight: CGFloat = 300
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        pageSize.width += layout.minimumLineSpacing
        return pageSize
    }
    
    required init?(coder aDecoder: NSCoder) {
        let layout = UPCarouselFlowLayout()
        layout.scrollDirection = .horizontal
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 0)
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: screenWidth - screenWidth/4, height: collectionItemHeight)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Выберите размер"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setupGradientBackground(
            [UIColor.init(hex: "4754A5"), UIColor.init(hex: "2C367A")]
        )
        setupViews()
    }
    
    private func setupViews() {
        currentNumberLabel.text = "1/\(pickedImages.count)"
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        
        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        pickerContainerView.layer.shadowColor = UIColor.gray.cgColor
        pickerContainerView.layer.shadowRadius = 4.0
        pickerContainerView.layer.shadowOpacity = 0.2
        pickerContainerView.layer.shadowOffset = CGSize.zero
        
        nextButton.layer.shadowColor = UIColor.blue.cgColor
        nextButton.layer.shadowRadius = 4.0
        nextButton.layer.shadowOpacity = 0.3
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    @IBAction func chooseSizeButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(style: .actionSheet, title: "Выберите размер", message: "")
        let pickerViewValues: [[String]] = [photosSizes.compactMap{ $0.rawValue }]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 1)
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            print(index)
            let quantity = self.selectedSource[self.selectedItemIndex]?.quantity ?? 1
            let size = self.photosSizes[index.row]
            let image = self.pickedImages[self.selectedItemIndex]
            if let exisitingItem = self.selectedSource[self.selectedItemIndex] {
                exisitingItem.quantity = quantity
                exisitingItem.size = size
                exisitingItem.image = image
            } else {
                self.selectedSource[self.selectedItemIndex] = PhotoCart(quantity: quantity, size: size, image: image)
            }
            
            self.sizeButton.setTitle(size.rawValue, for: .normal)
        }
        alert.addAction(title: "Выбрать", style: .cancel)
        alert.show()
    }
    
    @IBAction func chooseQuantityButtonPressed(_ sender: Any) {
        let alert = UIAlertController(style: .actionSheet, title: "Укажите количество", message: "")
        let pickerViewValues: [[String]] = [quatities.map { Int($0).description }]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 1)
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            print(index)
            let quantity = self.quatities[index.row]
            let size = self.selectedSource[self.selectedItemIndex]?.size ?? PhotoSize.standart
            let image = self.pickedImages[self.selectedItemIndex]
            self.selectedSource[self.selectedItemIndex] = PhotoCart(quantity: quantity, size: size, image: image)
            self.quantityButton.setTitle("\(quantity)", for: .normal)
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    
    /// MARK: - Add to cart button action
    @IBAction func nextButtonPressed(_ sender: Any) {
        if selectedSource.isEmpty {
            SVProgressHUD.showError(withStatus: "Выберите размеры и количество")
            return
        }
        SVProgressHUD.showSuccess(withStatus: "Добавлено в корзину")
        cartRepository.set(cartItems: selectedSource)
        
        /// Adding badge to cart tabbar item
        if let tabItems = tabBarController?.tabBar.items {
            tabItems[1].badgeValue = ""
        }
    }

}

extension ImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pickedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        cell.bgImage.image = pickedImages[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width - 100, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard self.collectionView.collectionViewLayout is UPCarouselFlowLayout else { return }
        let pageSide = self.pageSize.width
        let offset = scrollView.contentOffset.x
        let currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        selectedItemIndex = currentPage
        currentNumberLabel.text = "\(currentPage + 1)/\(pickedImages.count)"
        
        // Size and Quantity button titles
        if let selectedItem = selectedSource[selectedItemIndex] {
            quantityButton.setTitle("\(selectedItem.quantity)", for: .normal)
            sizeButton.setTitle(selectedItem.size.rawValue, for: .normal)
        } else {
            quantityButton.setTitle("Выбрать", for: .normal)
            sizeButton.setTitle("Выбрать", for: .normal)
        }
    }
}

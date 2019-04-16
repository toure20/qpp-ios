//
//  ImagesViewController.swift
//  QPP
//
//  Created by Toremurat on 4/2/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController {
    
    var pickedImages: [UIImage?] = []
    
    var collectionView: UICollectionView
    @IBOutlet weak var currentNumberLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
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
    
    @IBAction func nextButtonPressed(_ sender: Any) {
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
        currentNumberLabel.text = "\(currentPage + 1)/\(pickedImages.count)"
    }
}

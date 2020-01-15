//
//  AboutSizesViewController.swift
//  QPP
//
//  Created by Toremurat on 4/29/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class AboutSizesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var staticSizes = mockAboutSizesData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Все о размерах"
        let color = UIColor(named: "navBarColor") ?? UIColor.black
        self.navigationController?.navigationBar.setupGradientBackground(
            [color, color]
        )
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func mockAboutSizesData() -> [PresentableSize] {
        //Не скручиваются, не боятся УФ-лучей, не выцветают на солнце до 50 лет
        return [
            PresentableSize(title: "6x9 Polaroid", descr: "Размер: 60х90мм • фото: 50х70мм", photo: "6x9_sample"),
            PresentableSize(title: "9x10 Polaroid", descr: "Размер: 90х100мм • фото: 80х80мм", photo: "9x10_sample"),
            PresentableSize(title: "8x8 Square", descr: "Размер: 80х80мм • квадратная, с рамкой и без", photo: "8x8_sample"),
            PresentableSize(title: "9x13 Album mini", descr: "Размер: 90х130мм, альбомная, для панорамного фото", photo: "9x13_sample"),
            PresentableSize(title: "10x15 Album", descr: "Размер: 100х150мм • предназначена для альбома", photo: "10x15_sample")
        ]
    }
}

extension AboutSizesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return staticSizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AboutSizeCollectionCell", for: indexPath) as? AboutSizeCollectionCell else { return UICollectionViewCell() }
        cell.bgImage.image = UIImage(named: staticSizes[indexPath.row].photo) ?? UIImage(named: "sample_polaroid")
        cell.titleLabel.text = staticSizes[indexPath.row].title
        cell.subtitleLabel.text = staticSizes[indexPath.row].descr
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let photo = SKPhoto.photoWithImage(UIImage(named: staticSizes[indexPath.row].photo) ?? UIImage())
        let browser = SKPhotoBrowser(photos: [photo])
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: view.frame.height * 0.24)
    }
}

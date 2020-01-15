//
//  CartViewController.swift
//  QPP
//
//  Created by Абай Жунус on 4/8/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit
import SVProgressHUD

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var cartRepository: CartRepositoryProtocol!
    var cartItems: [Int: PhotoCart] = [:]
    
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartRepository = serloc.getService(CartRepositoryProtocol.self)
        self.title = "Корзина"
        self.tabBarItem.badgeValue = nil
        subscribeToCartItems()
        setupViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeItems), name: NSNotification.Name("cartUpdate"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarItem.badgeValue = nil
        subscribeToCartItems()
    }
    
    @objc private func removeItems() {
        tableView.reloadData()
    }
    
    private func subscribeToCartItems() {
        self.cartItems = cartRepository.getItems()
        totalLabel.text = "К оплате: \(cartRepository.calculateTotalAmount())"
        noDataLabel.isHidden = !self.cartItems.isEmpty
        tableView.reloadData()
    }
    
    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 12
        tableView.tableFooterView = UIView()
        
        nextButton.layer.shadowColor = UIColor.lightGray.cgColor
        nextButton.layer.shadowRadius = 4.0
        nextButton.layer.shadowOpacity = 0.6
        nextButton.layer.shadowOffset = CGSize(width: -2, height: 2)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = UIColor(named: "navBarColor")
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        cell.sizeLabel.text = cartItems[indexPath.row]?.size.rawValue
        cell.quantity = cartItems[indexPath.row]?.quantity ?? 1
        cell.bgImage.image = cartItems[indexPath.row]?.image
        cell.output = self
        cell.index = indexPath.row
        return cell
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if self.cartItems.isEmpty {
            SVProgressHUD.showError(withStatus: "Заполните корзину! Нам нечего оформлять:(")
            return
        }
        let vc = OrderViewController.instantiate("Main", OrderViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CartViewController: CartTableCellOutput{
    func updateItem(count: Int, at index: Int) {
        cartItems[index]?.update(count)
        totalLabel.text = "К оплате: \(cartRepository.calculateTotalAmount())"
    }
}

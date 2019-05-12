//
//  MyOrdersViewController.swift
//  QPP
//
//  Created by Абай Жунус on 4/11/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit

class MyOrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var orders: [UserOrder] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Мои заказы"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 12
        tableView.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }
    
    static func instantiate() -> MyOrdersViewController {
        return UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "MyOrdersViewController") as! MyOrdersViewController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrdersTableViewCell", for: indexPath) as! MyOrdersTableViewCell
        cell.set(order: orders[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

////
////  File.swift
////  QPP
////
////  Created by Абай Жунус on 4/8/19.
////  Copyright © 2019 STUDIO-X. All rights reserved.
////
//
//import Foundation
////
////  CartViewController.swift
////  QPP
////
////  Created by Абай Жунус on 4/8/19.
////  Copyright © 2019 STUDIO-X. All rights reserved.
////
//
//import UIKit
//
//class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    @IBOutlet weak var totalLabel: UILabel!
//    @IBOutlet weak var nextButton: UIButton!
//    @IBOutlet weak var tableView: UITableView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
//        // Do any additional setup after loading the view.
//    }
//
//
//
//    @IBAction func nextButtonPressed(_ sender: UIButton) {
//    }
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath)
//        return cell
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100.0
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
//}
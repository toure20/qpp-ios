//
//  DetailArticleViewController.swift
//  QPP
//
//  Created by Toremurat on 4/29/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit

class DetailArticleViewController: UIViewController {

    var data: (image: UIImage?, title: String, text: String)?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgrounImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgrounImage.image = data?.image
        self.titleLabel.text = data?.title
        self.dateLabel.text = Date().dateString()
        self.textLabel.text = data?.text
        self.title = data?.title
        self.navigationController?.navigationBar.setupGradientBackground(
            [UIColor.init(hex: "4754A5"), UIColor.init(hex: "2C367A")]
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

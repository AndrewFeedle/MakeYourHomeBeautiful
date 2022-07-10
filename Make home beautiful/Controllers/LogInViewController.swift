//
//  ViewController.swift
//  Make home beautiful
//
//  Created by Feedle on 10.07.2022.
//

import UIKit

class LogInViewController: UIViewController {
    @IBOutlet weak var listView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listView.layer.masksToBounds = false
        listView.layer.shadowColor = UIColor.black.cgColor
        listView.layer.shadowOpacity = 0.1
        listView.layer.shadowOffset = .init(width: 0, height: 10)
        listView.layer.shadowRadius = 20
    }


}


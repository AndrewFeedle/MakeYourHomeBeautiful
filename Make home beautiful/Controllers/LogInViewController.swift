//
//  ViewController.swift
//  Make home beautiful
//
//  Created by Feedle on 10.07.2022.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var centralUIView: UIView!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DesignTemplate.addShadow(object: centralUIView) // Добавляем тень для
        DesignTemplate.addShadow(object: logInButton) // Добавляем тень для кнопки "Войти"
    }


}


//
//  ViewController.swift
//  Make home beautiful
//
//  Created by Feedle on 10.07.2022.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var centralUIView: UIView!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
        emailTextField.delegate = self
        DesignTemplate.addShadow(object: centralUIView) // Добавляем тень для
        DesignTemplate.addShadow(object: logInButton) // Добавляем тень для кнопки "Войти"
    }
    
    // Нажатие на кнопку "Войти"
    @IBAction func loginButtonPressed(_ sender: UIButton) {
    }
    
    // Нажатие на кнопку скрыть/показать пароль
    @IBAction func passVisabilityButtonPressed(_ sender: UIButton) {
        if passwordTextField.isSecureTextEntry{
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
            passwordTextField.isSecureTextEntry = false
        }
        else{
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
    }
}

//MARK: - Обработка полей ввода
extension LogInViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailTextField.isFirstResponder{
            passwordTextField.becomeFirstResponder()
        }
        else if passwordTextField.isFirstResponder{
            passwordTextField.resignFirstResponder()
            loginButtonPressed(logInButton)
        }
        return true
    }
}

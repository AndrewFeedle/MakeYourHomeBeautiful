//
//  HomeViewController.swift
//  Make home beautiful
//
//  Created by Feedle on 14.07.2022.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var centralUIView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var divider4: UIView!
    @IBOutlet weak var divider3: UIView!
    @IBOutlet weak var divider2: UIView!
    @IBOutlet weak var divider1: UIView!
    @IBOutlet weak var passwordReEyeButton: UIButton!
    @IBOutlet weak var passwordReTextField: UITextField!
    @IBOutlet weak var passwordEyeButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        DesignTemplate.addShadow(object: centralUIView) // Добавляем тень для
        DesignTemplate.addShadow(object: registerButton) // Добавляем тень для кнопки "Войти"
        //Добавляет наблюдателя за появлением клавиатуры
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow(notification:)),name: UIResponder.keyboardWillShowNotification, object: nil)
        //Добавляет наблюдателя за скрытием клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),name: UIResponder.keyboardWillHideNotification,object: nil)
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordReTextField.delegate = self
    }
    
    // Нажатие на кнопку зарегистрироваться
    @IBAction func registerButtonPressed(_ sender: UIButton) {
    }
    
    // Нажатие на кнопку скрыть пароль
    @IBAction func passwordEyeButtonPressed(_ sender: UIButton) {
        if passwordTextField.isSecureTextEntry{
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            passwordTextField.isSecureTextEntry = false
        }
        else{
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    // Нажатие на кнопку скрыть повторение пароляя
    @IBAction func passwordReEyePressed(_ sender: UIButton) {
        if passwordReTextField.isSecureTextEntry{
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            passwordReTextField.isSecureTextEntry = false
        }
        else{
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
            passwordReTextField.isSecureTextEntry = true
        }
    }
    // При нажатии Уже есть аккаунт
    @IBAction func alreadyHaveAccountPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    
}

//MARK: - Обработка полей ввода
extension RegisterViewController: UITextFieldDelegate{
    // Начало редактирования текста
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTextField{
            UIView.animate(withDuration: 0.3) {
                self.divider1.backgroundColor = UIColor.label
            }
        }else if textField == emailTextField{
            UIView.animate(withDuration: 0.3) {
                self.divider2.backgroundColor = UIColor.label
            }
        }
        else if textField == passwordTextField{
        UIView.animate(withDuration: 0.3) {
            self.divider3.backgroundColor = UIColor.label
            }
        }
        else{
            UIView.animate(withDuration: 0.3) {
        self.divider4.backgroundColor = UIColor.label
            }
        }
    }
    
    // Окончание редактирования текста
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField{
            UIView.animate(withDuration: 0.3) {
                self.divider1.backgroundColor = UIColor.lightGray
            }
        }else if textField == emailTextField{
            UIView.animate(withDuration: 0.3) {
                self.divider2.backgroundColor = UIColor.lightGray
            }
        }
        else if textField == passwordTextField{
        UIView.animate(withDuration: 0.3) {
            self.divider3.backgroundColor = UIColor.lightGray
            }
        }
        else{
            UIView.animate(withDuration: 0.3) {
        self.divider4.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    //При нажатии на клавиатуре кнопки return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField{
            emailTextField.becomeFirstResponder()
        }else if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField{
            passwordReTextField.becomeFirstResponder()
        }else{
            registerButtonPressed(registerButton)
        }
        return true
    }
}

//MARK: - Скрытие клавиатуры и регулировка положения view
extension RegisterViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // При появлении клавиатуры
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 10, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    // При скрытии клавиатуры
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}


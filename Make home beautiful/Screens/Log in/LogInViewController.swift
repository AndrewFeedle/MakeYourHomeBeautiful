//
//  ViewController.swift
//  Make home beautiful
//
//  Created by Feedle on 10.07.2022.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailDivider: UIView!
    @IBOutlet weak var passwordDivider: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var centralUIView: UIView!
    @IBOutlet weak var logInButton: UIButton!
    private var vieModel = LogInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
        emailTextField.delegate = self
        vieModel.delegate = self
        
        DesignTemplate.addShadow(object: centralUIView) // Добавляем тень для
        DesignTemplate.addShadow(object: logInButton) // Добавляем тень для кнопки "Войти"
        
        //Добавляет наблюдателя за появлением клавиатуры
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow(notification:)),name: UIResponder.keyboardWillShowNotification, object: nil)
        //Добавляет наблюдателя за скрытием клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),name: UIResponder.keyboardWillHideNotification,object: nil)
    }
    
    //При закрытии формы
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
    
    // Нажатие на кнопку "Войти"
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        vieModel.logIn(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        activityIndicator.startAnimating()
    }
    
    // Нажатие на кнопку скрыть/показать пароль
    @IBAction func passVisabilityButtonPressed(_ sender: UIButton) {
        if passwordTextField.isSecureTextEntry{
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            passwordTextField.isSecureTextEntry = false
        }
        else{
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
    }
}

//MARK: - Обработка полей ввода
extension LogInViewController: UITextFieldDelegate{
    //При нажатии на клавиатуре кнопки return
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
    
    // Когда текстовое поле начали редактировать
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if emailTextField.isEditing{
            UIView.animate(withDuration: 0.3) {
                self.emailDivider.backgroundColor = UIColor.label
            }
        }
        else{
            UIView.animate(withDuration: 0.3) {
                self.passwordDivider.backgroundColor = UIColor.label
            }
        }
    }
    
    // Когда текстовое поле закончили редактировать
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !emailTextField.isEditing{
            UIView.animate(withDuration: 0.3) {
                self.emailDivider.backgroundColor = UIColor.lightGray
            }
        }
        if !passwordTextField.isEditing{
            UIView.animate(withDuration: 0.3) {
                self.passwordDivider.backgroundColor = UIColor.lightGray
            }
        }
    }
}

//MARK: -
extension LogInViewController: LogInDelegate{
    // Показывает ошибку
    func presentErrorAlert(title: String, message: String) {
        activityIndicator.stopAnimating()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // При удачной авторизации перемещает на главный экран
    func pushToMain(uid:String){
        activityIndicator.stopAnimating()
        performSegue(withIdentifier: "goToHome", sender: self)
    }
}

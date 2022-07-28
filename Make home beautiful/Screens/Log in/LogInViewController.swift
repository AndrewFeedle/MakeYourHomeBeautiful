//
//  ViewController.swift
//  Make home beautiful
//
//  Created by Feedle on 10.07.2022.
//

import UIKit

class LogInViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailDivider: UIView!
    @IBOutlet weak var passwordDivider: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var centralUIView: UIView!
    @IBOutlet weak var logInButton: UIButton!
    private lazy var viewModel = LogInViewModel()
    private var uid:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
        emailTextField.delegate = self
        self.hideKeyboardWhenTappedAround() //Скрытие клавиатуры при нажатии куда-либо еще
        
        DesignSnippets.addShadow(object: centralUIView) // Добавляем тень для
        DesignSnippets.addShadow(object: logInButton) // Добавляем тень для кнопки "Войти"
        
        //Добавляет наблюдателя за появлением клавиатуры
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow(notification:)),name: UIResponder.keyboardWillShowNotification, object: nil)
        //Добавляет наблюдателя за скрытием клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),name: UIResponder.keyboardWillHideNotification,object: nil)
        
        setLogInObservers()//Подключаем наблюдателей и пытаемся авторизоваться
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            self.viewModel.tryLogIn() // Попытка входа
        }
    }
    
    //При закрытии формы
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }
    
    // Установка наблюдателей при попытке входа
    private func setLogInObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(presentErrorAlert(_:)), name: Notification.Name("presentErrorAlert"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushToHome(_:)), name: Notification.Name("pushToHome"), object: nil)
    }
    
    // Нажатие на кнопку "Войти"
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        mainView.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        setLogInObservers()//Подключаем наблюдателей и пытаемся авторизоваться
        let emailText = emailTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {[self] in
            viewModel.logIn(email: emailText, password: passwordText)
        }
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
    
    // Перед переходом на другой экран
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Переход на экран Домой
        if(segue.identifier == "fromLoginToHome"){
            let homeView = segue.destination as! HomeViewController
            homeView.uid = uid
        }
    }
    
    // Показывает ошибку
    @objc private func presentErrorAlert(_ notification: Notification) {
        DispatchQueue.main.async {[self] in
            NotificationCenter.default.removeObserver(self)
            mainView.isUserInteractionEnabled = true
            activityIndicator.stopAnimating()
            if scrollView.isHidden{
                setScrollViewHidden(Notification(name: Notification.Name(""), object: nil, userInfo: ["hide":false]))
            }
            let title = notification.userInfo!["title"] as! String
            let message = notification.userInfo!["message"] as! String
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // При удачной авторизации перемещает на главный экран
    @objc private func pushToHome(_ notification: Notification){
        DispatchQueue.main.async {[self] in
            NotificationCenter.default.removeObserver(self)
            self.uid = notification.userInfo!["uid"] as? String
            mainView.isUserInteractionEnabled = true
            activityIndicator.stopAnimating()
            emailTextField.text = ""
            passwordTextField.text = ""
            setScrollViewHidden(Notification(name: Notification.Name(""), object: self, userInfo: ["hide":false]))
            performSegue(withIdentifier: "fromLoginToHome", sender: self)
        }
    }
    
    // Устанавлиает видимость формы
    @objc private func setScrollViewHidden(_ notification: Notification){
        DispatchQueue.main.async {[self] in
            let isHidden = (notification.userInfo!["hide"] as? Bool)!
            UIView.transition(with: scrollView, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {self.scrollView.isHidden = isHidden})
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
            UIView.animate(withDuration: Constants.animationDuration) {
                self.emailDivider.backgroundColor = UIColor.label
            }
        }
        else{
            UIView.animate(withDuration: Constants.animationDuration) {
                self.passwordDivider.backgroundColor = UIColor.label
            }
        }
    }
    
    // Когда текстовое поле закончили редактировать
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !emailTextField.isEditing{
            UIView.animate(withDuration: Constants.animationDuration) {
                self.emailDivider.backgroundColor = UIColor.systemGray
            }
        }
        if !passwordTextField.isEditing{
            UIView.animate(withDuration: Constants.animationDuration) {
                self.passwordDivider.backgroundColor = UIColor.systemGray
            }
        }
    }
}

//MARK: - Скрытие клавиатуры и регулировка положения view
extension LogInViewController {
    // Скрывает клавиатуру, когда нажимаешь куда-либо еще
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(LogInViewController.dismissKeyboard))
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

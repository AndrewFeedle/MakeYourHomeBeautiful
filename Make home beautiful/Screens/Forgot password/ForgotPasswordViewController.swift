//
//  ForgotPasswordViewController.swift
//  Make home beautiful
//
//  Created by Feedle on 13.07.2022.
//

protocol ForgotPasswordDelegate{
    func presentErrorAlert(title: String, message: String)
}

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var sendMailButton: UIButton!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bottomConstrait: NSLayoutConstraint!
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    private var viewModel = ForgotPasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        emailTextField.delegate = self
        viewModel.delegate = self
        emailTextField.becomeFirstResponder()        
    }
    
    // При закрытии формы
    override func viewWillDisappear(_ animated: Bool) {
            NotificationCenter.default.removeObserver(self)
        }
    
    // Нажатие на кнопку Отправить письмо
    @IBAction func sendMailPressed(_ sender: UIButton) {
        if emailTextField.text != nil{
            activityIndicator.startAnimating()
            viewModel.sendMailPressed(email: emailTextField.text!)
            mainView.isUserInteractionEnabled = false
            activityIndicator.startAnimating()
        }else{
            presentErrorAlert(title: "Ошибка", message: "Почта не должна быьт пустой")
        }
    }
    
    
    // Обработка клавиатуры чтобы она не перекрывала текстовые поля
    @objc func handleKeyboardNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            bottomConstrait?.constant = isKeyboardShowing ? keyboardFrame!.height + 10 : 60
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }
}

//MARK: - ForgotPasswordDelegate
extension ForgotPasswordViewController: ForgotPasswordDelegate{
    // Показывает сообщение пользователю
    func presentErrorAlert(title: String, message: String) {
        activityIndicator.stopAnimating()
        mainView.isUserInteractionEnabled = true
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if title == ""{
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: dismissScreen))
        }else{
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    // Возвращает на предыдущий экран
    func dismissScreen(alertAction :UIAlertAction){
        dismiss(animated: true, completion: nil)
    }
}

//MARK: -  Скрытие клавиатуры при нажатии куда либо еще
extension ForgotPasswordViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(LogInViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - Обработка полей ввода
extension ForgotPasswordViewController: UITextFieldDelegate{
    //При нажатии на клавиатуре кнопки Send
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        sendMailPressed(sendMailButton)
        return true
    }

    // Когда текстовое поле начали редактировать
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.divider.backgroundColor = UIColor.label
        }
    }

    // Когда текстовое поле закончили редактировать
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.divider.backgroundColor = UIColor.lightGray
        }
    }
}

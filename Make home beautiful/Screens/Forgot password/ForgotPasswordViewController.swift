//
//  ForgotPasswordViewController.swift
//  Make home beautiful
//
//  Created by Feedle on 13.07.2022.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var sendMailButton: UIButton!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bottomConstrait: NSLayoutConstraint!
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    private lazy var viewModel = ForgotPasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()//Скрытие клавиатуры при нажатии куда-либо еще
        
        //Добавляет наблюдателя за появлением клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        //Добавляет наблюдателя за скрытием клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        emailTextField.delegate = self
        emailTextField.becomeFirstResponder()        
    }
    
    // При закрытии формы
    override func viewWillDisappear(_ animated: Bool) {
            NotificationCenter.default.removeObserver(self)
        }
    
    // Нажатие на кнопку Отправить письмо
    @IBAction func sendMailPressed(_ sender: UIButton) {
            activityIndicator.startAnimating()
            mainView.isUserInteractionEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(presentErrorAlert(_:)), name: Notification.Name("presentErrorAlert"), object: nil)
        let text = emailTextField.text ?? ""
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            self.viewModel.sendMailPressed(email: text)
        }
    }
    
    // Показывает сообщение пользователю
    @objc private func presentErrorAlert(_ notification: Notification) {
        DispatchQueue.main.async {[self] in
            NotificationCenter.default.removeObserver(self)
            let title = notification.userInfo!["title"] as? String
            let message = notification.userInfo!["message"] as? String
            activityIndicator.stopAnimating()
            mainView.isUserInteractionEnabled = true
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            if title == ""{
                emailTextField.text = ""
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: dismissScreen))
            }else{
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Возвращает на предыдущий экран
    private func dismissScreen(alertAction :UIAlertAction){
        dismiss(animated: true, completion: nil)
    }
}

//MARK: -  Обработка клавиатуры
extension ForgotPasswordViewController {
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(LogInViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Обработка клавиатуры чтобы она не перекрывала текстовые поля
    @objc private func handleKeyboardNotification(_ notification: Notification) {
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
                self.divider.backgroundColor = UIColor.systemGray
            }
    }
}

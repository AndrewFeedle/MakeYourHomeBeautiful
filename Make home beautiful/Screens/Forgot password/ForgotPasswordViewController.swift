//
//  ForgotPasswordViewController.swift
//  Make home beautiful
//
//  Created by Feedle on 13.07.2022.
//

protocol ForgotPasswordDelegate{
    
}

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var bottomConstrait: NSLayoutConstraint!
    @IBOutlet weak var resendMessage: UILabel!
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        emailTextField.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            NotificationCenter.default.removeObserver(self)
        }
    
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

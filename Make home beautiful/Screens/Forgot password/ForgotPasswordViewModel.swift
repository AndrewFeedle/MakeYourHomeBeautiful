//
//  ForgotPasswordViewModel.swift
//  Make home beautiful
//
//  Created by Feedle on 16.07.2022.
//

import Foundation

class ForgotPasswordViewModel{
    var delegate: ForgotPasswordDelegate?
    
    // Отправка ссылки восстановления пароля на почту
    func sendMailPressed(email: String){
        NotificationCenter.default.addObserver(self, selector: #selector(sendPasswordResetComplition(_:)), name: Notification.Name("sendPasswordResetComplition"), object: nil)
        FirebaseManager.sendPasswordReset(email: email)
    }
    
    // Обработка авторизации завершение
    @objc func sendPasswordResetComplition(_ notification: Notification){
        NotificationCenter.default.removeObserver(self, name: Notification.Name("sendPasswordResetComplition"), object: nil)
        let result = notification.userInfo!["result"] as! String
        if result != "sucsess"{
            delegate?.presentErrorAlert(title: "Ошибка", message: result)
        }
        else{
            delegate?.presentErrorAlert(title: "", message: "Ссылка для восстановления пароля отправлена на указанную почту")
        }
    }
}

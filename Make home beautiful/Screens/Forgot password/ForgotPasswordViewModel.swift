//
//  ForgotPasswordViewModel.swift
//  Make home beautiful
//
//  Created by Feedle on 16.07.2022.
//

import Foundation

class ForgotPasswordViewModel{
    // Отправка ссылки восстановления пароля на почту
    func sendMailPressed(email: String){
        if email == ""{
            NotificationCenter.default.post(name: NSNotification.Name("presentErrorAlert"), object: self, userInfo: ["title":"Ошибка","message":"Почта не должна быьт пустой"])
            return
        }
        NotificationCenter.default.addObserver(self, selector: #selector(sendPasswordResetComplition(_:)), name: Notification.Name("sendPasswordResetComplition"), object: nil)
        FirebaseManager.sendPasswordReset(email: email)
    }
    
    // Обработка авторизации завершение
    @objc private func sendPasswordResetComplition(_ notification: Notification){
        NotificationCenter.default.removeObserver(self)
        let result = notification.userInfo!["result"] as! String
        if result != "sucsess"{
            NotificationCenter.default.post(name: NSNotification.Name("presentErrorAlert"), object: self, userInfo: ["title":"Ошибка","message":result])
        }
        else{
            NotificationCenter.default.post(name: NSNotification.Name("presentErrorAlert"), object: self, userInfo: ["title":"","message":"Ссылка для восстановления пароля отправлена на указанную почту"])
        }
    }
}

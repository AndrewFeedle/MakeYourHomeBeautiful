//
//  RegisterViewDelegate.swift
//  Make home beautiful
//
//  Created by Feedle on 19.07.2022.
//

import Foundation

final class RegisterViewModel{
    // Регистрация нового пользователя
    func registerNewUser(name:String, email:String, password:String, passwordRe:String){
        // Проверка всех полей
        let errorTitle = "Ошибка регистрации"
        if name == "" || email == "" || password == "" || passwordRe == ""{
            NotificationCenter.default.post(name: NSNotification.Name("presentErrorAlert"), object: self, userInfo: ["title":errorTitle,"message":"Все поля должны быть заполнены"])
            return
        }
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", Constants.emailPredicateFormat)
        if !emailPredicate.evaluate(with: email){
            NotificationCenter.default.post(name: NSNotification.Name("presentErrorAlert"), object: self, userInfo: ["title":errorTitle,"message":"Неверный формат почты"])
            return
        }
        if password.count < 6{
            NotificationCenter.default.post(name: NSNotification.Name("presentErrorAlert"), object: self, userInfo: ["title":errorTitle,"message":"Длина пароля должна быть не менее 6 символов"])
            return
        }
        if password != passwordRe{
            NotificationCenter.default.post(name: NSNotification.Name("presentErrorAlert"), object: self, userInfo: ["title":errorTitle,"message":"Введенные пароли не совпадают"])
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterComplition(_:)), name: Notification.Name("RegisterComplition"), object: nil)
        FirebaseManager.createUser(email: email, password: password, name: name)
    }
    
    // Обработка регистрации завершение
    @objc func RegisterComplition(_ notification: Notification){
        NotificationCenter.default.removeObserver(self)
        let errorMessage = notification.userInfo!["error"] as! String
        if errorMessage != ""{
            NotificationCenter.default.post(name: NSNotification.Name("presentErrorAlert"), object: self, userInfo: ["title":"Ошибка регистрации","message":errorMessage])
        }
        else{
            NotificationCenter.default.post(name: NSNotification.Name("pushToHome"), object: self, userInfo: ["uid":notification.userInfo!["uid"] as! String])
        }
    }
}

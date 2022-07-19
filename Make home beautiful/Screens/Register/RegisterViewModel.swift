//
//  RegisterViewDelegate.swift
//  Make home beautiful
//
//  Created by Feedle on 19.07.2022.
//

import Foundation

protocol RegisterViewDelegate{
    func presentErrorAlert(title: String, message: String)
    func pushToHome(uid:String)
}

class RegisterViewModel{
    var delegate: RegisterViewDelegate?
    
    // Регистрация нового пользователя
    func registerNewUser(name:String, email:String, password:String, passwordRe:String){
        // Проверка всех полей
        let errorTitle = "Ошибка регистрации"
        if name == "" || email == "" || password == "" || passwordRe == ""{
            delegate?.presentErrorAlert(title: errorTitle, message: "Все поля должны быть заполнены")
            return
        }
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", Constants.emailPredicateFormat)
        if !emailPredicate.evaluate(with: email){
            delegate?.presentErrorAlert(title: errorTitle, message: "Неверный формат почты")
            return
        }
        if password.count < 6{
            delegate?.presentErrorAlert(title: errorTitle, message: "Длина пароля должна быть не менее 6 символов")
            return
        }
        if password != passwordRe{
            delegate?.presentErrorAlert(title: errorTitle, message: "Введенные пароли не совпадают")
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterComplition(_:)), name: Notification.Name("RegisterComplition"), object: nil)
        FirebaseManager.createUser(email: email, password: password, name: name)
    }
    
    // Обработка регистрации завершение
    @objc func RegisterComplition(_ notification: Notification){
        NotificationCenter.default.removeObserver(self, name: Notification.Name("RegisterComplition"), object: nil)
        let errorMessage = notification.userInfo!["error"] as! String
        if errorMessage != ""{
            delegate?.presentErrorAlert(title: "Ошибка регистрации", message: errorMessage)
        }
        else{
            delegate?.pushToHome(uid: notification.userInfo!["uid"] as! String)
        }
    }
}

//
//  LogInViewModel.swift
//  Make home beautiful
//
//  Created by Feedle on 15.07.2022.
//
import Foundation

final class LogInViewModel{
    
    // обработка авторизации
    func logIn(email:String, password:String){
        // Проверка заполненности полей
        let errorTitle = "Ошибка входа"
        if email == ""{
            NotificationCenter.default.post(name: Notification.Name("presentErrorAlert"), object: self, userInfo: ["title":errorTitle,"message":"Почта не должна быть пустой"])
            return
        }
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", Constants.emailPredicateFormat)
        if !emailPredicate.evaluate(with: email){
            NotificationCenter.default.post(name: Notification.Name("presentErrorAlert"), object: self, userInfo: ["title":errorTitle,"message":"Неверный формат почты"])
            return
        }
        if password == ""{
            NotificationCenter.default.post(name: Notification.Name("presentErrorAlert"), object: self, userInfo: ["title":errorTitle,"message":"Пароль не должен быть пустым"])
            return
        }
        if password.count < 6{
            NotificationCenter.default.post(name: Notification.Name("presentErrorAlert"), object: self, userInfo: ["title":errorTitle,"message":"Длина пароля должна быть не менее 6 символов"])
            return
        }
        
        // Попытка войти
        NotificationCenter.default.addObserver(self, selector: #selector(logInComplition(_:)), name: Notification.Name("logInComplition"), object: nil)
        FirebaseManager.authWithEmail(email: email, password: password)
    }
    
    // Обработка авторизации завершение
    @objc private func logInComplition(_ notification: Notification){
        NotificationCenter.default.removeObserver(self, name: Notification.Name("logInComplition"), object: nil)
        let errorMessage = notification.userInfo!["error"] as! String
        if errorMessage != ""{
            NotificationCenter.default.post(name: Notification.Name("presentErrorAlert"), object: self, userInfo: ["title":"Ошибка входа","message":errorMessage])
        }
        else{
            NotificationCenter.default.post(name: Notification.Name("pushToHome"), object: self, userInfo: ["uid":notification.userInfo!["uid"] as! String])
        }
    }
    
    // Попытка получить сохраненные данные пользователя и войти
    func tryLogIn(){
    let result:[String:String] = CryptoSnippets.getUsersLoginAndPassword()
        if result["error"] == ""{
            NotificationCenter.default.addObserver(self, selector: #selector(logInComplition(_:)), name: Notification.Name("logInComplition"), object: nil)
            FirebaseManager.authWithEmail(email: result["email"]!, password: result["password"]!)
        }else{
            NotificationCenter.default.post(name: Notification.Name("setScrollViewHidden"), object: self, userInfo: ["hide":false])
        }
    }
}

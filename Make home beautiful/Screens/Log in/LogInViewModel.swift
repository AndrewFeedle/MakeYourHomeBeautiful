//
//  LogInViewModel.swift
//  Make home beautiful
//
//  Created by Feedle on 15.07.2022.
//
import Foundation

protocol LogInDelegate{
    func presentErrorAlert(title:String, message:String)
    func pushToHome(uid:String)
}

class LogInViewModel{
    var delegate: LogInDelegate?
    
    // обработка авторизации
    func logIn(email:String, password:String){
        // Проверка заполненности полей
        let errorTitle = "Ошибка входа"
        if email.isEmpty{
            delegate?.presentErrorAlert(title: errorTitle, message: "Почта не должна быть пустой")
            return
        }
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", Constants.emailPredicateFormat)
        if !emailPredicate.evaluate(with: email){
            delegate?.presentErrorAlert(title: errorTitle, message: "Неверный формат почты")
            return
        }
        if password.isEmpty{
            delegate?.presentErrorAlert(title: errorTitle, message: "Пароль не должен быть пустым")
            return
        }
        if password.count < 6{
            delegate?.presentErrorAlert(title: errorTitle, message: "Длина пароля должна быть не менее 6 символов")
            return
        }
        
        // Попытка войти
        NotificationCenter.default.addObserver(self, selector: #selector(logInComplition(_:)), name: Notification.Name("logInComplition"), object: nil)
        FirebaseManager.authWithEmail(email: email, password: password)
        

    }
    
    // Обработка авторизации завершение
    @objc func logInComplition(_ notification: Notification){
        NotificationCenter.default.removeObserver(self, name: Notification.Name("logInComplition"), object: nil)
        let errorMessage = notification.userInfo!["error"] as! String
        if errorMessage != ""{
            delegate?.presentErrorAlert(title: "Ошибка входа", message: errorMessage)
        }
        else{
            delegate?.pushToHome(uid: notification.userInfo!["uid"] as! String)
        }
    }
}

//
//  LogInViewModel.swift
//  Make home beautiful
//
//  Created by Feedle on 15.07.2022.
//
import Foundation

protocol LogInDelegate{
    func presentErrorAlert(title:String, message:String)
    func pushToMain(uid:String)
}

class LogInViewModel{
    var delegate: LogInDelegate?
    
    // обработка авторизации
    func logIn(email:String, password:String){
        // Проверка заполненности полей
        if email.isEmpty{
            delegate?.presentErrorAlert(title: "Ошибка входа", message: "Почта не должна быть пустой")
            return
        }
        let emailPred = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        if !emailPred.evaluate(with: email){
            delegate?.presentErrorAlert(title: "Ошибка входа", message: "Неверный формат почты")
            return
        }
        if password.isEmpty{
            delegate?.presentErrorAlert(title: "Ошибка входа", message: "Пароль не должен быть пустым")
            return
        }
        if password.count < 6{
            delegate?.presentErrorAlert(title: "Ошибка входа", message: "Длина пароля должна быть не менее 6 символов")
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
            delegate?.pushToMain(uid: notification.userInfo!["uid"] as! String)
        }
    }
}

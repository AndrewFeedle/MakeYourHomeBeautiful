//
//  LogInViewModel.swift
//  Make home beautiful
//
//  Created by Feedle on 15.07.2022.
//
import Foundation

protocol LogInDelegate{
    func presentAlert(title:String, message:String)
}

struct LogInViewModel{
    var delegate: LogInDelegate?
    
    // обработка авторизации
    func logIn(email:String, password:String){
        // Проверка заполненности полей
        if email.isEmpty{
            delegate?.presentAlert(title: "zagolov", message: "message")
        }
    }
}

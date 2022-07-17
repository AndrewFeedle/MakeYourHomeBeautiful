//
//  FirebaseManager.swift
//  Make home beautiful
//
//  Created by Feedle on 15.07.2022.
//

import Foundation
import FirebaseAuth

struct FirebaseManager{
    
    // Авторизация пользователя
    static func authWithEmail(email:String, password:String){
        Auth.auth().signIn(withEmail: email, password: password) { authDataResault, error in
            var errorMessage: String?
            var uid: String?
            if let error = error{
                let errorDescription = error.localizedDescription
                if errorDescription.contains("There is no user record corresponding to this"){
                    errorMessage = "Пользователя с такой почтой и паролем не существует"
                }else{
                    errorMessage = errorDescription
                }
            }
            else{
                uid = authDataResault?.user.uid
            }
            
            let data: [String : Any] = ["error":errorMessage ?? "", "uid":uid ?? ""]
            NotificationCenter.default.post(name: Notification.Name("logInComplition"), object: self, userInfo: data)
        }
    }
    
    // Отправляет запрос на сброс пароля на указанную почту
    static func sendPasswordReset(email:String){
        var returnString = ["result":""]
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error{
                let resultMessage = error.localizedDescription
                if resultMessage.contains("There is no user record"){
                    returnString["result"] = "Пользователь с такой почтой не найден"
                }else{
                    returnString["result"] = resultMessage
                }
            }else{
                returnString["result"] = "sucsess"
            }
            NotificationCenter.default.post(name: Notification.Name("sendPasswordResetComplition"), object: self, userInfo: returnString)
        }
    }
}

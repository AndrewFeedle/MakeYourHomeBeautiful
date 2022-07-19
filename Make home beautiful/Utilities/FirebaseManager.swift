//
//  FirebaseManager.swift
//  Make home beautiful
//
//  Created by Feedle on 15.07.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct FirebaseManager{
    
    // Авторизация пользователя
    static func authWithEmail(email:String, password:String){
        Auth.auth().signIn(withEmail: email, password: password) { authDataResault, error in
            var data: [String : Any] = ["error":"", "uid":""]
            if let error = error{
                let errorDescription = error.localizedDescription
                if errorDescription.contains("There is no user record corresponding to this"){
                    data["error"] = "Пользователя с такой почтой и паролем не существует"
                }else{
                    data["error"] = errorDescription
                }
            }
            else{
                data["uid"] = authDataResault?.user.uid
            }

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
    
    // Создает нового пользователя
    static func createUser(email:String, password:String, name:String){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            var data: [String : Any] = ["error":"", "uid":""]
            if let error = error{
                let errorMessage = error.localizedDescription
                if errorMessage.contains("The email address is already"){
                    data["error"] = "Пользователь с такой почтой уже существует"
                }else{
                    data["error"] = errorMessage
                }
            }else{
                let uid = authResult?.user.uid ?? ""
                data["uid"] = uid
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: [
                    "uid": uid,
                    "name": name]) { error in
                    if let error = error {
                        data["error"] = error
                    }
                }
            }
            NotificationCenter.default.post(name: Notification.Name("RegisterComplition"), object: self, userInfo: data)
        }
    }
}

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
            if error != nil{
                if error!.localizedDescription.contains("There is no user record corresponding to this"){
                    errorMessage = "Пользователя с такой почтой и паролем не существует"
                }else{
                    errorMessage = error!.localizedDescription
                }
            }
            else{
                uid = authDataResault?.user.uid
            }
            
            let data: [String : Any] = ["error":errorMessage ?? "", "uid":uid ?? ""]
            NotificationCenter.default.post(name: Notification.Name("logInComplition"), object: nil, userInfo: data)
        }
    }
}

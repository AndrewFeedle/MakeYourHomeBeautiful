//
//  CryptoSnippets.swift
//  Make home beautiful
//
//  Created by Feedle on 21.07.2022.
//

import Foundation

struct CryptoSnippets{
    // Сохранение логина и пароля в связку ключей
    static func saveUsersLoginAndPassword(email:String, password:String){
        
        // Попытка обновить логин и пароль
        var query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: Constants.server]
        let attributes: [String: Any] = [kSecAttrAccount as String: email,
                                         kSecValueData as String: password.data(using: String.Encoding.utf8)!]
        var status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if status != errSecSuccess{
            // Если логин пароль не найдены, добавляем новые данные
            query = [kSecClass as String: kSecClassInternetPassword,
                                        kSecAttrAccount as String: email,
                                        kSecAttrServer as String: Constants.server,
                                        kSecValueData as String: password.data(using: String.Encoding.utf8)!]
            status = SecItemAdd(query as CFDictionary, nil)
        }else{
            return
        }
    }
    
    // Получение логина и пароля из связки ключей
    static func getUsersLoginAndPassword() -> [String:String]{
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                         kSecAttrServer as String: Constants.server,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status != errSecSuccess {
            return ["error":"true"]
        }
        guard let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let login = existingItem[kSecAttrAccount as String] as? String
        else {
            return ["error":"true"]
        }
        return ["email": login, "password":password,"error":""]
    }
}

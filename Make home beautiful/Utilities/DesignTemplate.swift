//
//  DesignTemplate.swift
//  Make home beautiful
//
//  Created by Feedle on 11.07.2022.
//
// Файл с шаблонами дизайна
import Foundation
import UIKit.UIView
import UIKit.UIButton

struct DesignTemplate{
    // Добавляет тень для UIView
    static func addShadow(object:UIView){
        object.layer.masksToBounds = false
        object.layer.shadowColor = UIColor.black.cgColor
        object.layer.shadowOpacity = 0.15
        object.layer.shadowOffset = .init(width: 0, height: 10)
        object.layer.shadowRadius = 20
    }
    
    // Добавляет тень для UIButton
    static func addShadow(object:UIButton){
        object.layer.masksToBounds = false
        object.layer.shadowColor = UIColor.black.cgColor
        object.layer.shadowOpacity = 0.3
        object.layer.shadowOffset = .init(width: 0, height: 10)
        object.layer.shadowRadius = 10
    }
}

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

struct DesignSnippets{
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
    
    // Добавляет градиент на задний фон
    static func addGradientToBackground(view:UIView, darkMode:Bool){
        let gradientlayer = CAGradientLayer()
        let secondColor = darkMode ?
            UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0).cgColor:
        UIColor(red: 50.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 1.0).cgColor
        gradientlayer.frame.size = view.frame.size
        gradientlayer.colors = [UIColor.systemBackground.cgColor, secondColor]
        gradientlayer.startPoint = CGPoint(x: 0.0, y: 0.9)
        gradientlayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        if view.layer.sublayers?.count ?? 0 > 0{
            view.layer.replaceSublayer(view.layer.sublayers![0], with: gradientlayer)
        }
        else{
            view.layer.addSublayer(gradientlayer)
        }
        
    }
}

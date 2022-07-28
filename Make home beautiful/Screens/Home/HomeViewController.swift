//
//  HomeViewController.swift
//  Make home beautiful
//
//  Created by Feedle on 23.07.2022.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var chipCollectionView: UICollectionView!
    var filters = filterMasive
    var uid:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Меняет стиль иконки таббара при выделении
        tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        // Добавляет градиент на задний фон
        DesignSnippets.addGradientToBackground(view: backgroundView, darkMode: traitCollection.userInterfaceStyle == .dark ? false:true)
        chipCollectionView.dataSource = self
        chipCollectionView.delegate = self
        
    }
    
    // При смене темы
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        DesignSnippets.addGradientToBackground(view: backgroundView, darkMode: previousTraitCollection?.userInterfaceStyle == .light ? false:true) 
    }
}

//MARK: - Настройка фильтров
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    // Количество фильтров
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    // Натсройка элемента фильтра
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = chipCollectionView.dequeueReusableCell(withReuseIdentifier: "chip", for: indexPath) as! ChipViewCell
        cell.background.layer.cornerRadius = 10
        cell.imageView.image = UIImage(named: filters[indexPath.row].image + "-gray.svg")
        cell.titleLabel.text = filters[indexPath.row].text
        if filters[indexPath.row].isSelected{
            UIView.animate(withDuration: Constants.animationDuration) {
                cell.background.backgroundColor = UIColor.label
                cell.titleLabel.textColor = UIColor.label
            }
            cell.imageView.image = UIImage(named: filters[indexPath.row].image + ".svg")
        }else{
            //UIView.animate(withDuration: Constants.animationDuration) {
            cell.background.backgroundColor = UIColor.systemGray6
            cell.titleLabel.textColor = UIColor.systemGray
            //}
            cell.imageView.image = UIImage(named: filters[indexPath.row].image + "-gray.svg")
        }
        
        return cell
    }
    
    // Количество строк
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //  При выделении фильтра
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for item in 0...filters.count - 1{
            filters[item].isSelected = false
        }
        filters[indexPath.row].isSelected = true
        chipCollectionView.reloadData()
    }
}

//
//  HomeViewController.swift
//  Make home beautiful
//
//  Created by Feedle on 23.07.2022.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var furnitureCollectionView: UICollectionView!
    private var filters = filterMasive
    
    private var furniturelist = [Furniture(name: "test name 1", price: 100),Furniture(name: "test name 2", price: 100),Furniture(name: "test name 3", price: 100),Furniture(name: "test name 4", price: 100),Furniture(name: "test name 5", price: 100),Furniture(name: "test name 6", price: 100)]
    
    var uid:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Меняет стиль иконки таббара при выделении
        tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        // Добавляет градиент на задний фон
        DesignSnippets.addGradientToBackground(view: backgroundView, darkMode: traitCollection.userInterfaceStyle == .dark ? false:true)
        filtersCollectionView.dataSource = self
        filtersCollectionView.delegate = self
        furnitureCollectionView.dataSource = self
        furnitureCollectionView.delegate = self
}
    
    // При смене темы
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        DesignSnippets.addGradientToBackground(view: backgroundView, darkMode: previousTraitCollection?.userInterfaceStyle == .light ? false:true) 
    }
}

//MARK: - Настройка фильтров и мебели
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    // Количество элементов
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filtersCollectionView{
            return filters.count
        }else{
           return furniturelist.count
        }
    }
    
    // Натсройка элементов
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filtersCollectionView{
            // Натсройка элемента фильтра
            let cell = filtersCollectionView.dequeueReusableCell(withReuseIdentifier: "chip", for: indexPath) as! ChipViewCell
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
            // Натсройка элемента мебели
        }else{
            let cell = furnitureCollectionView.dequeueReusableCell(withReuseIdentifier: "furniture", for: indexPath) as! FurnitureCollectionViewCell
            cell.label.text = furniturelist[indexPath.row].name
            cell.price.text = "\(furniturelist[indexPath.row].price)₽"
            cell.photo.layer.cornerRadius = 10
            cell.bagView.background.layer.cornerRadius = 10
            cell.bagView.background.alpha = 0.5
            return cell
        }
    }
    
    // Количество секций
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
    }
    
    //  При выделении фильтра
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filtersCollectionView{
            for item in 0...filters.count - 1{
                filters[item].isSelected = false
            }
            filters[indexPath.row].isSelected = true
            filtersCollectionView.reloadData()
        }
    }
    
    // Настройка размера ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        // ячейка мебели
        if collectionView == furnitureCollectionView{
            if screenWidth >= 360{
                return CGSize(width: 160, height: 250)
            }else{
                let cellWidth = screenWidth / 2.8
                return CGSize(width: cellWidth, height: cellWidth * 1.56)
            }
            // ячейка фильтра
        }else{
            if screenWidth >= 360{
                return CGSize(width: 60, height: 80)
            }else{
                return CGSize(width: 50, height: 70)
            }
        }
    }
    
    // Отступы ячеек
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == furnitureCollectionView{
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }else{
            return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
    }
}

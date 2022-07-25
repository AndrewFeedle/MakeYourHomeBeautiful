//
//  HomeViewController.swift
//  Make home beautiful
//
//  Created by Feedle on 23.07.2022.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var chipCollectionView: UICollectionView!
    let chips: [String] = ["1","2"]
    var uid:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Меняет стиль иконки таббара при выделении
        tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        // Добавляет градиент на задний фон
        DesignSnippets.addGradientToBackground(view: backgroundView)
        chipCollectionView.dataSource = self
//        chipCollectionView.register(UINib(nibName: "chip", bundle: nil), forCellWithReuseIdentifier: "chip")
    }
}

extension HomeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return chipCollectionView.dequeueReusableCell(withReuseIdentifier: "chip", for: indexPath) as! ChipViewCell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return chips.count + 10
    }
}

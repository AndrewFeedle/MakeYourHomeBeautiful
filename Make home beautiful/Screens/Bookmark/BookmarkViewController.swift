//
//  BookmarkViewController.swift
//  Make home beautiful
//
//  Created by Feedle on 24.07.2022.
//

import UIKit

class BookmarkViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Меняет стиль иконки таббара при выделении
        tabBarItem.selectedImage = UIImage(systemName: "bookmark.fill")
        // Добавляет градиент на задний фон
        DesignSnippets.addGradientToBackground(view: backgroundView, darkMode: traitCollection.userInterfaceStyle == .dark ? false:true)
    }
    
    // При смене темы
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        DesignSnippets.addGradientToBackground(view: backgroundView, darkMode: previousTraitCollection?.userInterfaceStyle == .light ? false:true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

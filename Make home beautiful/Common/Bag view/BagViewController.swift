//
//  BagViewController.swift
//  Make home beautiful
//
//  Created by Feedle on 29.07.2022.
//

import UIKit

class BagViewController: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var bag: UIImageView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    private func configureView(){
        let bundle = Bundle(for: BagViewController.self)
        bundle.loadNibNamed(String(describing: "BagView"), owner: self, options: nil)
        addSubview(contentView)
    }

}

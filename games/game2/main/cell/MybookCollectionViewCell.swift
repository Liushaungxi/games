//
//  MybookCollectionViewCell.swift
//  games
//
//  Created by liushungxi on 2018/9/27.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit

class MybookCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var selectedButton: UIButton!
    @IBAction func selectedButtonAction(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var boxWeight: NSLayoutConstraint!
    @IBOutlet weak var boxHight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        boxWeight.constant = UIScreen.main.bounds.width/3
        boxHight.constant = UIScreen.main.bounds.width/2
        
    }

}

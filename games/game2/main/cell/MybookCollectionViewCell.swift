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
        sender.isSelected = !sender.isSelected
    }
    var block:(()->Void)?
    @objc func delectBtn(_ sender: UIGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began{
            block?()
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var boxWeight: NSLayoutConstraint!
    @IBOutlet weak var boxHight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(delectBtn(_:)))
        tap.minimumPressDuration = 1
        tap.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tap)
    }

}

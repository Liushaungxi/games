//
//  ContentTitleTableViewCell.swift
//  games
//
//  Created by liushungxi on 2018/9/25.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit

class ContentTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var boxWeight: NSLayoutConstraint!
    @IBOutlet weak var boxHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        boxHeight.constant = UIScreen.main.bounds.height
        boxWeight.constant = UIScreen.main.bounds.width
    }
    var blockLeft:(()->Void)?
    var blockRight:(()->Void)?
    var blockCenter:((Bool)->Void)?
    @IBAction func leftButton(_ sender: UIButton) {
        blockLeft?()
    }
    @IBAction func centerButton(_ sender: UIButton) {
        blockCenter?(sender.isSelected)
        sender.isSelected = !sender.isSelected
    }
    @IBAction func rightButton(_ sender: UIButton) {
        blockRight?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

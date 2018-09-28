//
//  ContentTableViewCell.swift
//  games
//
//  Created by liushungxi on 2018/9/21.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit

class ContentTableViewCell: UITableViewCell {
    var blockLeft:(()->Void)?
    var blockRight:(()->Void)?
    var blockCenter:((Bool)->Void)?
    @IBOutlet weak var contentLabel: UILabel!
    var textSize = 17
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
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

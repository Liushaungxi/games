//
//  Game2048BaseViewBox.swift
//  games
//
//  Created by liushungxi on 2018/9/17.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit
let images = [#imageLiteral(resourceName: "a-nil"),#imageLiteral(resourceName: "a-2"),#imageLiteral(resourceName: "a-4"),#imageLiteral(resourceName: "a-8"),#imageLiteral(resourceName: "a-16"),#imageLiteral(resourceName: "a-32"),#imageLiteral(resourceName: "a-64"),#imageLiteral(resourceName: "a-128"),#imageLiteral(resourceName: "a-256"),#imageLiteral(resourceName: "a-512"),#imageLiteral(resourceName: "a-1024"),#imageLiteral(resourceName: "a-2048")]
class Game2048BaseViewBox: UIView {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "a-nil"))
    var imageIndex = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(3)
            make.right.bottom.equalToSuperview().offset(-3)
        }
        self.backgroundColor = UIColor.clear
    }
    func reloadImage(_ index:Int) {
        imageIndex = index
        imageView.image = images[imageIndex]
    }
    func reloadImagejiaOne() {
        imageIndex += 1
        imageView.image = images[imageIndex]
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.transform = CGAffineTransform.identity
                .scaledBy(x: 0.5, y: 0.5)
        }, completion: { (_) in
            UIView.animate(withDuration: 0.5) {
                self.imageView.transform = CGAffineTransform.identity
                    .scaledBy(x: 1, y: 1)
            }
        })
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

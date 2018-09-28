//
//  TempMainViewController.swift
//  games
//
//  Created by liushungxi on 2018/9/27.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit

class TempMainViewController: UIViewController {

    let viewBox = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        view.addSubview(viewBox)
        viewBox.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(44)
        }
        let vc = MainViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.isHidden = true
        addMyChidVc(nav, box: viewBox)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

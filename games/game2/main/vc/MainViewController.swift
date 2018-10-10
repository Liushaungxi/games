//
//  MainViewController.swift
//  games
//
//  Created by liushungxi on 2018/9/26.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class MainViewController: ButtonBarPagerTabStripViewController {
    
    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = UIColor.white
        settings.style.selectedBarHeight = 2
        settings.style.buttonBarItemFont = .systemFont(ofSize: 14)
        settings.style.buttonBarHeight = 40
        settings.style.buttonBarItemTitleColor = UIColor.red
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        settings.style.selectedBarBackgroundColor = UIColor.red
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = UIColor.red
        }
        super.viewDidLoad()
//        containerView.panGestureRecognizer.require(toFail: appMainVc.panRecognizer)
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let vc1 = NewMybooksViewController()
        vc1.titles.title = "我的书架"
        
        let vc2 = WebsTableViewController()
        vc2.titles.title = "精品书城"
        return [vc1,vc2]
    }
}

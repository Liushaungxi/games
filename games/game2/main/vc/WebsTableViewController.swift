//
//  WebsTableViewController.swift
//  games
//
//  Created by liushungxi on 2018/9/26.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit
import SwiftTheme
import XLPagerTabStrip
class WebsTableViewController: UITableViewController,IndicatorInfoProvider {
    var titles:IndicatorInfo = ""
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return titles
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    var webs = [KfWebTitle]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCell(cell: WebTableViewCell.self)
        
        let web = KfWebTitle()
        web.headImage = #imageLiteral(resourceName: "a01")
        web.name = "笔趣阁"
        web.url = "https://www.biqudao.com"
        webs.append(web)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webs.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WebTableViewCell", for: indexPath) as! WebTableViewCell
        cell.headImage.image = webs[indexPath.row].headImage ?? #imageLiteral(resourceName: "a05")
        cell.nameLabel.text = webs[indexPath.row].name
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MainNavgationViewController()
        vc.mainUrl = webs[indexPath.row].url
        vc.navigationController?.navigationBar.isHidden = false
        navigationController?.pushViewController(vc, animated: true)
    }
}

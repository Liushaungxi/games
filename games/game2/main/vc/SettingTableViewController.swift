//
//  SettingTableViewController.swift
//  games
//
//  Created by liushungxi on 2018/10/10.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCell(cell: SettingTableViewCell.self)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
            var fileArray = File.getPathFileDetailList(folder: "/data")
            fileArray += File.getPathFileDetailList(folder: "/img")
            var size:Int = 0
            for item in fileArray {
                let manager = FileManager.default
                let attributes = try? manager.attributesOfItem(atPath: (item.path))
                size += attributes![FileAttributeKey.size]! as! Int
            }
            cell.contentLabel.text = "清理缓存:\(size/1000) KB"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
            cell.contentLabel.text = "小游戏"
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            queue.async {
                File.delAllFile(folderName: "/data")
                File.delAllFile(folderName: "/img")
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            }
        case 1:
            self.present(Game2048ViewController(), animated: true, completion: nil)
        default:
            break
        }
    }
    let queue = DispatchQueue(label: "delDispatch", qos: DispatchQoS.background)
}

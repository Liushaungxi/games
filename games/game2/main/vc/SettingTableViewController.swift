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
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        queue.async {
            File.delAllFile(folderName: "/data")
            File.delAllFile(folderName: "/img")
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }
    let queue = DispatchQueue(label: "delDispatch", qos: DispatchQoS.background)
}

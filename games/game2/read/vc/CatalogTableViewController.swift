//
//  CatalogTableViewController.swift
//  games
//
//  Created by liushungxi on 2018/9/26.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit
import Kanna
class CatalogTableViewController: UITableViewController {

    
    var catalog = [KfCatalog]()
    var currentUrl = "https://www.biqudao.com/bqge114445/"{
        didSet{
            getCatalog(currentUrl)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCell(cell: CatalogTableViewCell.self)
    }
    let queue = DispatchQueue(label: "catalog")
    var chapterUrl = ""
    func getCatalog(_ url:String) {
        queue.async {
            print(self.currentUrl)
            starePrompt("获取数据中...")
            let tempMyBook = KfMybook()
            let str = try! String.init(contentsOf: URL(string: self.currentUrl)!)
            tempMyBook.title = filterStr(str: str, befor: "<span class=\"title\">", after: "</span>")
            tempMyBook.image = filterStr(str: str, befor: "<img src=\"https://", after: "\" onerror=")
            self.chapterUrl = self.currentUrl + "all.html"
            tempMyBook.catalog = self.chapterUrl
            mybook.append(tempMyBook)
            
            var tempUrl = self.chapterUrl.replacingOccurrences(of: "/", with: "")
            tempUrl = tempUrl.replacingOccurrences(of: ":", with: "")
            tempUrl = tempUrl.replacingOccurrences(of: ".", with: "")
            if File.fileIsExist(fileName: "data/\(tempUrl).txt"){
                let tempContent = File.readFile(fileName: "\(tempUrl).txt", filePathName: "data/")
                if let hasValue = [KfCatalog].deserialize(from:  tempContent){
                    self.catalog = hasValue.compactMap({$0})
                    DispatchQueue.main.async {
                        endPrompt()
                        self.tableView.reloadData()
                    }
                }else{
                    print("错误")
                }
            }else{
                if let doc = try? HTML(url: URL(string: self.chapterUrl)!, encoding: .utf8){
                    var bool = true
                    for item in doc.css("a"){
                        if let text = item.text{
                            if text.hasPrefix("第一章"){
                                bool = false
                            }
                            if bool{
                                continue
                            }else{
                                if text.hasPrefix("第") {
                                    let tempCatalog = KfCatalog()
                                    tempCatalog.title = item.text ?? ""
                                    tempCatalog.url = item["href"] ?? ""
                                    self.catalog.append(tempCatalog)
                                }
                            }
                        }
                    }
                }
                File.createFile(fileName: "\(tempUrl).txt", filePathName: "data/")
                File.writeFile(fileName: "\(tempUrl).txt", filePathName: "data/", content: self.catalog.toJSONString() ?? "")
                DispatchQueue.main.async {
                    endPrompt()
                    self.tableView.reloadData()
                }
                
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catalog.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatalogTableViewCell", for: indexPath) as! CatalogTableViewCell
        cell.titleLabel.text = catalog[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ReadContentNewViewController()
        vc.currentUrl = baseUrl + catalog[indexPath.row].url
        vc.data.catalog = chapterUrl
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

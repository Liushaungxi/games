//
//  ReadContentNewViewController.swift
//  games
//
//  Created by liushungxi on 2018/9/28.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit
import SwiftTheme
import Kanna
var tableViewRows = 22 // 19  22
var tableViewFont = 17 // 26  21
class ReadContentNewViewController:UIViewController,UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isMain{
            return 1
        }else{
            return tableViewRows
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isMain {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell", for: indexPath) as! ContentTableViewCell
            cell.contentLabel.font = UIFont.systemFont(ofSize: CGFloat(tableViewFont))
            if isNight{
                cell.theme_backgroundColor = ["#000","#fff"]
                cell.contentLabel.theme_textColor = ["#fff","#000"]
            }else{
                cell.theme_backgroundColor = ["#fff","#000"]
                cell.contentLabel.theme_textColor = ["#000","#fff"]
            }
            cell.contentLabel.text = data.content[indexPath.row+index]
            cell.blockRight = {[unowned self]()in
                self.index += tableViewRows
                if self.index <= self.data.content.count-1{
                    self.save()
                    self.tableView.reloadData()
                }else{
                    self.chapterIndex += 1
                    self.index = 0
                    self.isMain = true
                    self.currentUrl = self.baseUrl + self.data.nextUrl
                }
            }
            cell.blockCenter = {[unowned self](bool)in
                self.clickCenter(bool)
            }
            cell.blockLeft = {[unowned self]()in
                self.index -= tableViewRows
                if self.index >= 0{
                    self.save()
                    self.tableView.reloadData()
                }else{
                    self.index = 0
                    self.isMain = true
                    self.save()
                    self.tableView.reloadData()
                }
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentTitleTableViewCell", for: indexPath) as! ContentTitleTableViewCell
            cell.titleLabel.text = data.title
            if isNight{
                cell.theme_backgroundColor = ["#000","#fff"]
                cell.backView.theme_backgroundColor = ["#000","#fff"]
                cell.titleLabel.theme_textColor = ["#fff","#000"]
            }else{
                cell.theme_backgroundColor = ["#fff","#000"]
                cell.backView.theme_backgroundColor = ["#fff","#000"]
                cell.titleLabel.theme_textColor = ["#000","#fff"]
            }
            cell.blockRight = {[unowned self]()in
                self.isMain = false
                self.save()
                self.tableView.reloadData()
            }
            cell.blockCenter = {[unowned self](bool)in
                self.clickCenter(bool)
            }
            cell.blockLeft = {[unowned self]()in
                self.chapterIndex += 1
                self.isLeft = true
                self.currentUrl = self.baseUrl + self.data.parUrl
            }
            return cell
        }
    }
    func clickCenter(_ bool:Bool){
        topView.isHidden = bool
        bottonView.isHidden = bool
        dayAndNightBotton.isHidden = bool
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    var isLeft = false
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottonView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var index = 0
    var data = KfContent()
    var isMain = true
    var baseUrl = "https://www.biqudao.com"
    var currentUrl = "https://www.biqudao.com/bqge114445/6592413.html"{
        didSet{
            if tableView == nil{
                return
            }
            save()
            readContent()
        }
    }

    func save() {
        for item in mybook{
            if item.catalog == data.catalog{
                item.currentChapter = currentUrl
                item.currentIndex = index
                item.chapterIndex = chapterIndex
            }
        }
    }
    let queue = DispatchQueue(label: "content")
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.isContinuous = false
        fontIndex = Int(readUserDefaultsLoginData(getDataName: getDataNames.fontIndex.rawValue) ?? "") ?? 0
        tableViewRows = tabviewRows[fontIndex]
        tableViewFont = tabViewFont[fontIndex]

        clickCenter(true)
        tableView.isScrollEnabled = false
        tableView.registerCell(cell: ContentTableViewCell.self)
        tableView.registerCell(cell: ContentTitleTableViewCell.self)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        readContent()
    }
    func isLefts(){
        if self.isLeft{
            self.isMain = false
            self.isLeft = false
            self.index = data.content.count-tableViewRows
        }
    }
    func readContent(){
        queue.async {[unowned self]()in
            starePrompt("数据获取中...")
            var tempUrl = self.currentUrl.replacingOccurrences(of: "/", with: "")
            tempUrl = tempUrl.replacingOccurrences(of: ":", with: "")
            tempUrl = tempUrl.replacingOccurrences(of: ".", with: "")
            if File.fileIsExist(fileName: "data/\(tempUrl).txt"){
                let tempContent = File.readFile(fileName: "\(tempUrl).txt", filePathName: "data/")
                if let hasValue = KfContent.deserialize(from:  tempContent){
                    self.data = hasValue
                    DispatchQueue.main.async {
                        self.isLefts()
                        endPrompt()
                        self.titleLabel.text = self.data.title
                        self.tableView.reloadData()
                    }
                }else{
                    print("错误")
                }
            }else{
                let tempData = findContent(self.currentUrl)
                self.data.content = tempData.content
                self.data.nextUrl = tempData.nextUrl
                self.data.parUrl = tempData.parUrl
                self.data.title = tempData.title
                File.createFile(fileName: "\(tempUrl).txt", filePathName: "data/")
                File.writeFile(fileName: "\(tempUrl).txt", filePathName: "data/", content: self.data.toJSONString() ?? "")
                DispatchQueue.main.async {
                    self.isLefts()
                    endPrompt()
                    self.titleLabel.text = self.data.title
                    self.tableView.reloadData()
                }
            }
        }
    }
    let downQueue = DispatchQueue(label: "downAll",qos:DispatchQoS.background)
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func downLoadButton(_ sender: UIButton) {
        let alter = UIAlertController(title: "下载", message: "请选择你要下载的章数", preferredStyle: .alert)
        let chapter10 = UIAlertAction(title: "10章", style: .default) { (_) in
            self.downChapter(10)
        }
        let chapter50 = UIAlertAction(title: "50章", style: .default) { (_) in
            self.downChapter(50)
        }
        let chapterAll = UIAlertAction(title: "后面全部", style: .default) { (_) in
            self.downChapter(100000)
        }
        alter.addAction(chapter10)
        alter.addAction(chapter50)
        alter.addAction(chapterAll)
        self.present(alter, animated: true, completion: nil)
    }
    func downChapter(_ number:Int){
        downQueue.async {
            let tempDatas = self.data
            for _ in 0..<number{
                if tempDatas.nextUrl.isEmpty{
                    break
                }
                var tempUrl = (self.baseUrl + tempDatas.nextUrl).replacingOccurrences(of: "/", with: "")
                tempUrl = tempUrl.replacingOccurrences(of: ":", with: "")
                tempUrl = tempUrl.replacingOccurrences(of: ".", with: "")
                if File.fileIsExist(fileName: "data/\(tempUrl)"){
                    continue
                }
                let tempData = findContent(self.baseUrl + tempDatas.nextUrl)
                tempDatas.content = tempData.content
                tempDatas.nextUrl = tempData.nextUrl
                tempDatas.parUrl = tempData.parUrl
                tempDatas.title = tempData.title
                File.createFile(fileName: "\(tempUrl).txt", filePathName: "data/")
                File.writeFile(fileName: "\(tempUrl).txt", filePathName: "data/", content: self.data.toJSONString() ?? "")
            }
        }
    }
    @IBAction func parChapterButton(_ sender: UIButton) {
        currentUrl = baseUrl + data.parUrl
    }
    @IBAction func nextChapterButton(_ sender: UIButton) {
        currentUrl = baseUrl + data.nextUrl
    }
    @IBAction func catalogButton(_ sender: UIButton) {
        let vc = CatalogTableViewController()
        vc.isBack = true
        vc.currentUrl = data.catalog
        vc.isBackBlock = { url in
            self.isMain = true
            self.getcatalogs(self.data.catalog)
            self.index = 0
            self.currentUrl = url
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    var tabviewRows = [22,22,19]
    var tabViewFont = [17,21,26]
    var fontIndex = 0
    @IBAction func fontButton(_ sender: UIButton) {
        fontIndex += 1
        if fontIndex == tabviewRows.count-1{
            fontIndex = 0
        }
        tableViewRows = tabviewRows[fontIndex]
        tableViewFont = tabViewFont[fontIndex]
        saveUserDefaultsData(data: "\(fontIndex)", getDataName: getDataNames.fontIndex.rawValue)
        File.delAllFile(folderName: "data")
        readContent()
    }
    @IBAction func lightButton(_ sender: UIButton) {
    }
    @IBAction func otherButton(_ sender: UIButton) {
    }
    var isNight = false
    @IBOutlet weak var dayAndNightBotton: UIButton!
    @IBAction func dayAndNightButton(_ sender: UIButton) {
        dayAndNightBotton.isSelected = !dayAndNightBotton.isSelected
        isNight = dayAndNightBotton.isSelected
        tableView.reloadData()
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBAction func sliderChange(_ sender: UISlider) {
        let tempIndex = sender.value*Float(catalogs.count)
        currentUrl = baseUrl + catalogs[Int(tempIndex)].url
    }
    var catalogs = [KfCatalog](){
        didSet{
            findChapterIndex()
        }
    }
    var chapterIndex = 0{
        didSet{
            DispatchQueue.main.async {
                self.slider.value = Float(self.chapterIndex)/Float(self.catalogs.count)
            }
        }
    }
    func findChapterIndex(){
        downQueue.async {
            for (index,item) in self.catalogs.enumerated(){
                if (self.baseUrl + item.url) == self.currentUrl{
                    self.chapterIndex = index
                }
            }
        }
    }
    func getcatalogs(_ str:String){
        downQueue.async {
            var tempcatalogs = [KfCatalog]()
            var tempUrl = ""
            tempUrl = str + "all.html"
            tempUrl = tempUrl.replacingOccurrences(of: "/", with: "")
            tempUrl = tempUrl.replacingOccurrences(of: ":", with: "")
            tempUrl = tempUrl.replacingOccurrences(of: ".", with: "")
            if File.fileIsExist(fileName: "data/\(tempUrl).txt"){
                let tempContent = File.readFile(fileName: "\(tempUrl).txt", filePathName: "data/")
                if let hasValue = [KfCatalog].deserialize(from:  tempContent){
                    tempcatalogs = hasValue.compactMap({$0})
                    self.catalogs = tempcatalogs
                }else{
                    print("错误")
                }
            }else{
                if let doc = try? HTML(url: URL(string: str + "all.html")!, encoding: .utf8){
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
                                    tempcatalogs.append(tempCatalog)
                                }
                            }
                        }
                    }
                    self.catalogs = tempcatalogs
                }
            }

        }
    }
    
}

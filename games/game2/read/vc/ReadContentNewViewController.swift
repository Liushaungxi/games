//
//  ReadContentNewViewController.swift
//  games
//
//  Created by liushungxi on 2018/9/28.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit

class ReadContentNewViewController:UIViewController,UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isMain{
            return 1
        }else{
            return 22
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isMain {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell", for: indexPath) as! ContentTableViewCell
            cell.contentLabel.text = data.content[indexPath.row+index]
            cell.blockRight = {[unowned self]()in
                self.index += 22
                if self.index <= self.data.content.count-1{
                    self.save()
                    self.tableView.reloadData()
                }else{
                    self.index = 0
                    self.isMain = true
                    self.currentUrl = self.baseUrl + self.data.nextUrl
                }
            }
            cell.blockCenter = {[unowned self](bool)in
                self.clickCenter(bool)
            }
            cell.blockLeft = {[unowned self]()in
                self.index -= 22
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
            cell.blockRight = {[unowned self]()in
                self.isMain = false
                self.save()
                self.tableView.reloadData()
            }
            cell.blockCenter = {[unowned self](bool)in
                self.clickCenter(bool)
            }
            cell.blockLeft = {[unowned self]()in
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
    var textSize = Int((UIScreen.main.bounds.height-78)/22)
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
    let queueSave = DispatchQueue(label: "save", qos: DispatchQoS.background)
    func save() {
        for item in mybook{
            if item.catalog == data.catalog{
                item.currentChapter = currentUrl
                item.currentIndex = index
            }
        }
    }
    let queue = DispatchQueue(label: "content")
    override func viewDidLoad() {
        super.viewDidLoad()
        clickCenter(true)
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
            self.index = data.content.count-22
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
                    self.tableView.reloadData()
                }
            }
        }
    }

    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func downLoadButton(_ sender: UIButton) {
    }
    @IBAction func parChapterButton(_ sender: UIButton) {
        currentUrl = baseUrl + data.parUrl
    }
    @IBAction func nextChapterButton(_ sender: UIButton) {
        currentUrl = baseUrl + data.nextUrl
    }
    @IBAction func catalogButton(_ sender: UIButton) {
    }
    @IBAction func fontButton(_ sender: UIButton) {
    }
    @IBAction func lightButton(_ sender: UIButton) {
    }
    @IBAction func otherButton(_ sender: UIButton) {
    }
    @IBOutlet weak var dayAndNightBotton: UIButton!
    @IBAction func dayAndNightButton(_ sender: UIButton) {
    }
    @IBAction func sliderChange(_ sender: UISlider) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

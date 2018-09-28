//
//  tuozhan.swift
//  games
//
//  Created by liushungxi on 2018/9/21.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit
import PKHUD
import Alamofire
extension UITableView{
    func registerCell(cell:UITableViewCell.Type){
        let nib = UINib.init(nibName: "\(cell)", bundle: nil)
        self.register(nib, forCellReuseIdentifier: "\(cell)")
    }
}
extension UICollectionView{
    func registerCell(cell:UICollectionViewCell.Type){
        let nib = UINib.init(nibName: "\(cell)", bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: "\(cell)")
    }
}
func filterStr(str:String,befor:String,after:String)->String{
    let scanner = Scanner.init(string: str)
    var text:NSString? = ""
    while scanner.isAtEnd==false {
        scanner.scanUpTo(befor, into: nil)
        scanner.scanUpTo(after, into: &text)
    }
    var tempTitle = String(describing: text)
    tempTitle = tempTitle.replacingOccurrences(of: "Optional(\(befor)", with: "")
    tempTitle = tempTitle.replacingOccurrences(of: "Optional(\(after)", with: "")
    tempTitle.removeLast()
    return tempTitle
}
func findContent(_ url:String)->(title:String,nextUrl:String,parUrl:String,content:[String]){
    let str = try! String.init(contentsOf: URL(string: url)!)
    let tempTitle = filterStr(str: str, befor: "<h1>", after: "</h1>")
    let tempNextUrl = filterStr(str: str, befor: "章节列表</a> &rarr; <a href=\"", after: "\" target=\"_top\" class=\"next\">下一章")
    let tempPraUrl = filterStr(str: str, befor: "加入书签</a> <a href=\"", after: "\" target=\"_top\" class=\"pre\">上一章")
    var tempText = filterStr(str: str, befor: "<div id=\"content\">", after: "<script>chaptererror();</script>")
    tempText = tempText.replacingOccurrences(of: "\r\n\t\t\t\t", with: "")
    tempText = tempText.replacingOccurrences(of: "<br/><br/>", with: "\n\n")
    tempText = tempText.replacingOccurrences(of: "<br/>", with: "\n")
    tempText = tempText.replacingOccurrences(of: "&nbsp;", with: " ")
    var i = 0
    var texts = [String]()
    var temp = ""
    for (index,char) in tempText.enumerated(){
        if char == "\n"{
            i = 0
            texts.append(temp)
            temp.removeAll()
            continue
        }
        if i == 20{
            i = 0
            texts.append(temp)
            temp.removeAll()
        }
        temp.append(char)
        i += 1
        if index == tempText.count-1{
            texts.append(temp)
        }
    }
    let buqi = texts.count%22
    if buqi == 0{
        return (tempTitle,tempNextUrl,tempPraUrl,texts)
    }
    for _ in 0..<(22-buqi) {
        texts.append(" ")
    }
    return (tempTitle,tempNextUrl,tempPraUrl,texts)
}


func getHtmlTitle(_ str:NSString){
    let regex = try? NSRegularExpression.init(pattern: "(?<=dd\\>).*(?=</dd)", options: NSRegularExpression.Options(rawValue: 0))
    if regex != nil{
        let first = regex?.firstMatch(in: str as String, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, str.length))
        if (first != nil){
            let resultRange = first?.range(at: 0)
            let result = str.substring(with: resultRange!)
            print("\(result)")
        }
    }
    
}

func starePrompt(_ msg:String) {
    DispatchQueue.main.async {
        HUD.show(.label(msg))
    }
}
func endPrompt(){
    DispatchQueue.main.async {
        HUD.hide()
    }
}
extension UIViewController{
    func addMyChidVc(_ vc:UIViewController, box:UIView) {
        vc.willMove(toParentViewController: self)
        box.addSubview(vc.view)
        vc.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.addChildViewController(vc)
        vc.didMove(toParentViewController: self)
    }
}
func downloadImg(_ url:String,_ myBookIndex:Int)->String{
    var name = url
    name = name.replacingOccurrences(of: "/", with: "")
    name = name.replacingOccurrences(of: ":", with: "")
    name = name.replacingOccurrences(of: ".", with: "")
    
    let destination:DownloadRequest.DownloadFileDestination = { _ , _ in
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("img/\(name).jpg")
        //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
        return (fileURL, [.createIntermediateDirectories])
    }
    if File.fileIsExist(fileName: "img/\(name).jpg"){
        return "img/\(name).jpg"
    }
    Alamofire.download(url, to: destination)
        .response { response in
            if let imagePath = response.destinationURL?.path {
                mybook[myBookIndex].imagePath = imagePath
            }
    }
    return ""
}
//
//  Game2048ViewController.swift
//  games
//
//  Created by liushungxi on 2018/9/17.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit
import SnapKit
import UIKit.UIGestureRecognizerSubclass
class Game2048ViewController: UIViewController{

    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var crrounrtScore:UILabel!
    @IBOutlet weak var maxScore:UILabel!
    var score = 0
    let box = UIView()
    let boxViewWight = (UIScreen.main.bounds.width-24)/4
    let boxViewHeight = ((UIScreen.main.bounds.width-24)/8)*1.73
    var baseViewBoxs = [[Game2048BaseViewBox]]()
    var baseViewBoxsIsNil = [(Int,Int)]()
    var baseViewBoxsIsNotNil = [(Int,Int)]()
    var maxScor = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        if let maxScores = UserDefaults.standard.value(forKey: "maxScore"){
            maxScore.text = "最高分数:\(maxScores)"
            maxScor = maxScores as! Int
        }
        
        view.addSubview(box)
        box.backgroundColor = UIColor.init(red: 192/255, green: 177/255, blue: 162/255, alpha: 1)
        box.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.height.equalTo(boxViewHeight*5)
            make.width.equalTo(UIScreen.main.bounds.width-24)
        }
        
        addBaseView(section: 0, row: 3)
        addBaseView(section: 1, row: 4)
        addBaseView(section: 2, row: 5)
        addBaseView(section: 3, row: 4)
        addBaseView(section: 4, row: 3)
        
        randomNewImage()
        printf()
    }
    @IBAction func clickButton(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            clickLeftUp()
        case 2:
            clickUp()
        case 3:
            clickRightUp()
        case 4:
            clickLeftDown()
        case 5:
            clickDown()
        case 6:
            clickRightDown()
        default:
            return
        }
        randomNewImage()
        printf()
    }
    func clickLeftUp() {
        leftUp()
        findNil()
        leftUphebing()
        findNil()
        if isHeing{
            leftUp()
            findNil()
            isHeing = false
        }
    }
    func leftUp(){
        for item1 in baseViewBoxsIsNotNil {
            var item1x = item1.0
            var item1y = item1.1
            for _ in 0..<5{
                if item1x>2 && baseViewBoxs[item1x-1][item1y].imageIndex == 0{
                    let aaa = baseViewBoxs[item1x][item1y].imageIndex
                    baseViewBoxs[item1x][item1y].reloadImage(0)
                    baseViewBoxs[item1x-1][item1y].reloadImage(aaa)
                    item1x -= 1
                    continue
                }
                if item1x-1<0 || item1y-1<0{
                    break
                }
                if item1x<=2 && baseViewBoxs[item1x-1][item1y-1].imageIndex == 0{
                    let aaa = baseViewBoxs[item1x][item1y].imageIndex
                    baseViewBoxs[item1x][item1y].reloadImage(0)
                    baseViewBoxs[item1x-1][item1y-1].reloadImage(aaa)
                    item1x -= 1
                    item1y -= 1
                    if item1x<=0 || item1y<=0{
                        break
                    }
                }
            }
        }
    }
    func leftUphebing(){
        for item1 in baseViewBoxsIsNotNil {
            let item1x = item1.0
            let item1y = item1.1
            if item1x+1>4 || item1 == (2,4) || item1 == (3,3){
                continue
            }
            if item1x>=2 && baseViewBoxs[item1x+1][item1y].imageIndex != 0{
                if baseViewBoxs[item1x+1][item1y].imageIndex == baseViewBoxs[item1x][item1y].imageIndex{
                    baseViewBoxs[item1x][item1y].reloadImagejiaOne()
                    baseViewBoxs[item1x+1][item1y].reloadImage(0)
                    isHeing = true
                    continue
                }
            }
            if item1x<2 && baseViewBoxs[item1x+1][item1y+1].imageIndex != 0{
                if baseViewBoxs[item1x+1][item1y+1].imageIndex == baseViewBoxs[item1x][item1y].imageIndex{
                    baseViewBoxs[item1x][item1y].reloadImagejiaOne()
                    baseViewBoxs[item1x+1][item1y+1].reloadImage(0)
                    isHeing = true
                }
            }
        }
    }
    func clickUp() {
        up()
        findNil()
        Uphebing()
        findNil()
        if isHeing{
            up()
            findNil()
            isHeing = false
        }
    }
    func Uphebing(){
        for item1 in baseViewBoxs {
            for i in 0..<item1.count-1{
                if item1[i].imageIndex == item1[i+1].imageIndex && item1[i].imageIndex != 0{
                    item1[i].reloadImagejiaOne()
                    item1[i+1].reloadImage(0)
                    isHeing = true
                    break
                }
            }
        }
    }
    func up(){
        var temp = baseViewBoxsIsNotNil[0].0
        var temp1 = 0
        for item1 in baseViewBoxsIsNotNil {
            if item1.0 != temp{
                temp = item1.0
                temp1 = 0
            }
            let aaa = baseViewBoxs[item1.0][item1.1].imageIndex
            baseViewBoxs[item1.0][item1.1].reloadImage(0)
            baseViewBoxs[item1.0][temp1].reloadImage(aaa)
            temp1 += 1
        }
    }
    
    func clickRightUp() {
        rightUp()
        findNil()
        rightUp()
        findNil()
        rightUphebing()
        findNil()
        if isHeing{
            rightUp()
            findNil()
            isHeing = false
        }
    }
    func rightUp(){
        for item1 in baseViewBoxsIsNotNil {
            var item1x = item1.0
            var item1y = item1.1
            for _ in 0..<5{
                if item1x<2 && baseViewBoxs[item1x+1][item1y].imageIndex == 0{
                    let aaa = baseViewBoxs[item1x][item1y].imageIndex
                    baseViewBoxs[item1x][item1y].reloadImage(0)
                    baseViewBoxs[item1x+1][item1y].reloadImage(aaa)
                    item1x += 1
                    continue
                }
                if item1x+1>4 || item1y-1<0{
                    break
                }
                if item1x>=2 && baseViewBoxs[item1x+1][item1y-1].imageIndex == 0{
                    let aaa = baseViewBoxs[item1x][item1y].imageIndex
                    baseViewBoxs[item1x][item1y].reloadImage(0)
                    baseViewBoxs[item1x+1][item1y-1].reloadImage(aaa)
                    item1x += 1
                    item1y -= 1
                    if item1x>=4 || item1y<=0{
                        break
                    }
                }
            }
        }
    }
    func rightUphebing(){
        var last = baseViewBoxsIsNotNil.count-1
        for _ in 0..<baseViewBoxsIsNotNil.count {
            let item1x = baseViewBoxsIsNotNil[last].0
            let item1y = baseViewBoxsIsNotNil[last].1
            if item1x>2 && baseViewBoxs[item1x][item1y].imageIndex>0 && baseViewBoxs[item1x-1][item1y+1].imageIndex == baseViewBoxs[item1x][item1y].imageIndex  {
                baseViewBoxs[item1x-1][item1y+1].reloadImage(0)
                baseViewBoxs[item1x][item1y].reloadImagejiaOne()
                isHeing = true
                last -= 1
                continue
            }
            if item1x==0 || (item1x,item1y) == (2,4) || (item1x,item1y) == (1,3){
                last -= 1
                continue
            }
            if item1x<=2 && baseViewBoxs[item1x][item1y].imageIndex>0 && baseViewBoxs[item1x-1][item1y].imageIndex == baseViewBoxs[item1x][item1y].imageIndex   {
                baseViewBoxs[item1x-1][item1y].reloadImage(0)
                baseViewBoxs[item1x][item1y].reloadImagejiaOne()
                isHeing = true
                
            }
            last -= 1
        }
    }
    func clickLeftDown() {
        leftDown()
        findNil()
        leftDownhebing()
        findNil()
        if isHeing{
            leftDown()
            findNil()
            isHeing = false
        }
    }
    func leftDown(){
        for item1 in baseViewBoxsIsNotNil {
            var item1x = item1.0
            var item1y = item1.1
            for _ in 0..<5{
                if item1x>2 && baseViewBoxs[item1x-1][item1y+1].imageIndex == 0{
                    let aaa = baseViewBoxs[item1x][item1y].imageIndex
                    baseViewBoxs[item1x][item1y].reloadImage(0)
                    baseViewBoxs[item1x-1][item1y+1].reloadImage(aaa)
                    item1x -= 1
                    item1y += 1
                    if item1x<=0{
                        break
                    }
                }
                if item1x==0 || (item1x,item1y) == (1,3) || (item1x,item1y) == (2,4){
                    break
                }
                if item1x<=2 && baseViewBoxs[item1x-1][item1y].imageIndex == 0{
                    let aaa = baseViewBoxs[item1x][item1y].imageIndex
                    baseViewBoxs[item1x][item1y].reloadImage(0)
                    baseViewBoxs[item1x-1][item1y].reloadImage(aaa)
                    item1x -= 1
                    continue
                }
            }
        }
    }
    func leftDownhebing(){
        for item1 in baseViewBoxsIsNotNil {
            let item1x = item1.0
            let item1y = item1.1
            if item1x+1>4 || item1 == (2,0) || item1 == (3,0){
                continue
            }
            if item1x<2 && baseViewBoxs[item1x+1][item1y].imageIndex != 0{
                if baseViewBoxs[item1x+1][item1y].imageIndex == baseViewBoxs[item1x][item1y].imageIndex{
                    baseViewBoxs[item1x][item1y].reloadImagejiaOne()
                    baseViewBoxs[item1x+1][item1y].reloadImage(0)
                    isHeing = true
                    continue
                }
            }
            if item1x>=2 && baseViewBoxs[item1x+1][item1y-1].imageIndex != 0{
                if baseViewBoxs[item1x+1][item1y-1].imageIndex == baseViewBoxs[item1x][item1y].imageIndex{
                    baseViewBoxs[item1x][item1y].reloadImagejiaOne()
                    baseViewBoxs[item1x+1][item1y-1].reloadImage(0)
                    isHeing = true
                }
            }
        }
    }
    func clickDown() {
        down()
        findNil()
        Downhebing()
        findNil()
        if isHeing{
            down()
            findNil()
            isHeing = false
        }
    }
    var isHeing = false
    func Downhebing(){
        for item1 in baseViewBoxs {
            var max = item1.count
            for _ in 0..<item1.count-1{
                max -= 1
                if max == 0{break}
                if item1[max].imageIndex == item1[max-1].imageIndex && item1[max].imageIndex != 0{
                    item1[max].reloadImagejiaOne()
                    item1[max-1].reloadImage(0)
                    isHeing = true
                    break
                }
            }
        }
    }
    func down(){
        var last = baseViewBoxsIsNotNil.count - 1
        var temp = baseViewBoxsIsNotNil.last?.0
        var temp1 = baseViewBoxs[temp!].count-1
        for _ in 0..<baseViewBoxsIsNotNil.count {
            if baseViewBoxsIsNotNil[last].0 != temp{
                temp = baseViewBoxsIsNotNil[last].0
                temp1 = baseViewBoxs[temp!].count - 1
            }
            let item1 = baseViewBoxsIsNotNil[last]
            let aaa = baseViewBoxs[item1.0][item1.1].imageIndex
            baseViewBoxs[item1.0][item1.1].reloadImage(0)
            baseViewBoxs[item1.0][temp1].reloadImage(aaa)
            temp1 -= 1
            last -= 1
        }
        
    }
    func clickRightDown() {
        rightdown()
        findNil()
        rightdown()
        findNil()
        rightdownhebing()
        findNil()
        if isHeing{
            rightdown()
            findNil()
            isHeing = false
        }
    }
    func rightdown(){
        for item1 in baseViewBoxsIsNotNil {
            var item1x = item1.0
            var item1y = item1.1
            for _ in 0..<5{
                if item1x<2 && baseViewBoxs[item1x+1][item1y+1].imageIndex == 0{
                    let aaa = baseViewBoxs[item1x][item1y].imageIndex
                    baseViewBoxs[item1x][item1y].reloadImage(0)
                    baseViewBoxs[item1x+1][item1y+1].reloadImage(aaa)
                    item1x += 1
                    item1y += 1
                    continue
                }
                if item1x+1>4 || (item1x,item1y) == (3,3) || (item1x,item1y) == (2,4){
                    break
                }
                if item1x>=2 && baseViewBoxs[item1x+1][item1y].imageIndex == 0{
                    let aaa = baseViewBoxs[item1x][item1y].imageIndex
                    baseViewBoxs[item1x][item1y].reloadImage(0)
                    baseViewBoxs[item1x+1][item1y].reloadImage(aaa)
                    item1x += 1
                    
                }
            }
        }
    }
    func rightdownhebing(){
        var last = baseViewBoxsIsNotNil.count-1
        for _ in 0..<baseViewBoxsIsNotNil.count {
            let item1x = baseViewBoxsIsNotNil[last].0
            let item1y = baseViewBoxsIsNotNil[last].1
            if item1x>2 && baseViewBoxs[item1x][item1y].imageIndex>0 && baseViewBoxs[item1x-1][item1y].imageIndex == baseViewBoxs[item1x][item1y].imageIndex   {
                baseViewBoxs[item1x-1][item1y].reloadImage(0)
                baseViewBoxs[item1x][item1y].reloadImagejiaOne()
                last -= 1
                isHeing = true
                continue
            }
            
            if item1x==0 || (item1x,item1y) == (2,0) || (item1x,item1y) == (1,0){
                last -= 1
                continue
            }
            
            if item1x<=2 && baseViewBoxs[item1x][item1y].imageIndex>0 && baseViewBoxs[item1x-1][item1y-1].imageIndex == baseViewBoxs[item1x][item1y].imageIndex  {
                baseViewBoxs[item1x-1][item1y-1].reloadImage(0)
                baseViewBoxs[item1x][item1y].reloadImagejiaOne()
                isHeing = true
                
            }
            last -= 1
            
        }
    }
    func randomNewImage(){
        if baseViewBoxsIsNil.isEmpty{
            print("游戏失败")
        }
        let section:Int = Int(arc4random()%UInt32(baseViewBoxsIsNil.count))
        let row = baseViewBoxsIsNil[section]
        let tempTime = Int(arc4random()%10)
        if tempTime<=7{
            baseViewBoxs[row.0][row.1].reloadImagejiaOne()
            score += 2
        }else{
            baseViewBoxs[row.0][row.1].imageView.image = images[2]
            baseViewBoxs[row.0][row.1].imageIndex = 2
            UIView.animate(withDuration: 0.5, animations: {
                self.baseViewBoxs[row.0][row.1].imageView.transform = CGAffineTransform.identity
                    .scaledBy(x: 0.5, y: 0.5)
            }, completion: { (_) in
                UIView.animate(withDuration: 0.5) {
                    self.baseViewBoxs[row.0][row.1].imageView.transform = CGAffineTransform.identity
                        .scaledBy(x: 1, y: 1)
                }
            })
            score += 4
        }
        crrounrtScore.text = "当前分数:\(score)"
        baseViewBoxsIsNotNil.append(row)
        baseViewBoxsIsNil.remove(at: section)
        baseViewBoxsIsNotNil.sort{
            return $0<$1
        }
        baseViewBoxsIsNil.sort{
            return $0<$1
        }
        changeMaxScore()
    }
    func changeMaxScore(){
        if maxScor>=score{
            return
        }else{
            UserDefaults.standard.set(score, forKey: "maxScore")
            maxScor = score
            maxScore.text = "最高分数:\(score)"
        }
    }
    func addBaseView(section:Int,row:Int){
        let tempView = UIView()
        var tempBase = [Game2048BaseViewBox]()
        box.addSubview(tempView)
        tempView.snp.makeConstraints { (make) in
            make.height.equalTo(boxViewHeight*CGFloat(row))
            make.left.equalTo(CGFloat(section)*(boxViewWight/4*3))
            make.width.equalTo(boxViewWight)
            make.centerY.equalTo(box)
        }
        for i in 0..<row{
            let temp = Game2048BaseViewBox()
            tempBase.append(temp)
            tempView.addSubview(temp)
            temp.snp.makeConstraints { (make) in
                make.height.equalTo(boxViewHeight)
                make.width.equalTo(boxViewWight)
                make.left.equalToSuperview()
                make.top.equalTo(CGFloat(i)*boxViewHeight)
            }
            baseViewBoxsIsNil.append((section, i))
        }
        baseViewBoxs.append(tempBase)
    }
    func findNil() {
        baseViewBoxsIsNil.removeAll()
        baseViewBoxsIsNotNil.removeAll()
        for (index1,item1) in baseViewBoxs.enumerated() {
            for (index2,item2) in item1.enumerated() {
                if item2.imageIndex == 0{
                    baseViewBoxsIsNil.append((index1, index2))
                }else{
                    baseViewBoxsIsNotNil.append((index1, index2))
                }
            }
        }
    }
    func printf(){
        print("baseViewBoxsIsNil:\(baseViewBoxsIsNil)")
        print("baseViewBoxsIsNotNil:\(baseViewBoxsIsNotNil)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

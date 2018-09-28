//
//  MyBooksCollectionViewController.swift
//  games
//
//  Created by liushungxi on 2018/9/26.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit
import XLPagerTabStrip
private let reuseIdentifier = "Cell"
import Kingfisher
var mybook = [KfMybook]()
class MyBooksCollectionViewController: UICollectionViewController,IndicatorInfoProvider {
    var titles:IndicatorInfo = ""
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return titles
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        readLiShi()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 160, height: 106)
        collectionView?.collectionViewLayout = layout
        collectionView?.registerCell(cell: MybookCollectionViewCell.self)

        // Do any additional setup after loading the view.
    }
    func readLiShi() {
        if !File.fileIsExist(fileName: "lishi.txt"){
            File.createFile(fileName: "lishi.txt", filePathName: "")
        }
        let tempContent = File.readFile(fileName: "lishi.txt", filePathName: "")
        if let hasValue = [KfMybook].deserialize(from:  tempContent){
            mybook = hasValue.compactMap({$0})
            self.collectionView?.reloadData()
        }else{
            print("错误")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return mybook.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MybookCollectionViewCell", for: indexPath) as! MybookCollectionViewCell
        cell.nameLabel.text = mybook[indexPath.row].title
        let tempUrl = downloadImg("https://" + mybook[indexPath.row].image,indexPath.row)
        if tempUrl.isEmpty{
            cell.image.kf.setImage(with: URL.init(string:"https://" + mybook[indexPath.row].image))
        }else{
            let docPath = File.getUserFilePath()
            let file = docPath.appendingPathComponent(tempUrl)
            let imgData = try! Data.init(contentsOf: file)
            cell.image.image = UIImage(data: imgData)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ReadContentNewViewController()
        vc.index = mybook[indexPath.row].currentIndex
        vc.currentUrl = mybook[indexPath.row].currentChapter
        navigationController?.pushViewController(vc, animated: true)
    }
}

//
//  NewMybooksViewController.swift
//  games
//
//  Created by liushungxi on 2018/10/8.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Kingfisher
var mybook = [KfMybook]()
class NewMybooksViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,IndicatorInfoProvider {
    var titles:IndicatorInfo = ""
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return titles
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBAction func cancelButton(_ sender: Any) {
        compileModel = false
    }
    @IBAction func allSelectionBotton(_ sender: Any) {
        for i in 0..<selectedBtnBool.count{
            selectedBtnBool[i] = true
        }
        collectionView.reloadData()
    }
    @IBAction func delectButton(_ sender: Any) {
        for i in 0..<selectedBtnBool.count{
            if selectedBtnBool[i] == true{
                mybook.remove(at: i)
            }
        }
        collectionView.reloadData()
        File.delFile(fileName: "lishi.txt")
        File.createFile(fileName: "lishi.txt", filePathName: "")
        File.writeFile(fileName: "lishi.txt", filePathName: "", content: mybook.toJSONString()!)
        compileModel = false
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        collectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        readLiShi()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3-9, height: UIScreen.main.bounds.width/2)
        collectionView?.collectionViewLayout = layout
        collectionView?.registerCell(cell: MybookCollectionViewCell.self)
        
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return mybook.count
    }
    var compileModel = false{
        didSet{
            bottomView.isHidden = !compileModel
            collectionView?.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MybookCollectionViewCell", for: indexPath) as! MybookCollectionViewCell
        cell.nameLabel.text = mybook[indexPath.row].title
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(delectBtn(_:)))
        tap.minimumPressDuration = 1
        tap.numberOfTouchesRequired = 1
        cell.addGestureRecognizer(tap)
        if mybook.count > selectedBtnBool.count{
            selectedBtnBool.append(false)
        }
        cell.selectedButton.isSelected = selectedBtnBool[indexPath.row]
        cell.selectedButton.isHidden = !compileModel
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
    @objc func delectBtn(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            if compileModel{
                let selectedCellIndex = collectionView.indexPathForItem(at: sender.location(in: collectionView))
                collectionView.beginInteractiveMovementForItem(at: selectedCellIndex!)
            }else{
                compileModel = true
            }
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(sender.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tempMybook = mybook[sourceIndexPath.item]
        mybook.remove(at: sourceIndexPath.item)
        mybook.insert(tempMybook, at: destinationIndexPath.item)
    }
    var selectedBtnBool = [Bool]()
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if compileModel{
            selectedBtnBool[indexPath.row] = !selectedBtnBool[indexPath.row]
            collectionView.reloadData()
        }else{
            if mybook[indexPath.row].currentChapter != ""{
                let vc = ReadContentNewViewController()
                vc.index = mybook[indexPath.row].currentIndex
                vc.data.catalog = mybook[indexPath.row].catalog
                vc.currentUrl = mybook[indexPath.row].currentChapter
                vc.getcatalogs(mybook[indexPath.row].catalog)
                navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = CatalogTableViewController()
                vc.isBack = true
                vc.currentUrl = mybook[indexPath.row].catalog
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

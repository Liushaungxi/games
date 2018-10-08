//
//  Netmode.swift
//  games
//
//  Created by liushungxi on 2018/9/27.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit
import HandyJSON
var baseUrl = "https://www.biqudao.com"
class KfContent:NSObject,HandyJSON{
    var title = ""
    var nextUrl = ""
    var parUrl = ""
    var content = [String]()
    var catalog = ""
    required override init(){}
}
class KfCatalog: NSObject,HandyJSON {
    var url = ""
    var title = ""
    required override init(){}
}
class KfWebTitle: NSObject,HandyJSON {
    var url = ""
    var name = ""
    var headImage:UIImage?
    required override init(){}
}
class KfMybook: NSObject,HandyJSON {
    var title = ""
    var image = ""
    var catalog = ""
    var imagePath = ""
    var currentChapter = ""
    var currentIndex = 0
    var chapterIndex = 0
    required override init(){}
}

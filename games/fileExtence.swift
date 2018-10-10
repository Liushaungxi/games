//
//  fileExtence.swift
//  多线程
//
//  Created by liushungxi on 2018/8/20.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit
class File {
    //获取用户路径
    static func getUserFilePath()->URL{
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let url = urlForDocument[0] as URL
        return url
    }
    //（2）对指定路径执行浅搜索，返回指定目录路径下的文件、子目录及符号链接的列表
    static func getPathFileList()->[String]{
        let manager = FileManager.default
        let url = getUserFilePath()
        let contentsOfPath = try? manager.contentsOfDirectory(atPath: url.path)
        return contentsOfPath ?? ["空"]
    }
    //计算文件夹的空间大小
//    var fileArray = File.getPathFileDetailList(folder: "/data")
//    fileArray += File.getPathFileDetailList(folder: "/img")
//    var size:Int = 0
//    for item in fileArray {
//    let manager = FileManager.default
//    let attributes = try? manager.attributesOfItem(atPath: (item.path))
//    size += attributes![FileAttributeKey.size]! as! Int
//    }
//    print("\(size)B")
    //（3）类似上面的，对指定路径执行浅搜索，返回指定目录路径下的文件、子目录及符号链接的列表
    static func getPathFileDetailList(folder:String)->[URL]{
        let manager = FileManager.default
        let url = URL.init(string: getUserFilePath().absoluteString + folder)
        let contentsOfURL = try? manager.contentsOfDirectory(at: url!,
                                                             includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        return contentsOfURL ?? [URL.init(string: "nil")!]
    }
    //（6）深度遍历，会递归遍历子文件夹（包括符号链接，所以要求性能的话用enumeratorAtPath）
    static func getPathFileNameList()->[String]{
        let manager = FileManager.default
        let url = getUserFilePath()
        let subPaths = manager.subpaths(atPath: url.path)
        return subPaths ?? ["nil"]
    }
    //2，判断文件或文件夹是否存在
    static func fileIsExist(fileName:String)->Bool{
        let fileManager = FileManager.default
        let filePath:String = NSHomeDirectory() + "/Documents/" + fileName
        let exist = fileManager.fileExists(atPath: filePath)
        return exist
    }
    //3，创建文件夹
    static func createFolder(folderName:String){
        let myDirectory:String = NSHomeDirectory() + "/Documents/" + folderName
        let fileManager = FileManager.default
        try! fileManager.createDirectory(atPath: myDirectory,withIntermediateDirectories: true, attributes: nil)
    }
    //5，创建文件
    static func createFile(fileName:String,filePathName:String){
        let manager = FileManager.default
        let url = getUserFilePath()
        let url1 = URL.init(string: "\(url)\(filePathName)")
        let file = url1?.appendingPathComponent(fileName)
        let exist = manager.fileExists(atPath: (file?.path)!)
        if !exist {
            let data = Data(base64Encoded:"" ,options:.ignoreUnknownCharacters)
            let createSuccess = manager.createFile(atPath: (file?.path)!,contents:data,attributes:nil)
            print("文件创建结果: \(createSuccess)")
        }
    }
    //6，复制文件
    static func copyFile(fileName:String,copyedFileName:String){
        // 定位到用户文档目录
        let fileManager = FileManager.default
        let homeDirectory = NSHomeDirectory()
        let srcUrl = homeDirectory + "/Documents/" + fileName
        let toUrl = homeDirectory + "/Documents/" + copyedFileName
        try! fileManager.copyItem(atPath: srcUrl, toPath: toUrl)
    }
    //移动文件
    static func moveFile(fileName:String,moveFileName:String){
        let fileManager = FileManager.default
        let homeDirectory = NSHomeDirectory()
        let srcUrl = homeDirectory + "/Documents/" + fileName
        let toUrl = homeDirectory + "/Documents/" + moveFileName
        try! fileManager.moveItem(atPath: srcUrl, toPath: toUrl)
    }
    //删除文件
    static func delFile(fileName:String){
        let fileManager = FileManager.default
        let homeDirectory = NSHomeDirectory()
        let srcUrl = homeDirectory + "/Documents/" + fileName
        try! fileManager.removeItem(atPath: srcUrl)
    }
    //9，删除目录下所有的文件
    static func delAllFile(folderName:String){
        let fileManager = FileManager.default
        let myDirectory = NSHomeDirectory() + "/Documents/" + folderName
        let fileArray = fileManager.subpaths(atPath: myDirectory)
        for fn in fileArray!{
            try! fileManager.removeItem(atPath: myDirectory + "/\(fn)")
        }
    }
    //10，读取文件
    static func readFile(fileName:String,filePathName:String)->String{
        
        let manager = FileManager.default
        let urlsForDocDirectory = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let docPath = urlsForDocDirectory[0]
        let file = docPath.appendingPathComponent(filePathName+fileName)
        //方法1
//        let readHandler = try! FileHandle(forReadingFrom:file)
//        let data = readHandler.readDataToEndOfFile()
//        let readString = String(data: data, encoding: String.Encoding.utf8)
        let str = try! String.init(contentsOf: file, encoding: String.Encoding.utf8)
        return String(describing: str)
//        方法2
//        let manager = FileManager.default
//        let data2 = manager.contents(atPath: (file?.path)!)
//        let readString2 = String(data: data2!, encoding: String.Encoding.utf8)
//        return String(describing: readString2)
    }
    //写文件文件末尾
    static func writeFile(fileName:String,filePathName:String,content:String){
        let docPath = getUserFilePath()
        let url = URL.init(string: "\(docPath)\(filePathName)")
        let file = url?.appendingPathComponent(fileName)
        
        let appendedData = content.data(using: String.Encoding.utf8, allowLossyConversion: true)
        let writeHandler = try? FileHandle(forWritingTo:file!)
        writeHandler!.seekToEndOfFile()
        writeHandler!.write(appendedData!)
    }
    //文件权限判断
    static func fileJurisdictionJudge(fileName:String,filePathName:String){
        let manager = FileManager.default
        let docPath = getUserFilePath()
        let url = URL.init(string: "\(docPath)\(filePathName)")
        let file = url?.appendingPathComponent(fileName)
        
        let readable = manager.isReadableFile(atPath: (file?.path)!)
        print("可读: \(readable)")
        let writeable = manager.isWritableFile(atPath: (file?.path)!)
        print("可写: \(writeable)")
        let executable = manager.isExecutableFile(atPath: (file?.path)!)
        print("可执行: \(executable)")
        let deleteable = manager.isDeletableFile(atPath: (file?.path)!)
        print("可删除: \(deleteable)")
    }
    //获取文件属性
    static func getFileProperty(fileName:String,filePathName:String){
        let manager = FileManager.default
        let docPath = getUserFilePath()
        let url = URL.init(string: "\(docPath)\(filePathName)")
        let file = url?.appendingPathComponent(fileName)
        
        let attributes = try? manager.attributesOfItem(atPath: (file?.path)!) //结果为Dictionary类型
        print("attributes: \(attributes!)")
        print("创建时间：\(attributes![FileAttributeKey.creationDate]!)")
        print("修改时间：\(attributes![FileAttributeKey.modificationDate]!)")
        print("文件大小：\(attributes![FileAttributeKey.size]!)")
    }
    //写文件
    static func writeFileContent(fileNameAndPath:String,content:String){
        let filePath:String = NSHomeDirectory() + "/Documents/" + fileNameAndPath
        try! content.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
    }
    static func writeFileContent(fileNameAndPath:String,content:UIImage){
        let filePath:String = NSHomeDirectory() + "/Documents/" + fileNameAndPath
        let data:Data = UIImagePNGRepresentation(content)!
        try? data.write(to: URL(fileURLWithPath: filePath))
    }
    static func writeFileContent(fileNameAndPath:String,content:NSArray){
        let filePath:String = NSHomeDirectory() + "/Documents/" + fileNameAndPath
        content.write(toFile: filePath, atomically: true)
    }
    static func writeFileContent(fileNameAndPath:String,content:NSDictionary){
        let filePath:String = NSHomeDirectory() + "/Documents/" + fileNameAndPath
        content.write(toFile: filePath, atomically: true)
    }

}

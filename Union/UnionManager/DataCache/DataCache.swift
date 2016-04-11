//
//  DataCache.swift
//  Union
//
//  Created by 万联 on 16/4/11.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class DataCache: NSObject {
    
    private static let instance:DataCache = DataCache();
    class  var shareInstance:DataCache {
        return instance;
    }
    
    func documentPath()->String{
    
        let arr:NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        return arr.firstObject as! String;
    
    }
    
    //MARK:获取document下创建文件夹下的分类文件夹路径
    /**
    * 获取document下创建文件夹下的分类文件夹路径
    */
    func getDocumentFileManagerPathWithClassify(classifyName:String)->String{
    
        let documentPath = self.documentPath();
        let fileManeger = NSFileManager.defaultManager();
        let filePath = ((documentPath + "/datacache") as NSString).stringByAppendingPathComponent(classifyName);
        if fileManeger.fileExistsAtPath(filePath){
            return filePath;
        }else{
            
            return "nil";
        }
        
    }
    

    
    //MARK:document下创建文件夹并获取文件夹路径
    func documentFileManagerPathWith(fileName:String, Classify classiyName:String)->String{
    
        //fileName 文件名称  classifyName 文类名称
        
        //缓存目录结构: document/datacache/分类名文件夹/文件名文件夹/文件名.json
        let documentPaht = self.documentPath();
        let fileManager:NSFileManager = NSFileManager.defaultManager();
        
        let filePath = (((documentPaht + "/datacache")as NSString).stringByAppendingPathComponent(classiyName) as NSString).stringByAppendingPathComponent(fileName);
        
        if !fileManager.fileExistsAtPath(filePath){
        
            do{
               try fileManager.createDirectoryAtPath(filePath, withIntermediateDirectories: true, attributes: nil);
             }catch{
               
                print("创建文件夹失败");
            }
        }
        return filePath;
    }
    
    //MARK: ---保存数据到Document下指定分类文件夹下
    func saveDataForDocument(data:AnyObject?,DataName dataName:String,Classify classifyName:String){
    
        if data != nil{
            GCDQueue.globalQueue.excute({[weak self] () -> Void in
                do{
                
                    let tempData = try NSJSONSerialization.dataWithJSONObject(data!, options: NSJSONWritingOptions.PrettyPrinted);
                    tempData.writeToFile(((self?.documentFileManagerPathWith(dataName, Classify: classifyName))!as NSString).stringByAppendingPathComponent(dataName + ".json"), atomically: true);
                   
                }catch{
                  print("保存失败")
                }
            })
        
        }
    }
    //MARK:获取指定数据
    func getDataForDocument(dataName dataName:String,ClassifyName classifyName:String)->AnyObject?{
    
        let dataPath = (self.documentFileManagerPathWith(dataName, Classify: classifyName) as NSString).stringByAppendingPathComponent(dataName + ".json");
        
        let tempData = NSData(contentsOfFile: dataPath);
        if tempData != nil{
        
            do{
               
                let anyObject = try NSJSONSerialization.JSONObjectWithData(tempData!, options: NSJSONReadingOptions.MutableContainers);
                return anyObject;
            
               }catch{
            
            }
        
        }
        //MARK: 不知道这样行不行
        return NSNull();
    
    }
    
    //MARK ---单个文件的大小
    func fileSizeAtPath(filePath:String)->UInt64{
    
        let fileManager = NSFileManager.defaultManager();
        if fileManager.fileExistsAtPath(filePath){
            do{
                let file:NSDictionary = try fileManager.attributesOfFileSystemForPath(filePath)
                 return file.fileSize()
            }catch{}
        }
        return 0;
    
    }
    //MARK 获取指定缓存路径的缓存大小
    func getCacheSizeWithCacheFilePath(cacheFilePath:String)->UInt64{
    
        let fileManager = NSFileManager.defaultManager();
         var folderSize:UInt64 = 0;
        
//        let enmue:NSEnumerator = (fileManager.subpathsAtPath(cacheFilePath) as! NSArray).objectEnumerator();
//        
//        if var fileNmae = enmue.nextObject() as! String?{
//            let filePath = (cacheFilePath as NSString).stringByAppendingPathComponent(fileNmae);
//            folderSize += self.fileSizeAtPath(filePath);
//        }
        
        for (_,fileNmae) in (fileManager.subpathsAtPath(cacheFilePath)?.enumerate())!{
        
            let filePath = (cacheFilePath as NSString).stringByAppendingPathComponent(fileNmae);

            folderSize += self.fileSizeAtPath(filePath);
        
        }
        
        return folderSize;
    
    }
    //MARK: 获取指定分类缓存大小
    /**
     * 获取指定分类缓存大小
    */
    func getCacheSizeWith(classifyName:String)->UInt64{
    
        let classifyPath = self.getDocumentFileManagerPathWithClassify(classifyName);
        let fileManager = NSFileManager.defaultManager();

        if !fileManager.fileExistsAtPath(classifyPath){
            return 0;
        }
        let folderSize = self.getCacheSizeWithCacheFilePath(classifyPath);
        return folderSize;
    
    }
    /**
     * 字节转换
     */
    func getKBorMBorGBWith(folderSize:CGFloat)->String{
    
        if folderSize == 0{
            return "0.00KB";
        }else if(folderSize / (1024.0) < 1024.0){
            return NSString(format: "%.2fKB",folderSize / (1024.0) ) as String;
        }else if(folderSize/(1024.0) >= 1024.0 && folderSize/(1024.0 * 1024.0) < 1024.0){
          return NSString(format: "%.2MB",folderSize/(1024.0 * 1024.0)) as String;
        }else{
            return NSString(format: "%.2GB",folderSize/(1024.0 * 1024.0 * 1024.0)) as String;
        }
    }
    
    /**
     * 删除相应的文件
     */
    func removeClassifyCache(classifyName:String){
    
        let classifyPath = self.getDocumentFileManagerPathWithClassify(classifyName);
        let fileManager = NSFileManager.defaultManager();
        if fileManager.fileExistsAtPath(classifyPath){
        
            do{
            
                try fileManager.removeItemAtPath(classifyPath);
                
              }catch{
                print("删除出错");
            }
        
        }
    
    }
    
    
    
    

}

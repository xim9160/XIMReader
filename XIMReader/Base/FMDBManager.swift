//
//  DBFileManager.swift
//  XIMReader
//
//  Created by xiaofengmin on 2019/9/26.
//  Copyright © 2019 xiaofengmin. All rights reserved.
//

import Foundation
import FMDB

let PLATFORM_TABLE = "PLATFORM_TABLE"
let INVESTMENT_TABLE = "INVESTMENT_TABLE"

class FMDBManager: NSObject {
    static let shared = FMDBManager()
    
    private let databaseFileName = "fmdb.sqlite"
    private var pathToDatabase:String!
    private var database:FMDatabase!
    
    override init() {
        super.init()
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        //这里使用bundle 会不会更加合适
        pathToDatabase = documentDirectory.appending("/\(databaseFileName)")
    }
    
    func DBAction() {
        _ = openDatabase()
    }
    
    /**创建数据库*/
    func openDatabase() -> Bool{
        var created = false
        //如果数据库文件不存在那么就创建，存在就不创建
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase)
            if database != nil{
                //数据库是否被打开
                if database.open() {
                    //为数据库创建2张表，PLATFORM_TABLE 和 INVESTMENT_TABLE 是表名，sql语句结束要用;隔开，建表的时候注意类型 （primary key 是用来设置主键的）
                    let sql = "create table \(PLATFORM_TABLE) (uuid integer primary key not null, icon_url text not null, platform_name text not null, ctime integer not null, is_deleted integer not null, is_hot integer not null, is_user_create integer not null , mtime integer not null,  sort integer not null);"
                        +
                    "create table \(INVESTMENT_TABLE) (uuid integer primary key not null, platform_id integer not null, ctime integer not null, is_deleted integer not null, amount integer not null, annual_rate float not null , mtime integer not null,  interest_amount integer not null,  remark text not null, is_call integer not null, interest_start_date text not null, interest_end_date text not null, deposit_period text not null, call_date text not null);"
                    
                    if database.executeStatements(sql) {
//                        XLog(message: "数据库创建成功")
                        XLog("数据库创建成功")
                        created = true
                    }else{
                        created = false
//                        XLog(message: "数据库创建失败")
                        XLog("数据库创建失败")
                        XLog("Failed to insert initial data into the database.")
                        XLog("\(database.lastError()), \(database.lastErrorMessage())")
                    }
                }else{
//                    LMRLog(message: "数据库打开失败")
                    XLog("数据库打开失败")
                }
            }
        }else{
            //确认database对象是否被初始化，如果为nil，那么判断路径是否存在并创建
            if database == nil{
                if FileManager.default.fileExists(atPath: pathToDatabase){
                    database = FMDatabase(path: pathToDatabase)
                }
            }
            //如果database对象存在，打开数据库，返回真，表示打开成功，否则数据库文件不存在或者发生了其它错误
            if database != nil{
                if database.open(){
                    created = true
                }
            }
        }
        return created
    }
    
    /**插入数据(平台)*/
    func insertPlatformData(dataArray: [PlatformModel], complete: ((Bool) -> Void)?){
        if openDatabase() {
            if dataArray.count > 0 {
                database.shouldCacheStatements = true
            }
            for model in dataArray{
                let sql = "INSERT INTO \(PLATFORM_TABLE) (uuid,icon_url,platform_name,ctime,is_deleted,is_hot,is_user_create,mtime,sort) VALUES (?,?,?,?,?,?,?,?,?)"
                let res = database.executeUpdate(sql, withArgumentsIn: [model.uuid,model.icon_url,model.platform_name,model.ctime,model.is_deleted,model.is_hot,model.is_user_create,model.mtime,model.sort])
                if !res {
                    //打印插入操作所遭遇的问题
                    XLog("平台数据插入失败: \(model.platform_name), \(model.uuid)")
                    XLog(database.lastError(), file: database.lastErrorMessage())
                }
            }
            complete?(true)
        }
    }
    
    /**更新数据（平台*/
    func updatePlatformData(dataArray: [PlatformModel], complete: ((Bool) -> Void)?) {
        
        if dataArray.count == 0 {
            return
        }
        if openDatabase() {
            for model in dataArray {
                let query1 = "update \(PLATFORM_TABLE) set icon_url=?, platform_name=?, ctime=?, is_deleted=?, is_hot=?, is_user_create=?, mtime=?, sort=? where uuid=?"
                do {
                    try database.executeUpdate(query1, values: [model.icon_url, model.platform_name, model.ctime, model.is_deleted, model.is_hot, model.is_user_create, model.mtime, model.sort, model.uuid])
                } catch {
                    XLog("更新失败")
                    XLog(error.localizedDescription)
                }
            }
            complete?(true)
        }
    }
    
    /**查找平台数据*/
    func searchPlatformData(platformStatus: PlatformSearch, uuid: Int?, complete: (([PlatformModel]) -> Void)?) {
        if openDatabase() {
            var query: String = ""
            var dataArray: [PlatformModel] = []
            switch platformStatus {
            case .all:
                // 查询全部数据
                query = "select * from \(PLATFORM_TABLE) where is_deleted = 0"
                break
            case .isUserCreate:
                // 用户创建的全部查询出来
                query = "select * from \(PLATFORM_TABLE) where is_user_create = 1 and is_deleted = 0"
                break
            case .unUserCreate:
                // 用户创建的全部查询出来
                query = "select * from \(PLATFORM_TABLE) where is_user_create = 0 and is_deleted = 0"
                break
            case .uuid:
                // 根据UUID查询数据
                if uuid == nil {
                    complete?([])
                    return
                }
                query = "select * from \(PLATFORM_TABLE) where uuid = \(uuid!) and is_deleted = 0"
                break
            }
            
            do{
                //执行SQL语句,该方法需要两个参数，第一个是查寻的语句，第二个是数组，数组中可以包含想查寻的值，并且返回FMResultSet对象，该对象包含了获取的值
                let results = try database.executeQuery(query, values: nil)
                //遍历查寻结果，创建MovieInfo实例对象，并添加到数组中
                while results.next() {
//                    let model = PlatformModel()
                    var model = PlatformModel.init()
                    model.ctime = Int(results.longLongInt(forColumn: "ctime"))
                    model.icon_url = results.string(forColumn: "icon_url") ?? ""
                    model.platform_name = results.string(forColumn: "platform_name") ?? ""
                    model.is_deleted = Int(results.int(forColumn: "is_deleted"))
                    model.is_user_create = Int(results.int(forColumn: "is_user_create"))
                    model.mtime = Int(results.longLongInt(forColumn: "mtime"))
                    model.sort = Int(results.int(forColumn: "sort"))
                    model.is_hot = Int(results.int(forColumn: "is_hot"))
                    model.uuid = Int(results.longLongInt(forColumn: "uuid"))
//                    model.firstChar = "\(String(describing: model.platform_name.transformToPinYin().characters.first ?? "Z"))".uppercased()
                    dataArray.append(model)
                }
            }catch{
                XLog(query)
                XLog(error.localizedDescription)
            }
            complete?(dataArray)
        }
    }
    
    func deleteAllData() {
        
        if openDatabase() {
            
            let query = "DELETE FROM \(PLATFORM_TABLE);DELETE FROM \(INVESTMENT_TABLE);"
            
            if !database.executeStatements(query){
                //打印插入操作所遭遇的问题
                XLog("Failed to insert initial data into the database.")
                XLog("\(database.lastError()), \(database.lastErrorMessage())")
            }
            
//            let modle = pModel.init()
//            var model = pModel.init()
//            model.ctime = 10
        }
    }
}

//struct PlatformModel {
//    var ctime:Int?
//    var icon_url:String?
//}

enum PlatformSearch {
    case uuid
    case unUserCreate
    case isUserCreate
    case all
}

struct PlatformModel {
    var ctime:Int?
    var icon_url:String?
    var platform_name:String?
    var is_deleted:Int?
    var is_user_create:Int?
    var mtime:Int?
    var sort:Int?
    var is_hot:Int?
    var uuid:Int?
    var firstChar:String?
}

//class PlatformModel: NSObject {
    /*
    model.ctime = Int(results.longLongInt(forColumn: "ctime"))
    model.icon_url = results.string(forColumn: "icon_url") ?? ""
    model.platform_name = results.string(forColumn: "platform_name") ?? ""
    model.is_deleted = Int(results.int(forColumn: "is_deleted"))
    model.is_user_create = Int(results.int(forColumn: "is_user_create"))
    model.mtime = Int(results.longLongInt(forColumn: "mtime"))
    model.sort = Int(results.int(forColumn: "sort"))
    model.is_hot = Int(results.int(forColumn: "is_hot"))
    model.uuid = Int(results.longLongInt(forColumn: "uuid"))
    model.firstChar = "\(String(describing: model.platform_name.transformToPinYin().characters.first ?? "Z"))".uppercased()
    dataArray.append(model)
 */
//}

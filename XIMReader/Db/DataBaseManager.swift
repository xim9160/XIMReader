//
//  XIMDBManger.swift
//  XIMReader
//
//  Created by xiaofengmin on 2019/10/8.
//  Copyright © 2019 xiaofengmin. All rights reserved.
//

import Foundation
import FMDB

//don'nt need regist Table
//todo list 1 多个 db 的场景需要处理 CTPersistanceDatabasePool
//todo list 2 生成语句 拆分到 querycommand
//todo list 3 delete 单一行内容的方法
//todo list 4 CTPersistanceTableProtocol
//todo list 5 CTPersistanceTable table定义标准化

class DataBaseManager: NSObject {
    //todo xiaofengmin 多个db的情况下, 不能直接使用 shared 单一 db, 而应该 shared db list
    static let shared = DataBaseManager() //todo 弄到外部
    
    //todo xiaofengmin 存在多个db 的c场景需要处理下
    private let databaseFileName = "dataBase.sqlite"
    private var pathToDatabase:String!
    private var database:FMDatabase!
    private var tables:[DataBaseTableProtocol]!
    
    override init() {
        super.init()
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        pathToDatabase = documentDirectory.appending("/\(databaseFileName)")
        //todo alse can use bundle
    }
    
    func registTable(_ table:DataBaseTableProtocol) -> Void {
        //table
        tables.append(table)
    }
    
    /// open database 程序启动流程结束后就加入
    func databaseAction() {
        //遍历注册的table 并进行open
        //如果database 已经存在了, 则需要对单一表进行判断是否存在, 不存在则进行创建
        //第一次打开的话 直接创造所有表格
        _ = openDatabase()
    }
    
    private func openDatabase() -> Bool {
        var created = false
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase)
            if database != nil {
                if database.open() {
                    var createSql = ""
                    
                    //直接一次遍历全部创建
                    for table in tables {
                        //todo xiaofengmin remove query command
                        createSql += table.createSql
                    }
                    
                    if database.executeStatements(createSql) {
                        XLog("数据库初始化成功")
                        created = true
                    } else {
                        created = false
                        XLog("数据库创建失败")
                        XLog("Failed to insert initial data into the database.")
                        XLog("\(database.lastError()), \(database.lastErrorMessage())")
                    }
                } else {
                    XLog("数据库打开失败")
                }
            }
        } else {
            do {
                if database == nil {
                    if FileManager.default.fileExists(atPath: pathToDatabase) {
                        database = FMDatabase(path: pathToDatabase)
                    }
                }
                
                if database != nil {
                    if database.open() {
                        //                    created = true
                        for table in tables {
                            let existSql = "select count(name) as countNum from sqlite_master where type = 'table' and name = \(table.tableName)"
                            let results = try database.executeQuery(existSql, values: nil)
                            if results.next() {
                                let count = results.int(forColumn: "countNum")
                                XLog("table:\(table.tableName), count:\(count)")
                                
                                if count != 1 {
                                    created = creatTable(table)
                                }
                                
                                guard created else {
                                    break
                                }
                            }
                        }
                    }
                }
            } catch {
                XLog(error.localizedDescription)
            }
        }
        
        return created
    }
    
    private func creatTable(_ table :DataBaseTableProtocol) -> Bool {
        let sql = table.createSql
        var result = false
        //数据库是否被打开
        if database.open() {
            
            if database.executeStatements(sql) {
                
                XLog("数据库创建成功")
                result = true
            }else{
                XLog("数据库创建失败")
                XLog("Failed to insert initial data into the database.")
                XLog("\(database.lastError()), \(database.lastErrorMessage())")
            }
        }else{
            XLog("数据库打开失败")
        }
        return result
    }
    
    
    func insertPlatformData(_ table :DataBaseTableProtocol, insertSql:String!, dataAry:[Any]!) -> Bool {
        var result = false
        if openDatabase() {
            let res = database.executeUpdate(insertSql, withArgumentsIn: dataAry)
            if res {
                result = true
            } else {
                XLog(database.lastError(), file: database.lastErrorMessage())
            }
        }
        return result
    }
    
    
    func updatePlatformData(_ table :DataBaseTableProtocol, updateSql:String, dataArray: [Any]) -> Bool {
        var result = false
        if dataArray.count == 0 {
            return result
        }
        if openDatabase() {
            do {
                result = true
                
                try database.executeQuery(updateSql, values: dataArray)
            } catch {
                result = false
                XLog("更新失败")
                XLog(error.localizedDescription)
            }
        }
        return result
    }
    
    
    func searchPlatformData(_ table :DataBaseTableProtocol, searchSql:String, parseFunc:(FMResultSet) -> Any) -> [Any]! {
        //返回值类型
        //todo Any 不合适, 应该使用指定的类型
        var dataAry:[Any] = []
        
        if openDatabase() {
            do {
                let result = try database.executeQuery(searchSql, values: nil)
                
                while result.next() {
                    let resultDic = parseFunc(result)
                    dataAry.append(resultDic)
                }
                
            } catch {
                XLog(searchSql)
                XLog(error.localizedDescription)
            }
        }
        return dataAry
    }
    
    func deleteAllData(_ table:DataBaseTableProtocol, delSql:String!) {
        if openDatabase() {
            if !database.executeStatements(delSql) {
                XLog("Failed to insert initial data into the database.")
                XLog("\(database.lastError()), \(database.lastErrorMessage())")
            }
        }
    }
}


protocol DataBaseTableProtocol {
    
    var databaseName:String { get }
    var tableName:String { get }
    var columnInfo:[String:String] { get }
    //todo recordClass
    var primaryKeyName:String { get }
    
    //todo remove
//    var createSql:String { get }
    
    func regist()
    
    // todo xfm c初始化可以使用aop 直接注入, 或者使用 +load 之类的方式
    /// 初始化的同时注册
    /// - Parameter regist: 是否注册进入 数据库中
    init(needRegist:Bool)
}


extension DataBaseTableProtocol {
    func regist() {
        DataBaseManager.shared.registTable(self);
    }
}


protocol DataBaseActionProtocol {
    associatedtype protocolElemet
    associatedtype searchMethod
    
    func insertTable(dataArray:[protocolElemet], complete:((Bool) -> Void)?)
    func updateTable(dataArray:[protocolElemet], complete:((Bool) -> Void)?)
    func searchTableData(searchMethod:searchMethod, value:Any!, complete:(([protocolElemet]) -> Void)?)
    func deleteTableData()
}


enum keyType:CustomStringConvertible {
    
    case primary;
    
    case integer;
    case text;
    //    case float;
    //    case Blob;
    
    case nullable;
    case notnullable;
    
    var description: String {
        switch self {
            
        case .primary:
            return "primary key"
            
        case .integer:
            return "integer"
            //        case .float:
        //            return "float"
        case .text:
            return "text"
        case .nullable:
            return ""
        case .notnullable:
            return "not null"
        }
    }
}

//
//  StockCodeTable.swift
//  XIMReader
//
//  Created by xiaofengmin on 2019/10/8.
//  Copyright © 2019 xiaofengmin. All rights reserved.
//

import UIKit

//todo xiaofengmin queryCommand -> string
//todo xiaofengmin     _database = [[CTPersistanceDatabasePool sharedInstance] databaseWithName:self.databaseName swiftModuleName:self.swiftModuleName];
//CTPersistanceRecordProtocol
class StockCodeTable: NSObject, DataBaseTableProtocol, DataBaseActionProtocol {
    
    //todo xiaofengmin 这里改用 枚举类型, 每多建立一个数据库, 则枚举对象 + 1
    //枚举对象 通过 string:obj 存储到 dbManager 中
    //db manager 通过 字典取值的方式 查找对应的 table
    
    var databaseName: String = "dataBase.sqlite"
    
    var tableName = "stockCodeTable"
    
    //todo xiaofengmin list
    //初始化方法
    var columnInfo = [
        "stockcode":"\(keyType.text) \(keyType.primary) \(keyType.notnullable)",
        "stockname":"\(keyType.text) \(keyType.notnullable)",
        "stockmarket":"\(keyType.integer)"
    ]
    
    var primaryKeyName = "stockcode"
    
//    var createSql = "create table \(tableName) (stockcode text primary key not null, stockname text not null, stockmarket integer)"
    
    typealias protocolElemet = Stock
    
    
    typealias searchMethod = stockSearch
    
    func insertTable(dataArray: [Stock], complete: ((Bool) -> Void)?) {
        for stock in dataArray {
            let sql = "INSERT INTO \(tableName) (stockcode, stockname, stockmarket) VALUES (?,?,?)"
            let info = [stock.stockCode!, stock.stockName!, stock.stockMarket ?? 0] as [Any]
            let result = DataBaseManager.shared.insertPlatformData(self, insertSql: sql, dataAry: info)
            complete?(result)
        }
    }
    
    func updateTable(dataArray: [Stock], complete: ((Bool) -> Void)?) {
        if dataArray.count == 0 {
            return
        }
        
        for stock in dataArray {
            let query = "update \(tableName) set stockname=?, stockmarket=? where stockcode=?"
            let info = [stock.stockName!, stock.stockMarket ?? 0, stock.stockCode!] as [Any]
            let result = DataBaseManager.shared.updatePlatformData(self, updateSql: query, dataArray: info)
            
            complete?(result)
        }
        
    }
    
    func searchTableData(searchMethod: stockSearch, value: Any!, complete: (([Stock]) -> Void)?) {
        let query = "select * from \(tableName) where \(searchMethod.description) = \(value!)"
        let resultAry = DataBaseManager.shared.searchPlatformData(self, searchSql: query) { (FMResultSet) -> Any in
            var stock = Stock.init()
            stock.stockCode = FMResultSet.string(forColumn: "stockcode")
            stock.stockName = FMResultSet.string(forColumn: "stockname")
            stock.stockMarket = Int(FMResultSet.int(forColumn: "stockmarket"))
            return stock
        }
        complete?(resultAry as! [Stock])
    }
    
    ///todo 这里使用封装好的delete
    func deleteTableData() {
        DataBaseManager.shared.deleteAllData(self, delSql: "DELETE FROM \(tableName)")
    }
    
    required init(needRegist: Bool) {
        super.init()
        if needRegist {
            regist()
        }
    }

}

struct Stock {
    var stockName:String!
    var stockCode:String!
    var stockMarket:Int?
}

enum stockSearch:CustomStringConvertible {
    case stockCode
    case stockName
    case stockMarket
    var description: String {
        switch self {
        case .stockCode:
            return "stockcode"
        case .stockName:
            return "stockname"
        case .stockMarket:
            return "stockmarket"
        }
    }
}

//
//  OtherCodeTable.swift
//  XIMReader
//
//  Created by xiaofengmin on 2019/10/8.
//  Copyright © 2019 xiaofengmin. All rights reserved.
//

import UIKit

class OtherCodeTable: NSObject, DataBaseTableProtocol, DataBaseActionProtocol {
    
    static let tableName = "OtherCodeTable"
    
    var name = tableName
    
    var createSql = "create table \(tableName) (stockcode text primary key not null, stockname text not null, stockmarket integer)"
    
    typealias protocolElemet = otherCodeInfo
    typealias searchMethod = stockSearch
    
    func insertTable(dataArray: [otherCodeInfo], complete: ((Bool) -> Void)?) {
        for stock in dataArray {
            let sql = "INSERT INFO \(name) (stockcode, stockdesc, stockvalue) VALUES (?,?,?)"
            let info = [stock.stockCode!, stock.stockDescription!, stock.stockValue ?? 0] as [Any]
            let result = DataBaseManager.shared.insertPlatformData(self, insertSql: sql, dataAry: info)
            complete?(result)
        }
    }
    
    func updateTable(dataArray: [otherCodeInfo], complete: ((Bool) -> Void)?) {
        if dataArray.count == 0 {
            return
        }
        
        for stock in dataArray {
            let query = "update \(name) set stockname=?, stockmarket=? where stockcode=?"
            let info = [stock.stockDescription!, stock.stockValue ?? 0, stock.stockCode!] as [Any]
            let result = DataBaseManager.shared.updatePlatformData(self, updateSql: query, dataArray: info)
            
            complete?(result)
        }
        
    }
    
    func searchTableData(searchMethod: stockSearch, value: Any!, complete: (([otherCodeInfo]) -> Void)?) {
        let query = "select * from \(name) where \(searchMethod.description) = \(value!)"
        let resultAry = DataBaseManager.shared.searchPlatformData(self, searchSql: query) { (FMResultSet) -> Any in
            var stock = otherCodeInfo.init()
            stock.stockCode = FMResultSet.string(forColumn: "stockcode")
            stock.stockDescription = FMResultSet.string(forColumn: "stockname")
            stock.stockValue = Int(FMResultSet.int(forColumn: "stockmarket"))
            return stock
        }
        complete?(resultAry as! [otherCodeInfo])
    }
    
    func deleteTableData() {
        DataBaseManager.shared.deleteAllData(self, delSql: "DELETE FROM \(name)")
    }
    
    required init(needRegist: Bool) {
        super.init()
        if needRegist {
            regist()
        }
    }

}

struct otherCodeInfo {
    var stockDescription:String!
    var stockCode:String!
    var stockValue:Int?
}


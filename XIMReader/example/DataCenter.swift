//
//  DataCenter.swift
//  XIMReader
//
//  Created by xiaofengmin on 2019/10/8.
//  Copyright © 2019 xiaofengmin. All rights reserved.
//

import UIKit

class DataCenter: NSObject {
    static let shared = DataCenter()
    var stockTable = StockCodeTable.init(needRegist: true)
    var otherTable = OtherCodeTable.init(needRegist: true)
    
    // todo xiaofengmin
    func createNewItem() -> UIView {
        return UIView.init()
    }
    
    func insert(ItemView:UIView) {
//        stockTable.insertTable(dataArray: [Stock]) { (Bool) in
//            
//        }
    }
    
    func updateItemFromDataCenter(ItemView:UIView) {
        
    }
    
    func updateItemToDataCenter(ItemView:UIView) {
        
    }
    
    func deleteItem(ItemView:UIView) {
        
    }
    
    
    func fetchListWithStock(stockCode:String!) -> [Any] {
        var stockAry = stockTable.searchTableData(searchMethod: .stockCode, value: stockCode, complete: nil)
        var otherAry = otherTable.searchTableData(searchMethod: .stockCode, value: stockCode, complete: nil)
        
        //merage stockAry & otherAry
        //todo xiaofengmin
        return []
    }
}

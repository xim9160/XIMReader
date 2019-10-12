//
//  XMLparse.swift
//  XIMReader
//
//  Created by xiaofengmin on 2019/9/26.
//  Copyright © 2019 xiaofengmin. All rights reserved.
//

import Foundation
import Alamofire
import Fuzi

let content = "https://www.biqugex.com/book_139/24806200.html"
let contentXpath = "//*[@id=\"content\"]"

func downloadMap() -> Void {
    let req = Alamofire.request("https://www.biqugex.com/book_139/").response { (DefaultDataResponse) in
//        let data = DefaultDataResponse.data
//        let cfEncoding = CFStringEncodings.GB_18030_2000
//        let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))
//        let dataString = String(data: data!, encoding: String.Encoding(rawValue: encoding));

        if let document = try? HTMLDocument(string: DefaultDataResponse.data!.gbkString) {
//            if let root = document.root {
////                print("Root Element \(String(describing: root.tag))")
//            }
            if let content = document.firstChild(xpath: "/html/body/div[4]")
                ///html/body/div[5]/dl/dd[8]
                ///html/body/div[5]/dl/dd[11]
            {
                var contentAry = content.firstChild(xpath: "dl")?.children
                for child in contentAry! {
                    if let cc = child.children.first {
                        print(cc["href"]!)
                    }
                    print(child.stringValue)
//                    print("[href]:\(child["href"])")
                    
                }
//                var contentString = ""
//                var contentAry = content.childNodes(ofTypes: [XMLNodeType.Text])
//                contentAry.removeLast()
//                contentAry.removeLast()
//                for contentLine in contentAry {
//                    contentString = "\(contentString)\(contentLine)"
//                }
//                print(contentString)
            }
        }
        
    }
    debugPrint(req)
}


extension String {
    init?(gbkData: Data) {
        //获取GBK编码, 使用GB18030是因为它向下兼容GBK
        let cfEncoding = CFStringEncodings.GB_18030_2000
        let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))
        //从GBK编码的Data里初始化NSString, 返回的NSString是UTF-16编码
        if let str = NSString(data: gbkData, encoding: encoding) {
            self = str as String
        } else {
            return nil
        }
    }
    
    var gbkData: Data {
        let cfEncoding = CFStringEncodings.GB_18030_2000
        let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))
        let gbkData = (self as NSString).data(using: encoding)!
        return gbkData
    }
    
}

extension Data {
    var gbkString:String {
        let cfEncoding = CFStringEncodings.GB_18030_2000
        let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))
        let dataString = String(data: self as Data, encoding: String.Encoding(rawValue: encoding))!
        return dataString
    }
}

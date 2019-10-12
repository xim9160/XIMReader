//
//  Common.swift
//  XIMReader
//
//  Created by xiaofengmin on 2019/9/25.
//  Copyright © 2019 xiaofengmin. All rights reserved.
//

import Foundation
import UIKit

func RGB(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a:CGFloat?) -> UIColor {
    return UIColor(red: r, green: g, blue: b, alpha: a ?? 1)
}

func kHexOfColor(hexString:String) ->UIColor{
    
    var cstr = hexString.trimmingCharacters(in:  CharacterSet.whitespacesAndNewlines).uppercased() as NSString;
    
    if(cstr.length < 6){
        
        return UIColor.clear;
        
    }
    
    if(cstr.hasPrefix("0X")){
        
        cstr = cstr.substring(from:2) as NSString
        
    }
    
    if(cstr.hasPrefix("#")){
        
        cstr = cstr.substring(from:1) as NSString
        
    }
    
    if(cstr.length != 6){
        
        return UIColor.clear;
        
    }
    
    var range = NSRange.init()
    
    range.location=0
    
    range.length=2
    
    
    
    //red
    
    let rStr = cstr.substring(with: range);
    
    //green
    
    range.location=2;
    
    let gStr = cstr.substring(with: range)
    
    //blue
    
    range.location=4;
    
    let bStr = cstr.substring(with: range)
    
    var r :UInt32=0x0;
    
    var g :UInt32=0x0;
    
    var b :UInt32=0x0;
    
    
    Scanner.init(string: rStr).scanHexInt32(&r);
    
    Scanner.init(string: gStr).scanHexInt32(&g);
    
    Scanner.init(string: bStr).scanHexInt32(&b);
    
    return UIColor(red:CGFloat(r)/255.0, green:CGFloat(g)/255.0, blue:CGFloat(b)/255.0, alpha:CGFloat(1.0))
    
}

public let kWidth = UIScreen.main.bounds.size.width
public let kHeight =  UIScreen.main.bounds.size.height

public let bgColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)









func XLog<T>(_ message:T,file:String = #file,funcName:String = #function,lineNum:Int = #line){
    
    #if DEBUG
    
    let file = (file as NSString).lastPathComponent;
    
    print("\(file):(\(lineNum))--\(message)");
    
    #endif
    
    
}

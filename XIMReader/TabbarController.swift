//
//  TabbarViewController.swift
//  XIMReader
//
//  Created by xiaofengmin on 2019/10/15.
//  Copyright © 2019 xiaofengmin. All rights reserved.
//

import Foundation
import UIKit

class TabbarController: UITabBarController {

    var isRefreshing:Bool = false
    
    @objc func setIsRefreshing(_ refresh:Bool) -> Void {
        isRefreshing = refresh
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildControllers()
        tabBar.isTranslucent = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//extension 类似于OC中的分类，在Swift中还可以用来切分代码块
//可以把相近功能的函数，放在一个extension中
//注意：和OC的分类一样，extension中不能定义属性
//MARK: -设置界面
extension TabbarController {
    
    /// 设置所有子控制器
    private func setupChildControllers(){
        let array = [
            ["clsName":"HomeUserVC","title":"首页","imageName":"home"],
            ["clsName":"HomePageVC","title":"专栏","imageName":"find"],
            ["clsName":"RSTestNumController","title":"吾股","imageName":"find"],
            ["clsName":"RSFriendsViewController","title":"文友圈","imageName":"extend"],
            ["clsName":"MyViewController","title":"我的","imageName":"account"],
        ]
        var arrayM = [UIViewController]()
        
        for dict in array {
            arrayM.append(controller(dict: dict))
        }
        ///Use of unresolved identifier 'viewControllers'
        viewControllers = arrayM
        
        //tabbar选中背景图重新调整大小
        var imageName = "tabbar_selectedBackImage"
//        if IPhoneX {
//            imageName = "tabbar_selectedBackImageIphoneX"
//        }
        tabBar.selectionIndicatorImage = tabBarSelecedBackImage(imageName: imageName, imageSize: CGSize(width: kWidth/CGFloat((viewControllers?.count)!), height: 44))
        
        tabBar.barTintColor = .orange
        
    }
    
    /// 使用字典创建一个子控制器
    ///
    /// - Parameter dict: 信息字典
    /// - Returns: 子视图控制器
    private func controller(dict: [String: String])->UIViewController{
        
        //1,取得字典内容
        //guard语句判断其后的表达式布尔值为false时，才会执行之后代码块里的代码，如果为true，则跳过整个guard语句
        guard
            let clsName = dict["clsName"],
            let title = dict["title"],
            let imageName = dict["imageName"],
            //命名空间 项目的名字 + "." + "类名"
//            let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String 不是 main bundle
            let cls = NSClassFromString(clsName) as? UIViewController.Type
        else{
            return UIViewController()
        }
        
        let path = Bundle.main.path(forResource: "Frameworks/ShiZhiFengYunForum.framework/ShiZhiFengYunBundle", ofType: "bundle")
        let bundle = Bundle(path: path ?? "")
        
//        let bundle2 = Bundle(for: cls)
//        let img = UIImage.init(named: "bad_select@2x.png", in: bundle, compatibleWith: nil)
//        let img2 = UIImage(named: "bad_select", in: bundle, compatibleWith: nil)
        
        //2.创建视图控制器
        let vc = cls.init()
        
        vc.title = title
        //3.设置图像
        vc.tabBarItem.image = UIImage(named:imageName + "_normal")?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlight")?.withRenderingMode(.alwaysOriginal)
        //4.设置tabBar的标题字体(大小)
        vc.tabBarItem.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .normal)
        vc.tabBarItem.setTitleTextAttributes([.foregroundColor : UIColor.gray], for: .highlighted)
        //系统默认是12号字，修改字体大小，要设置Normal的字体大小
        //vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12)], for: .normal)
        //5.设置tabbarItem选中背景图
        //实例化导航控制器的时候，会调用重载的push方法 将rootVC进行压栈
//        let nav = SLNavigationController(rootViewController: vc)
        let nav = UINavigationController(rootViewController: vc)
        
        return nav
        
    }
    func tabBarSelecedBackImage(imageName:String,imageSize:CGSize) ->  UIImage {
        let originalImage = UIImage(named: imageName)
        let rect : CGRect = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        UIGraphicsBeginImageContext(rect.size)
        originalImage?.draw(in: rect)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return image
    }
}

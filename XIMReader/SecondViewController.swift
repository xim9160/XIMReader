//
//  SecondViewController.swift
//  XIMReader
//
//  Created by xiaofengmin on 2019/9/25.
//  Copyright © 2019 xiaofengmin. All rights reserved.
//

import UIKit
import ShiZhiFengYunForum

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = XIMStdC.init()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let c = Bundle.allFrameworks
//        let t = Bundle.allBundles
//        let s = Bundle.main.loadNibNamed("ShiZhiFengYunForum.framework/PageControlView.nib", owner: nil, options: nil);
//        print("ssss\(String(describing: s))")
//        let vc = MyViewController.init()
        let vc = RSFriendsViewController.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

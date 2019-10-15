//
//  ThirdViewController.swift
//  XIMReader
//
//  Created by xiaofengmin on 2019/10/12.
//  Copyright © 2019 xiaofengmin. All rights reserved.
//

import UIKit
import SubmoduleDemo
import FMDB
import Kingfisher
import WebKit
import SnapKit

//todo: need equal
//let wogooWebUrl = "http://www.wogoo.com/server/szfyApi/data/rankV?TOKEN=04a8098f69d74da29ba3bc2b46071f03&w=375&h=554"
let wogooWebUrl = "http://data.wogoo.com/rank/#/page"


class ThirdViewController: UIViewController {

    lazy var webView:WKWebView = {
        var webView = WKWebView.init()

        webView.load(URLRequest.init(url: URL.init(string: wogooWebUrl)!))
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        if #available(iOS 11 , *) {
            webView.scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        webView.configuration.userContentController.add(self, name: "")
        
        self.view.addSubview(webView)
        
        return webView
    }()

    @objc func loadWebView() {
        webView.load(URLRequest.init(url: URL.init(string: wogooWebUrl)!))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SubmoduleTestObj.init().print("66666666")
        
        self.webView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self.view)
            maker.top.equalTo(self.view).offset(44)
        }
    }

}

extension ThirdViewController: WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        XLog("加载 ArticleDetailVC")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        XLog("开始加载")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        XLog("加载中")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        XLog("加载结束")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        XLog("加载失败")
    }
    
}

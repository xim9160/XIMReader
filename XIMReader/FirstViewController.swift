//
//  FirstViewController.swift
//  XIMReader
//
//  Created by xiaofengmin on 2019/9/25.
//  Copyright © 2019 xiaofengmin. All rights reserved.
//

import UIKit
import Alamofire
import Fuzi

let itemIdentifity = "book_identifity"

class FirstViewController: UIViewController {
    
    var bookShelf:UICollectionView? // TODO: refresh
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        DBAction(FMDBManager)
        FMDBManager.shared.DBAction()
//        downloadMap()
//        self.XMLParse()
//        self.creatCollectViewContrlloer()
//        self.updateNavigation()
        // Do any additional setup after loading the view.
    }
    
    func XMLParse(){
        let path = Bundle.main.path(forResource: "nutrition", ofType: "xml")
        let url = URL(fileURLWithPath: path!)
        
//        let xml = try! String(contentsOf: url)
        do {
            let data = try! Data(contentsOf: url)
            let document = try! XMLDocument(data: data)
            
            if let root = document.root {
                print(root.tag!)
                
                // define a prefix for a namespace
                document.definePrefix("atom", defaultNamespace: "http://www.w3.org/2005/Atom")

                // get first child element with given tag in namespace(optional)
//                print(root.firstChild(tag: "title", inNamespace: "atom") as Any)
                var xpath = "//food/name"
                for element in document.xpath(xpath) {
                    print("\(element)")
                }
                
                // iterate through all children
                for element in root.children {
                    print("\(String(describing: index)) \(String(describing: element.tag)): \(element.attributes)")
                }
            }
            
            
            
        } catch let error as XMLError {
            switch error {
            case .noError: print("no error")
            case .parserFailure, .invalidData: print("error")
            case .libXMLError(let code, let msg): print("libxml error with:\(code) \(msg)")
            case .xpathError(let code):
                print("\(code)")
            }
        }
    }

}

// MARK: - collectionView
extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func creatCollectViewContrlloer() -> Void {
        
        let itemWidth = kWidth / 3 - 2 * 16
        let itemHeight = 1.6 * itemWidth;
        
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumInteritemSpacing = 8.0
        flowLayout.minimumLineSpacing = 8.0
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        flowLayout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
//        bookShelf = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHeight))
        bookShelf = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHeight), collectionViewLayout: flowLayout);
        bookShelf?.delegate = self
        bookShelf?.dataSource = self
        //todo mas
        
        bookShelf?.backgroundColor = bgColor
        
        bookShelf?.register(XIMBookItem.self, forCellWithReuseIdentifier: itemIdentifity)
        
        self.view.addSubview(bookShelf!)
//        bookShelf?.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var item =   collectionView.dequeueReusableCell(withReuseIdentifier: itemIdentifity, for: indexPath) as? XIMBookItem
        //todo list sub cLass
        if item == nil {
            item = XIMBookItem.init()
            item?.masSubviews()
        }
        
        let random1 = CGFloat(arc4random()%255)
        let random2 = CGFloat(arc4random()%255)
        let random3 = CGFloat(arc4random()%255)
        
        item?.bookState = XIMBookState.init(imgName: "1222", title: "book\(indexPath.row)", writeState: "0.00", readState: "0.00")
        
        item?.backgroundColor = RGB(random1, random2, random3, 1)
        
        return item!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
}

extension FirstViewController {
    func updateNavigation() {

        self.title = bookShelf_title_test
        
        let lItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editAction))

        self.navigationItem.leftBarButtonItem = lItem
        
        let rItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchAction))
        
        self.navigationItem.rightBarButtonItem = rItem
        
    }
    
    @objc func editAction() {
        print("edit")
    }
    
    @objc func searchAction() {
        print("search")
//        Alamofire.request("https://www.jianshu.com/p/f8c3adb056cf").response { (DefaultDataResponse) in
//            print("\(DefaultDataResponse)")
//        }
        let request = Alamofire.request("https://httpbin.org/get").responseJSON { (DataResponse) in
//            print(DataResponse.result)
//            print("\r\n-------------------\r\n")
//            print(DataResponse.response)
//            print("\r\n-------------------\r\n")
//            print(DataResponse.data)
//            print("\r\n-------------------\r\n")
//            print(DataResponse.result)
//            print("\r\n-------------------\r\n")
//
//            if let JSON = DataResponse.result.value {
//                print("JSON:\(JSON)")
//            }
        }
        
//        print(request)
//        debugPrint(request)
        
    }
    
}

public struct XIMBookState {
    public var imgName:String,
    title:String,
    writeState:String,
    readState:String
    
//    public init
}

class XIMBookItem: UICollectionViewCell {
//    lazy var imgView:UIImageView = UIImageView(frame: .zero).then {
//        $0.bac
//    }
    
    lazy var imgView: UIImageView = {
        let view = UIImageView(frame: .zero)
        self.addSubview(view)
        return view
    }()
    
    lazy var titleLabel:UILabel? = {
        let view = UILabel(frame: .zero)
        self.addSubview(view)
        return view
    }()
    
    lazy var writeStateLabel:UILabel? = {
        let view = UILabel(frame: .zero)
        self.addSubview(view)
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    lazy var readStateLabel:UILabel? = {
        let view = UILabel(frame: .zero)
        self.addSubview(view)
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    
    var bookState:XIMBookState?{
        didSet{
            imgView.image = UIImage.init(named: bookState!.imgName)
            titleLabel?.text = bookState!.title
            writeStateLabel?.text = bookState!.writeState
            readStateLabel?.text = bookState!.readState
            
            self.masSubviews()
        }
    }
    
    func masSubviews() {
        let sFrame = self.frame
        imgView.frame = CGRect(x: 0, y: 0, width: sFrame.size.width, height: sFrame.size.height - 32)
        imgView.backgroundColor = .red
        titleLabel?.frame = CGRect(x: 0, y: sFrame.size.height - 32, width: sFrame.size.width, height: 16)
        writeStateLabel?.frame = CGRect(x: 0, y: sFrame.size.height - 16, width: sFrame.size.width / 5, height: 16)
        readStateLabel?.frame = CGRect(x: sFrame.size.width / 5, y: sFrame.size.height - 16, width: sFrame.size.width / 5 * 4, height: 16)
    }
    
}

// TODO: BOOK DETAIL

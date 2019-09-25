//
//  FirstViewController.swift
//  XIMReader
//
//  Created by xiaofengmin on 2019/9/25.
//  Copyright © 2019 xiaofengmin. All rights reserved.
//

import UIKit

let itemIdentifity = "book_identifity"

class FirstViewController: UIViewController {
    
    var bookShelf:UICollectionView? // TODO: refresh
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creatCollectViewContrlloer()
        self.updateNavigation()
        // Do any additional setup after loading the view.
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

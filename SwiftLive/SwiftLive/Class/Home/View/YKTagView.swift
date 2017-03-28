//
//  YKTagView.swift
//  SwiftLive
//
//  Created by sunny on 2017/3/28.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import UIKit

let cellIdentifier: String! = "YKTagView_CELL_IDENTIFIER"

class YKTagView: UIView , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    public var dataSource: [String] = []
    fileprivate lazy var collectionView: UICollectionView = {
        [weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 45, height: 18)
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets.zero
        let collectionView = UICollectionView(frame: (self?.bounds)!, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.bounces = true
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(YKTagViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubviews()
    }
    
    func setupSubviews() {
        self.addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = self.bounds
    }

}

extension YKTagView {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! YKTagViewCell)
        cell.titleLabel.text = self.dataSource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // DO: 计算文字长度
        
        
        return CGSize(width: 45, height: 18)
    }
}



class YKTagViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = self.bounds
        titleLabel.layer.cornerRadius = self.frame.height / 2
    }
    
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: self.frame)
        titleLabel.backgroundColor = UIColor.white
        titleLabel.layer.borderWidth = 1
        titleLabel.layer.borderColor = THEME_COLOR.cgColor
        titleLabel.textColor = THEME_COLOR
        titleLabel.font = UIFont.systemFont(ofSize: 11)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private func setupUI() {
        self.backgroundColor = UIColor.orange
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


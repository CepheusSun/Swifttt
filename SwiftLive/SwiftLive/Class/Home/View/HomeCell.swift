//
//  HomeCell.swift
//  SwiftLive
//
//  Created by sunny on 2017/3/22.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

    
    @IBOutlet weak var avatorImageview: UIImageView!
    
    @IBOutlet weak var creatorNickName: UILabel!
    
    @IBOutlet weak var viewerCountLabel: UILabel!
    
    @IBOutlet weak var bigImageView: UIImageView!
    
    @IBOutlet weak var liveTag: UIImageView!
    // 相当于这个直播的标题
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var tagView: YKTagView!
    var model: HomeLiveModel! {
        didSet {
            if !model.creator.portrait.hasPrefix("http") {
                model.creator.portrait = "http://img2.inke.cn/\(model.creator.portrait)"
            }
            let imgUrl = URL(string: (model.creator.portrait))
            self.avatorImageview.kf.setImage(with: imgUrl)
            self.viewerCountLabel.text = "\(model.onlineUsers!)"
            self.bigImageView.kf.setImage(with: imgUrl)
            self.creatorNickName.text = model.creator.nick
            self.nameLabel.text = model.name!
            self.liveTag.isHidden = !(model.status == 1)
            self.tagView.dataSource = model.extra.label.map{
                return $0.tabName
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatorImageview.layer.masksToBounds = true
    }
    
    static let identifier: String = "HomeCell"
    class func cell(with tableview:UITableView!) -> HomeCell! {
        var cell  = tableview.dequeueReusableCell(withIdentifier: HomeCell.identifier)
        if cell == nil {
            cell = Bundle.main.loadNibNamed(HomeCell.identifier, owner: nil, options: nil)?.first as! UITableViewCell?
        }
        return cell as! HomeCell!
    }
    
    
}

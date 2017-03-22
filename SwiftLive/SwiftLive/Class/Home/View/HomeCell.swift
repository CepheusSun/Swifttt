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
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var bigImageView: UIImageView!
    
    var model: HomeModel! {
        didSet {
            let imgUrl = URL(string: (model.portrait))
            self.avatorImageview.kf.setImage(with: imgUrl)
            self.addressLabel.text = model.location.isEmpty ? "": model.location
            self.viewerCountLabel.text = "\(model.viewers)"
            self.bigImageView.kf.setImage(with: imgUrl)
            self.creatorNickName.text = model.nick
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

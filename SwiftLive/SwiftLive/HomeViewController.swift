//
//  ViewController.swift
//  SwiftLive
//
//  Created by sunny on 2017/3/22.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import UIKit
import Just
import Kingfisher

class HomeViewController: UIViewController ,
UITableViewDelegate,
UITableViewDataSource,
UIViewControllerTransitioningDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    let liveListUrl = "http://service.ingkee.com/api/live/gettop?imsi=&uid=17800399&proto=5&idfa=A1205EB8-0C9A-4131-A2A2-27B9A1E06622&lc=0000000000000026&cc=TG0001&imei=&sid=20i0a3GAvc8ykfClKMAen8WNeIBKrUwgdG9whVJ0ljXi1Af8hQci3&cv=IK3.1.00_Iphone&devi=bcb94097c7a3f3314be284c8a5be2aaeae66d6ab&conn=Wifi&ua=iPhone&idfv=DEBAD23B-7C6A-4251-B8AF-A95910B778B7&osversion=ios_9.300000&count=5&multiaddr=1"
    
    var dataSource: [HomeModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.loadList()
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(loadList), for: .valueChanged)
        
        self .setupPushStreamButton()
    }
    
    func setupPushStreamButton() {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: UIScreen.main.bounds.size.width - 100,
                              y:  UIScreen.main.bounds.size.height - 100,
                              width: 60,
                              height: 60)
        
        button.addTarget(self, action: #selector(pushToStreamPage(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 30
        button.setBackgroundImage(#imageLiteral(resourceName: "add"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.addSubview(button)
    }
    
    
    // 推流相关操作
    func pushToStreamPage(sender: UIButton) {
        
    }

    func loadList() {
        Just.post(liveListUrl) { r in
            guard let json = r.json as? NSDictionary else {
                return
            }
            let lives: [NSDictionary] = json.object(forKey: "lives") as! [NSDictionary]
            self.dataSource = lives.map({ (live) -> HomeModel in
                return HomeModel(portrait: (live.object(forKey: "creator") as! NSDictionary).object(forKey: "portrait") as! String,
                                 nick: (live.object(forKey: "creator") as! NSDictionary).object(forKey: "nick") as! String,
                                 location: live.object(forKey: "city") as! String,
                                 viewers: live.object(forKey: "online_users") as! Int,
                                 url: live.object(forKey: "stream_addr") as! String)
            })
            
            OperationQueue.main.addOperation {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }

    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HomeCell.cell(with: tableView)
        cell?.model = dataSource[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = LiveViewController()
        vc.model = dataSource[indexPath.row]
        vc.transitioningDelegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentPushAnimation()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentPushAnimation()
    }
    
}

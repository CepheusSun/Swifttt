//
//  ViewController.swift
//  SwiftLive
//
//  Created by sunny on 2017/3/22.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import UIKit
import Kingfisher
import ESPullToRefresh
import RxSwift
import RxCocoa

struct HomeCellSection {
    var header: String
    var item: [HomeLiveModel]
}

class HomeViewController: UIViewController, SYCarouselViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: [HomeLiveModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = carouselView
        self.bindViewModel()
    }
    
    var viewModel: HomeViewModel = HomeViewModel()
    // 用于回收事件序列
    var disposeBag: DisposeBag! = DisposeBag()

    lazy var carouselView: SYCarouselView = {
        let carouselView = SYCarouselView(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 3)))
        carouselView.defaultImageString = "default_ticker"
        carouselView.delegate = self
        carouselView.set(pageColor: UIColor.orange,
                         currentPageColor: UIColor.white)
        
        return carouselView
    }()
    
    func bindViewModel() {
        
        
        viewModel.closure = {[weak self] (type, res) in
            switch type {
            case .ticker:
                let tickerArray: [SYTicker] = (res as! [String:Any])["info"] as! [SYTicker]
                self?.carouselView.imageArray = tickerArray.map {
                    var string = $0.image
                    if !$0.image.hasPrefix("http") {
                        string = "http://img2.inke.cn/\($0.image!)"
                    }
                    return string!
                } 
            case .live:
                let liveArray = (res as! [String:Any])["info"] as! [HomeLiveModel]
                self?.dataSource = liveArray.map {
                    var live = $0
                    if !live.creator.portrait.hasPrefix("http") {
                        live.creator.portrait = "http://img2.inke.cn/\((live.creator.portrait)!)"
                    }
                    return live
                }
                
                self?.tableView.reloadData()
                self?.tableView.es_stopPullToRefresh()
                self?.tableView.es_stopLoadingMore()
            }
        }
        
        _ = viewModel.loadData()

        tableView.es_addPullToRefresh {
            [weak self] in
            self?.viewModel.loadData()
        }
        tableView.es_addInfiniteScrolling {
            [weak self] in
            self?.viewModel.loadMoreData()
        }
    }
}

extension HomeViewController {

    func carouselView(_ carouselView: SYCarouselView, clickImageAt index: Int) {
        
    }
}

// MARK: - 协议方法
extension HomeViewController:
    UITableViewDelegate,
    UITableViewDataSource,
    UIViewControllerTransitioningDelegate {
    
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

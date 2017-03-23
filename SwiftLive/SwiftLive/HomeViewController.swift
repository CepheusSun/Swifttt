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

class HomeViewController: UIViewController ,
UITableViewDelegate,
UITableViewDataSource,
UIViewControllerTransitioningDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: [HomeLiveModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.tableFooterView = UIView()
        self.bindViewModel()
    }
    
    
    var viewModel: HomeViewModel = HomeViewModel()
    func bindViewModel() {
        
        
        viewModel.loadHotList()
        
        tableView.es_addPullToRefresh {
            [weak self] in
            
            
            self?.tableView.es_stopPullToRefresh()
            self?.tableView.es_stopPullToRefresh(ignoreDate: false, ignoreFooter: true)
        }
        
        tableView.es_addInfiniteScrolling {
            [weak self] in
            self?.tableView.es_stopLoadingMore()
            
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

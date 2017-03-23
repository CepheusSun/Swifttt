//
//  HomeController.swift
//  SwiftLive
//
//  Created by sunny on 2017/3/23.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import UIKit
import WMPageController

class HomeController:  WMPageController{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuViewStyle       = .line
        self.showOnNavigationBar = true
        self.menuHeight          = 47
        self.menuItemWidth       = 50
        self.selectIndex         = 1
        self.progressHeight      = 10
        self.progressWidth       = 20
        self.preloadPolicy       = .neighbour
        self.titleColorNormal   = UIColor.white
        self.titleColorSelected = UIColor.white
        self.progressColor      = UIColor.white
        self.progressViewBottomSpace   = 10
        self.progressViewCornerRadius  = 5
        self.itemMargin                = 0
        self.menuView?.backgroundColor = UIColor.clear
        self.setupNavigatonBar()
        self.reloadData()
    }
    
    func setupNavigatonBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "message"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(presentToMessage))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(presentToSearch))
    }

    func presentToSearch() {
        
    }
    
    func presentToMessage() {
        
    }
    
    override var titles: [String]? {
        get {
            return ["关注","热门","附近","视频","才艺","好声音","游戏"]
        }
        set {
            super.titles = titles
        }
    }
}

extension HomeController {
    
    override func numbersOfChildControllers(in pageController: WMPageController) -> Int {
        return (titles?.count)!
    }
    
    override func pageController(_ pageController: WMPageController, titleAt index: Int) -> String {
        return titles![index]
    }
    
    override func pageController(_ pageController: WMPageController, viewControllerAt index: Int) -> UIViewController {
        return UIViewController()
    }

}

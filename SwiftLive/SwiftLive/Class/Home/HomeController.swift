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
        self.setupNavigatonBar()
    }
    
    
    class public func controller() -> HomeController {
        let vc = HomeController()
        vc.menuViewStyle       = .line
        vc.showOnNavigationBar = true
        vc.menuHeight          = 47
        vc.menuItemWidth       = 50
        vc.selectIndex         = 1
        vc.progressHeight      = 4
        vc.progressWidth       = 20
        vc.preloadPolicy       = .neighbour
        vc.titleColorNormal   = UIColor.white
        vc.titleColorSelected = UIColor.white
        vc.progressColor      = UIColor.white
        vc.progressViewBottomSpace   = 5
        vc.progressViewCornerRadius  = 2
        vc.itemMargin                = 0
        return vc
    }
    
    func setupNavigatonBar() {
        self.menuView?.backgroundColor = UIColor.clear
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

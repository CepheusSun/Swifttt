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
        self.menuViewStyle       = .line;
        self.showOnNavigationBar = true
        self.titleSizeSelected   = 13.0;
        self.titleSizeNormal     = 13.0;
        self.menuHeight          = 47;
        self.selectIndex         = 0;
        self.progressHeight      = 2;
        self.progressWidth       = 39;
        self.preloadPolicy       = .neighbour;
        self.setupNavigatonBar()
    }
    
    func setupNavigatonBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "add"), style: .plain, target: self, action: #selector(presentToSearch))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "add"), style: .plain, target: self, action: #selector(presentToSearch))
    }

    func presentToSearch() {
        
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

//
//  MNavigationController.swift
//  SwiftLive
//
//  Created by sunny on 2017/3/23.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import UIKit

class MNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = THEME_COLOR
        self.navigationBar.tintColor = UIColor.white
    }



}

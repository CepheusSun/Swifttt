//
//  String+Frame.swift
//  SwiftLive
//
//  Created by sunny on 2017/3/28.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import Foundation


// MARK: - 工具 String 计算高度和宽度
extension String {
    
    public func height(for font: UIFont!, width: CGFloat!) -> CGFloat!{
        let size = CGSize(width: width, height: 900)
        let dic = NSDictionary.init(object: font, forKey: NSFontAttributeName as NSCopying)
        let strSize = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String: AnyObject], context: nil)
        return strSize.height
    }
    
    
    public func width(for font: UIFont!, height: CGFloat!) -> CGFloat!{
        let size = CGSize(width: 900, height: height)
        let dic = NSDictionary.init(object: font, forKey: NSFontAttributeName as NSCopying)
        let strSize = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String: AnyObject], context: nil)
        return strSize.width
    }
    
}

//
//  SYCarouselView.swift
//  SwiftLive
//
//  Created by sunny on 2017/3/27.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import UIKit
import ImageIO

typealias ClickBlock = (_ index: Int) -> Void

/// pageControl 的显示位置
///
/// - Default: 默认值 == .bottomCenter
/// - hide: 隐藏
/// - topCenter: 中上
/// - bottomLeft: 左下
/// - bottomCenter: 中下
/// - bottomRight: 右下
enum PageControlPosition {
    case Default
    case hide
    case topCenter
    case bottomLeft
    case bottomCenter
    case bottomRight
}

/// 图片切换的方式
///
/// - Default: 轮播滚动
/// - fade: 淡入淡出
enum ChangeMode {
    case Default
    case fade
}

/// 代理
protocol SYCarouselViewDelegate: NSObjectProtocol {
    
    /// 改方法用来处理图片的点击,会返回图片在数组中的索引
    /// 代理与 Closure 二选一即可, 若两者都实现, block 的优先级高
    /// - Parameters:
    ///   - carouselView: 控件本身
    ///   - index: 图片索引
    func carouselView(_ carouselView: SYCarouselView, clickImageAt index: Int)
}

func gifImageNamed(imageName: String!) -> UIImage {
    var name: String = imageName
    if imageName.hasSuffix(".gif") {
        name = name.appending(".gif")
    }
    let imagePath = Bundle.main.path(forResource: name, ofType: nil)
    let data = NSData(contentsOfFile: imagePath!)
    if (data != nil) {
        
    }
    return UIImage(named: name)!
}

class SYCarouselView: UIView, UIScrollViewDelegate {

    private let VERYMARGIN: CGFloat = 5
    private let DEFAULTTIME: TimeInterval = 5
    private let HORMARGIN: CGFloat = 10
    private let DES_LABEL_H: CGFloat = 20
    
    /// 设置占位图片
    public var defaultImageString = ""
    
    /// 设置图片的切换模式, 默认为 default
    public var changeMode:ChangeMode = .Default
    
    /// 设置分页控件的位置, 只有一张的时候 默认隐藏
    public var pagePosition:PageControlPosition = .Default {
        didSet {
            if pageControl.isHidden {return}
            pageControl.isHidden = (pagePosition == .hide) || (imageArray?.count == 0)
            
            var size: CGSize
            if (pageImageSize == nil) {
                size = pageControl.size(forNumberOfPages: pageControl.numberOfPages)
                size.height = 8
            } else {
                size = CGSize(width: (pageImageSize?.width)! * CGFloat((pageControl.numberOfPages * 2 - 1)),
                              height: (pageImageSize?.height)!)
            }
            pageControl.frame = CGRect.init(origin: CGPoint(x: 0, y: 0), size: size)
            
            let centerY = self.height() - size.height * 0.5 - VERYMARGIN - (describleLabel.isHidden ? 0 : DES_LABEL_H)
            let pointY = self.height() - size.height - VERYMARGIN - (describleLabel.isHidden ? 0 : DES_LABEL_H)
            
            if pagePosition == .Default || pagePosition == .bottomCenter {
                pageControl.center = CGPoint(x: self.width() * 0.5,
                                             y: centerY)
            } else if pagePosition == .topCenter {
                pageControl.center = CGPoint(x: self.width() * 0.5,
                                             y: size.height * 0.5 + VERYMARGIN)
            } else if pagePosition == .bottomLeft {
                pageControl.frame = CGRect(x: HORMARGIN,
                                           y: pointY,
                                           width: size.width,
                                           height: size.height)
            } else {
                pageControl.frame = CGRect.init(x: self.width() - HORMARGIN - size.width,
                                                y: pointY,
                                                width: size.width,
                                                height: size.height)
            }
        }
    }
    
    /// 设置图片的内容模式，默认为 .scaleToFill
    public var carContentMode: UIViewContentMode = .scaleToFill {
        didSet {
            currImageView?.contentMode = carContentMode
            otherImageView?.contentMode = carContentMode
        }
    }
    
    fileprivate var currIndex:Int = 0
    
    /// 轮播的图片数组。
    public var imageArray:[String]? = []{
        willSet {
            if newValue?.count == 0 {
                return
            }
        }
        didSet {
            if currIndex >= (imageArray?.count)! && (imageArray?.count)! > 0{
                currIndex = (imageArray?.count)! - 1
            }
            if (imageArray?.count)! > 0 {
                let url = URL(string: (imageArray?[currIndex])!)
                self.currImageView?.kf.setImage(with: url,
                                                placeholder: UIImage(named: defaultImageString),
                                                options: nil,
                                                progressBlock: nil,
                                                completionHandler: nil);
                
                self.describleLabel.text = describeArray?[currIndex]
                self.pageControl.numberOfPages = (imageArray?.count)!
                self.layoutSubviews()
            }
        }
    }
    
    /** 图片描述的字符串数组
     *
     *  图片描述控件默认是隐藏的
     *  设置该属性,控件会显式
     *  设置为nil 或者空数组,控件会隐藏
     */
    public var describeArray:[String]? {
        didSet {
            if describeArray?.count == 0 {
                describeArray = nil
                describleLabel.isHidden = true
            } else {
                //如果描述的个数与图片个数不一致，则补空字符串
                if (describeArray?.count)! < (imageArray?.count)! {
                    let temp:Int = (imageArray?.count)! - (describeArray?.count)!
                    for _ in 0..<temp {
                        describeArray?.append("")
                    }
                }
                describleLabel.isHidden = false
                describleLabel.text = describeArray?[currIndex]
            }
            // 重新计算pageControl的位置
            let po = pagePosition
            pagePosition = po
        }
    }
    
    /// 轮播时间,默认为5s ，最少2s 低于2秒时候, 为默认值
    public var time: TimeInterval = 5
    
    /// 点击图片后要执行的操作,会返回图片在数组中的索引
    public var imageClickBlock: ClickBlock?
    
    /// 代理，用来处理图片的点击
    weak public var delegate: SYCarouselViewDelegate?
    
    // MARK - 主控件
    // MARK  scrollView
    private lazy var scrollView: UIScrollView = {
        [weak self] in
        let scrollView = UIScrollView()
        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                               action: #selector(imageClick)))
        self?.currImageView = UIImageView()
        self?.currImageView?.clipsToBounds = true
        scrollView.addSubview((self?.currImageView)!)
        self?.otherImageView = UIImageView()
        self?.otherImageView?.clipsToBounds = true
        scrollView.addSubview((self?.otherImageView)!)
        return scrollView
    }()
    
    // MARK: - 描述文字
    private lazy var describleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(white: 0, alpha: 0.5)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.isHidden = true
        return label
    }()
    // MARK: - 分页控制器
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    func imageClick() {
        if (imageClickBlock != nil) {
            self.imageClickBlock!(currIndex)
        } else if (delegate != nil) {
            self.delegate?.carouselView(self, clickImageAt: self.currIndex)
        }
    }
    
    fileprivate var currImageView: UIImageView?
    fileprivate var otherImageView: UIImageView?
    
    // MARK: - 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSubView()
    }
    
    override func awakeFromNib() {
        self.initSubView()
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - 初始化后布局
    private func initSubView() {
        self.addSubview(scrollView)
        self.addSubview(describleLabel)
        self.addSubview(pageControl)
    }
    
    // MARK: - 设置控件属性
    // MARK: 设置scrollView的contentSize
    private func setScrollViewContentSize() {
        if (imageArray?.count)! > 1 {
            scrollView.contentSize = CGSize(width: self.width() * 5,
                                            height: 0)
            scrollView.contentOffset = CGPoint(x: self.width() * 2,
                                               y: 0)
            currImageView?.frame = CGRect.init(x: self.width() * 2,
                                               y: 0,
                                               width: self.width(),
                                               height: self.height())
            
            if changeMode == .fade {
                //淡入淡出模式，两个imageView都在同一位置，改变透明度就可以了
                currImageView?.frame = CGRect.init(x: 0,
                                                   y: 0,
                                                   width: self.width(),
                                                   height: self.height())
                otherImageView?.frame = (currImageView?.frame)!
                otherImageView?.alpha = 0
                self.insertSubview(currImageView!, at: 0)
                self.insertSubview(otherImageView!, at: 1)
            }
            self.startTimer()
        } else {
            //只有一张图片时，scrollview不可滚动，且关闭定时器
            scrollView.contentSize = CGSize.zero
            scrollView.contentOffset = CGPoint.zero
            self.currImageView?.frame = CGRect.init(x: 0,
                                                    y: 0,
                                                    width: self.width(),
                                                    height: self.height())
            self.stopTimer()
        }
    }
    
    // MARK: - Timer
    private var timer: Timer?
    
    fileprivate func startTimer() {
        // 
        if (imageArray?.count)! <= 1 {
            return
        }
        if self.timer != nil {
            self.stopTimer()
        }
        let timeInterval = time < 2 ? DEFAULTTIME: time
        if #available(iOS 10.0, *) {
            self.timer = Timer.scheduledTimer(withTimeInterval: timeInterval,
                                              repeats: true,
                                              block: {[weak self] (timer) in
                                                self?.nextPage()
            })
        } else {
            self.timer = Timer.init(timeInterval: timeInterval, target: self, selector: #selector(self.nextPage), userInfo: nil, repeats: true)
            RunLoop.main.add(self.timer!, forMode: .commonModes)
        }
    }
    
    fileprivate func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    var nextIndex: Int?
    @objc private func nextPage() {
        if changeMode == .fade {
            nextIndex = (currIndex + 1) % (imageArray?.count)!
            let url = URL(string: (imageArray?[nextIndex!])!)
            otherImageView?.kf.setImage(with: url, placeholder: UIImage(named: defaultImageString),
                                        options: nil, progressBlock: nil, completionHandler: nil)
            
            UIView.animate(withDuration: 1.2, animations: { 
                self.currImageView?.alpha = 0
                self.otherImageView?.alpha = 1
                self.pageControl.currentPage = self.nextIndex!
            }, completion: { (finished) in
                self.changeToNext()
            })
        } else {
            self.scrollView.setContentOffset(CGPoint(x: self.width() * 3, y: 0), animated: true)
        }
    }
    
    
    fileprivate func changeToNext() {
        if changeMode == .fade {
            currImageView?.alpha = 1
            otherImageView?.alpha = 0
        }
        currImageView?.image = otherImageView?.image
        scrollView.contentOffset = CGPoint(x: self.width()*2, y: 0)
        scrollView.layoutSubviews()
        currIndex = nextIndex!
        pageControl.currentPage = currIndex
        describleLabel.text = describeArray?[currIndex]
    }
    
    
    // MARK:  设置图片描述控件
    private func set(describle textColor:UIColor?, font: UIFont?, backgroundColor: UIColor?) {
        self.describleLabel.textColor = textColor
        self.describleLabel.font = font
        self.describleLabel.backgroundColor = backgroundColor
    }
    
    private var pageImageSize : CGSize?
    // MARK: 设置pageControl的指示器图片
    private func set(pageControl pageImage:UIImage?, currentPageImage: UIImage?) {
        if pageImage == nil || currentPageImage == nil {
            return
        }
        pageImageSize = pageImage?.size
        pageControl.setValue(currentPageImage, forKey: "_currentPageImage")
        pageControl.setValue(pageImage, forKey: "_pageImage")
    }
    // MARK: 设置pageControl的指示器颜色
    public func set(pageColor: UIColor?, currentPageColor: UIColor?) {
        pageControl.pageIndicatorTintColor = pageColor
        pageControl.currentPageIndicatorTintColor = currentPageColor
    }
    
    
    // MARK: - frame相关
    fileprivate func height() -> CGFloat {
        return scrollView.frame.height
    }
    
    fileprivate func width() -> CGFloat {
        return scrollView.frame.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //有导航控制器时，会默认在scrollview上方添加64的内边距，这里强制设置为0
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.frame = self.bounds
        describleLabel.frame = CGRect.init(x: 0,
                                           y: self.height() - DES_LABEL_H,
                                           width: self.width(),
                                           height: DES_LABEL_H)
        //
        let position = pagePosition
        pagePosition = position
        self.setScrollViewContentSize()
    }
    
    fileprivate func changeCurrentPage(with offSetX: CGFloat!) {
        if offSetX < self.width() * 1.5 {
            var index = currIndex - 1
            if index < 0 {
                index = (self.imageArray?.count)! - 1
                pageControl.currentPage = index
            } else if offSetX > self.width() * 2.5 {
                pageControl.currentPage = (currIndex + 1) % (imageArray?.count)!
            } else {
                pageControl.currentPage = currIndex
            }
        }
    }
}

// MARK: - ScrollView 代理方法
extension SYCarouselView {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.stopTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.startTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if changeMode == .fade {
            return
        }
        let pointInSelf = scrollView.convert((otherImageView?.frame.origin)!, to: self)
        
        if abs(pointInSelf.x) != self.width() {
            let offsetX = scrollView.contentOffset.x + pointInSelf.x
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if __CGSizeEqualToSize(CGSize.zero, scrollView.contentSize) {
            return
        }
        
        let offsetX = scrollView.contentOffset.x
        self.changeCurrentPage(with: offsetX)
        if offsetX < self.width() * 2 {
            if changeMode == .fade {
                currImageView?.alpha = offsetX / self.width() - 1
                otherImageView?.alpha = 2 - offsetX / self.width()
            } else {
                otherImageView?.frame = CGRect(x: self.width(),
                                               y: 0,
                                               width: self.width(),
                                               height: self.height())
            }
            
            nextIndex = currIndex - 1
            if nextIndex! < 0 {
                nextIndex = (imageArray?.count)! - 1
            }
            let nextUrl = URL(string: (self.imageArray?[self.nextIndex!])!)
            otherImageView?.kf.setImage(with: nextUrl,
                                        placeholder: UIImage(named: defaultImageString),
                                        options: nil, progressBlock: nil, completionHandler: nil)
            if offsetX <= self.width() {
                self.changeToNext()
            }
        } else if offsetX > self.width() * 2{
            if changeMode == .fade {
                otherImageView?.alpha = offsetX / self.width() - 2
                currImageView?.alpha = 3 - offsetX / self.width()
            } else {
                otherImageView?.frame = CGRect(x: (currImageView?.frame)!.maxX,
                                               y: 0,
                                               width: self.width(),
                                               height: self.height())
            }
            nextIndex = (currIndex + 1) % (imageArray?.count)!
            let nextUrl = URL(string: (self.imageArray?[self.nextIndex!])!)
            otherImageView?.kf.setImage(with: nextUrl, placeholder: UIImage(named: defaultImageString),
                                        options: nil, progressBlock: nil, completionHandler: nil)
            
            if offsetX >= self.width() * 3 {
                self.changeToNext()
            }
        }
    }
}

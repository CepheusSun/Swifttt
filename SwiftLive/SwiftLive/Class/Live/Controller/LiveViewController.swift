//
//  LiveViewController.swift
//  SwiftLive
//
//  Created by sunny on 2017/3/22.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import UIKit
import IJKMediaFramework

class LiveViewController: UIViewController {

    var model: HomeLiveModel!
    var playerView: UIView!
    var ijkPlayer: IJKMediaPlayback!
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnGift: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dump(model)
        self.setBackground()
    }

    func setBackground() {
        if !model.creator.portrait.hasPrefix("http") {
            model.creator.portrait = "http://img2.inke.cn/\(model.creator.portrait)"
        }
        let imgUrl = URL(string: model.creator.portrait)
        imgBackground.kf.setImage(with: imgUrl)
        let blurEffect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = UIScreen.main.bounds //self.view.bounds
        imgBackground.addSubview(effectView)
        self.setPlayerView()
        self.bringButtonToFront()
    }
    
    func setPlayerView() {
        playerView = UIView(frame: UIScreen.main.bounds)
        view.addSubview(playerView)
        ijkPlayer = IJKFFMoviePlayerController(contentURLString: model.streamAddr, with: nil)
        let pv = ijkPlayer.view
        pv?.frame = playerView.bounds
        pv?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playerView.insertSubview(pv!, at: 1)
        ijkPlayer.scalingMode = .aspectFill
        
    }

    func bringButtonToFront() {
        view.bringSubview(toFront: btnLike)
        view.bringSubview(toFront: btnGift)
        view.bringSubview(toFront: btnBack)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.ijkPlayer.isPlaying() {
            ijkPlayer.prepareToPlay()
        }
        self.bringButtonToFront()
    }
    
    
    @IBAction func tapBack(_ sender: UIButton) {
        ijkPlayer.shutdown()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapGift(_ sender: UIButton) {
        
        let duration = 3.0
        let car = UIImageView(image: #imageLiteral(resourceName: "porsche"))
        
        car.frame = CGRect.zero
        view.addSubview(car)
        let widthCar: CGFloat = 250
        let heightCar: CGFloat = 125
        
        UIView.animate(withDuration: duration) {
            car.frame = CGRect(x: self.view.center.x - widthCar / 2,
                               y: self.view.center.y - heightCar / 2,
                               width: widthCar,
                               height: heightCar)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            UIView.animate(withDuration: duration, animations: {
                car.alpha = 0
            }, completion: {(completed) in
                car.removeFromSuperview()
            })
        }
        
        let layerFireWork = CAEmitterLayer()
        view.layer.addSublayer(layerFireWork)
        emmitParticles(from: sender.center, emitter: layerFireWork, in: view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 2) {
            layerFireWork.removeFromSuperlayer()
        }
    }
    
    @IBAction func tapLike(_ sender: UIButton) {
        
        let heart = HeartFlayView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        heart.center = CGPoint(x: btnLike.frame.origin.x, y: btnLike.frame.origin.y)
        view.addSubview(heart)
        heart.animate(in: view)
        
        // 爱心按钮 大小关键帧动画
        let btnAnimation = CAKeyframeAnimation(keyPath:"transform.scale")
        btnAnimation.values = [1.0, 0.7, 0.5, 0.7, 1.0, 1.2, 1.4, 1.2, 1.0]
        btnAnimation.keyTimes = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
        btnAnimation.duration = 0.2
        sender.layer.add(btnAnimation, forKey: "SHOW")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dump(model)
    }

}

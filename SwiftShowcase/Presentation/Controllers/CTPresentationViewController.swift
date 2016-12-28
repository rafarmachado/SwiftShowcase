
//
//  CTPresentationViewController.swift
//  SwiftShowcase
//
//  Created by cedro_nds on 22/11/16.
//  Copyright © 2016 Rafael Rezende Machado. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class CTPresentationViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate{
    
    //MARK: Outlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nameAppLabel: UILabel!
    
    //MARK: Variables
    var alreadyLayoutSubviews : Bool = false
    var pageTimer: Timer?
    var currentPageControl : CGFloat = 0.0
    var playerIsRunning = false
    let centerNotifications = NotificationCenter.default
    var playerLayer : AVPlayerLayer? = nil
    var player : AVPlayer?
    
    
    
    //MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        pageControl.numberOfPages = 3
        
        pageTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        scrollView.delegate = self
        
        self.update()
        
        self.styleItensViews()
        
        notificationCenter()
        
        prepareVideo()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        firstPlayVideo(player: player)
    }
    
    func styleItensViews(){
        //Buttons
        self.loginButton.layer.cornerRadius = 5.5
        self.loginButton.layer.masksToBounds = true
        self.loginButton.layer.backgroundColor = UIColor(hexString: "72DEFF").cgColor
        self.loginButton.alpha = 0.85
        self.loginButton.setTitleColor(UIColor.darkGray.withAlphaComponent(0.7), for: .normal)
        
        self.registerButton.layer.cornerRadius = 5.5
        self.registerButton.layer.masksToBounds = true
        self.registerButton.layer.backgroundColor = UIColor(hexString: "72DEFF").cgColor
        self.registerButton.alpha = 0.85
        self.registerButton.setTitleColor(UIColor.darkGray.withAlphaComponent(0.7), for: .normal)

        
        //pageControll
        self.pageControl.currentPageIndicatorTintColor = UIColor(hexString: "72DEFF")
        self.pageControl.alpha = 0.95
        self.pageControl.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.6)
        //Image
        //self.logoImageView.image = UIImage(named: "Swift_logo.png")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !alreadyLayoutSubviews{
            for index in 0..<3{
                
                let nibPage = Bundle.main.loadNibNamed("PageInfoOnePresentationView", owner: self, options: nil)?.first as! PageInfoOnePresentationView
                
                if index == 0{
                    nibPage.infoOneLabel.text = NSLocalizedString("PRESENTATION_DESCRIPTION_PAGE_1_KEY", comment: "")
                    
                }
                
                if index == 1{
                    nibPage.infoOneLabel.text = NSLocalizedString("PRESENTATION_DESCRIPTION_PAGE_2_KEY", comment: "")
                    
                }
                
                if index == 2{
                    nibPage.infoOneLabel.text = NSLocalizedString("PRESENTATION_DESCRIPTION_PAGE_3_KEY", comment: "")
                }
                
                nibPage.frame = CGRect(x:CGFloat(Int(self.view.frame.width) * index), y: 0, width: self.view.frame.width, height: self.scrollView.frame.height)
                
                self.scrollView.addSubview(nibPage)
                
            }
            
            self.scrollView.contentSize = CGSize(width: self.view.frame.size.width * 3, height: self.scrollView.frame.size.height)
            
            self.scrollView.layoutIfNeeded()
            
            self.view.layoutSubviews()
            
            alreadyLayoutSubviews = true
            
        }
        
        self.view.bringSubview(toFront: scrollView)
        self.scrollView.bringSubview(toFront: pageControl)
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let screenWidth = self.view.frame.width
        
        let page = Int(scrollView.contentOffset.x / screenWidth)
        
        self.pageControl.currentPage = page
        
    }
    
    
    func update() {
        if currentPageControl == 3 {
            currentPageControl = 0
        }
        
        scrollView.setContentOffset(CGPoint(x: self.view.frame.size.width * currentPageControl, y:0), animated: true)
        
        currentPageControl += 1
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
        
    }
    
    func prepareVideo(){
        guard let path = Bundle.main.path(forResource: "presentation_video", ofType: "mp4") else {
            print("This Video .MP4 not found")
            return
            
        }
        player = AVPlayer(url: URL(fileURLWithPath: path))
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = self.view.frame
        playerLayer?.opacity = 0.4
        self.view.layer.addSublayer(playerLayer!)
        
    }
    
    
    func playVideo(){
        guard let path = Bundle.main.path(forResource: "presentation_video", ofType: "mp4") else{
            
            debugPrint("video.m4v not found")
            
            return
        }
        

        if !playerIsRunning{
            player = AVPlayer(url: URL(fileURLWithPath: path))
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = self.view.frame
            playerLayer?.opacity = 0.6
            self.view.layer.addSublayer(playerLayer!)
            player?.play()
            self.loopVideo()
            self.view.bringSubview(toFront: viewButtons)
            self.view.bringSubview(toFront: logoImageView)
            self.view.bringSubview(toFront: scrollView)
            self.view.bringSubview(toFront: pageControl)
            self.view.bringSubview(toFront: nameAppLabel)
            playerIsRunning = true
            
        }
        
    }
    
    func firstPlayVideo(player: AVPlayer?){
        if !playerIsRunning{
            self.player?.play()
            self.loopVideo()
            self.view.bringSubview(toFront: viewButtons)
            self.view.bringSubview(toFront: scrollView)
            self.view.bringSubview(toFront: logoImageView)
            playerIsRunning = true
            
        }
    }
    
    func loopVideo(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: nil)
        { notification in
            let timeVideo = CMTimeMake(5, 100);
            self.player?.seek(to: timeVideo)
            self.player?.play()
        }
    }
    
    func notificationCenter(){
        centerNotifications.addObserver(self,
                           selector: #selector(playVideoFromNotificationCenter),
                           name: .UIApplicationDidBecomeActive,
                           object: nil)
        centerNotifications.addObserver(self,
                           selector: #selector(pauseVideo),
                           name: .UIApplicationDidEnterBackground,
                           object: nil)
        
    }
    
    func pauseVideo(){
        player?.pause()
        
    }
    
    func playVideoFromNotificationCenter(){
        player?.play()
    }
    
    
    
    //MARK: Actions
    @IBAction func performLoginButton(_ sender: Any) {
        
    }
    
    @IBAction func performRegisterButton(_ sender: Any) {
    }
    
    @IBAction func performDragPanGestureRecognizer(_ sender: Any) {
        pageTimer?.invalidate()
    }
  
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

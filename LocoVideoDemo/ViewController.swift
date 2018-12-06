//
//  ViewController.swift
//  LocoVideoDemo
//
//  Created by Mindbowser on 05/12/18.
//  Copyright © 2018 Mindbowser. All rights reserved.
//

import UIKit

class ViewController: UIViewController,CAAnimationDelegate {

    @IBOutlet weak var questionsCardView:UIView!
    @IBOutlet weak var circularBackgroundView:UIView!
    @IBOutlet var playerView: VideoplayerView!
    var circularView:UIView = UIView()

    @IBOutlet weak var questionscardHeightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.setupbackgroundViews()
        self.videoplayerViewSetup()
    }
    
    // Setup Video player View
    func videoplayerViewSetup(){
        playerView.configureVideoplayer()
        self.playerView.frame = self.view.frame
        playerView.repeatVideo = true
        playerView.play()
        self.perform(#selector(animatePlayerview), with: nil, afterDelay: 5.0)
    }
    
    // setup background view's

    func setupbackgroundViews()  {
        self.setborderforView(view: circularBackgroundView, cornerRadius: self.circularBackgroundView.frame.width/2, borderWidth: 10.0, borderColor: UIColor.clear)

        circularBackgroundView.isHidden = true
        questionsCardView.isHidden = true
    }
    
    // set view's corner radius and border
    func setborderforView(view:UIView,cornerRadius:CGFloat,borderWidth:CGFloat,borderColor:UIColor) {
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor

    }
    
    // MARK: animation view setup
    
    func addCircularviewlayer(animateIn:Bool) {
        // generate Randomnumber for QuestioncardHeight constraints
        let randomID = arc4random() % 200 + 200 ;
        self.questionscardHeightConstraint?.constant = CGFloat(randomID)
        
        if(animateIn == true){
            self.circularView.frame.size.height = 0
            self.circularView.frame.size.width = 0
            self.circularView.center =  self.circularBackgroundView.center

        }else {

            circularView.frame = CGRect(x: self.view.frame.width/2, y: self.view.frame.height/2, width: 0, height: 0)
        }
        
        let maskPath = UIBezierPath(ovalIn: self.circularView.frame)
        
        // define the masking layer to be able to show that circle animation
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.view.frame
        maskLayer.path = maskPath.cgPath
        maskLayer.fillRule = kCAFillRuleEvenOdd
        view.layer.mask = maskLayer
        
        // calculate end path
        let bigCirclePath = UIBezierPath(ovalIn: CGRect(x: self.view.frame.origin.x - 400, y: self.view.frame.origin.y - 400, width: self.view.frame.width + 1000 , height: self.view.frame.height + 1000 ))
        
        // create the CABasicAnimation
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.delegate = self
        pathAnimation.fromValue = maskPath.cgPath
        pathAnimation.toValue = bigCirclePath
        pathAnimation.duration = 0.5
        maskLayer.path = bigCirclePath.cgPath
        maskLayer.add(pathAnimation, forKey: "pathAnimation")
    }
    
    @objc func loadview(){
        self.playerView.frame = self.view.frame
        self.playerView.layer.cornerRadius = 0.0
    }
    
    
    // MARK: Method to animate the video to full screen view
    
    @objc func resetPlayerviewAnimation() {
        self.perform(#selector(self.loadview), with: nil, afterDelay: 0.01)
        addCircularviewlayer(animateIn: true)
        self.perform(#selector(self.animatePlayerview), with: nil, afterDelay: 5.0)
    }
    
    // MARK: Method to animate the video to circular view
    
    @objc func animatePlayerview() {
        self.addCircularviewlayer(animateIn: false)
        self.playerView.frame.size.height = CGFloat(videoHeight)
        self.playerView.frame.size.width = CGFloat(videoWidth)
        self.playerView.center =  self.circularBackgroundView.center
        self.playerView.layer.cornerRadius = self.playerView.frame.size.width/2
        self.view.bringSubview(toFront: self.playerView)
        self.playerView.clipsToBounds = true
        self.playerView.playerLayer?.needsDisplayOnBoundsChange = true
        self.circularBackgroundView.isHidden = false
        self.questionsCardView.isHidden = false
        self.perform(#selector(self.resetPlayerviewAnimation), with: nil, afterDelay: 5.0)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    

}


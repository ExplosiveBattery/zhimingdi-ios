//
//  ShadowViewController.swift
//  LoginTest
//
//  Created by Vega on 2018/3/24.
//  Copyright © 2018年 Vega. All rights reserved.
//

import UIKit
import KDCircularProgress

class ShadowImageController: UIViewController {
    static public let NOT_DOWNLOAD = 0
    static public let HAS_DOWNLOADED = 1
    let img = UIImageView()
    let sv = ShadowView()
    let progressRing = KDCircularProgress()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.view
        img.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(img)
        sv.frame = img.frame
        self.view.addSubview(sv)
        
        progressRing.frame = CGRect(x: view.center.x-30, y: view.frame.height-90 , width: 60, height: 60)
        progressRing.set(colors: UIColor(red:0.9725,green:1,blue:0.3137,alpha:1) ,UIColor.white, UIColor(red:0.0863,green:0.9803,blue:0.3961,alpha:1))
        progressRing.trackColor = UIColor.clear
        progressRing.progressThickness = 0.2
        progressRing.startAngle = -90
        progressRing.glowAmount = 2
        progressRing.roundedCorners = true
        self.view.addSubview(progressRing)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func setDate(_ year:Int, _ month:Int, _ day:Int) {
        sv.setDate(year: year, month: month, day: day)
    }
}


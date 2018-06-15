//
//  AppController.swift
//  LoginTest
//
//  Created by Vega on 2018/3/28.
//  Copyright © 2018年 Vega. All rights reserved.
//

import SlideMenuControllerSwift

class MainViewController: SlideMenuController {
    
    override func awakeFromNib() {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "Center") {
            self.mainViewController = controller
        }
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "Drawer") {
            self.leftViewController = controller
        }
//        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "Drawer") {
//            self.mainViewController = controller
//        }
        SlideMenuOptions.leftViewWidth = UIScreen.main.bounds.width*0.8
        super.awakeFromNib()
    }
}

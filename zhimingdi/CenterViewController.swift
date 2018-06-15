//
//  CenterViewController.swift
//  LoginTest
//
//  Created by Vega on 2018/3/24.
//  Copyright © 2018年 Vega. All rights reserved.
//

import UIKit
import TYPagerController
import Kingfisher
import UserNotifications
import FFToast

class CenterViewController: UIViewController {
    private static let NUMBER_OF_DAYS = (2100-1900)*365
    let pagerController = TYPagerController()
    private let today = Date()
    lazy var drawerController = UIStoryboard(name:"Main",bundle:nil).instantiateViewController(withIdentifier: "Drawer") as! DrawerController
    
    @IBOutlet var btnDrawer: UIButton!
    @IBOutlet var btnBackToToday: UIButton!
    @IBOutlet var btnShare: UIButton!
    private var bShareBtnState = false
    private let ICON_OFFSET: CGFloat = -40.0
    @IBOutlet var btnWechatShare: UIButton!
    @IBOutlet var btnWeiboShare: UIButton!
    @IBOutlet var btnQQzoneShare: UIButton!

    override func viewDidLoad() {
        checkPrivilege()
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black
        //self.view.layer.contents = #imageLiteral(resourceName: "default_backgroud").cgImage
        self.addPagerController()
        pagerController.scrollToController(at: CenterViewController.NUMBER_OF_DAYS-2, animate: false)
        
        btnBackToToday.backgroundColor = UIColor(white:0.97, alpha:0.65)
        btnBackToToday.layer.masksToBounds = true
        btnBackToToday.layer.cornerRadius = 15.0
    }

    func addPagerController() {
        self.pagerController.dataSource = self
        self.pagerController.delegate = self
        self.addChildViewController(self.pagerController)
        self.view.insertSubview(self.pagerController.view, at: 0)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.pagerController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDrawerBtnClick(_ sender: Any) {
        openDrawer()
    }
    @IBAction func onSharebtnClick(_ sender: Any) {
        if !bShareBtnState {
            btnQQzoneShare.isHidden = false
            btnWeiboShare.isHidden = false
            btnWechatShare.isHidden = false

            let ani = CABasicAnimation(keyPath: "position")
            ani.duration = 0.4
            ani.fromValue = NSValue(cgPoint: CGPoint(x:btnShare.center.x, y:btnShare.center.y))
            ani.toValue = NSValue(cgPoint: CGPoint(x:btnQQzoneShare.center.x, y:btnQQzoneShare.center.y))
            btnQQzoneShare.layer.add(ani, forKey: "")
            ani.toValue = NSValue(cgPoint: CGPoint(x:btnWechatShare.center.x, y:btnWechatShare.center.y))
            btnWechatShare.layer.add(ani, forKey: "")
            ani.toValue = NSValue(cgPoint: CGPoint(x:btnWeiboShare.center.x, y:btnWeiboShare.center.y))
            btnWeiboShare.layer.add(ani, forKey: "")
        }else {
            btnQQzoneShare.isHidden = true
            btnWeiboShare.isHidden = true
            btnWechatShare.isHidden = true
        }
        bShareBtnState = !bShareBtnState
    }
    @IBAction func onQQzoneBtnClick(_ sender: Any) {
        let controller = pagerController.controller(for: pagerController.curIndex) as! ShadowImageController
        if controller.img.tag == ShadowImageController.HAS_DOWNLOADED {

            let imgObj = QQApiImageArrayForQZoneObject()
            let date = Calendar.current.date(byAdding: .day, value: pagerController.curIndex+2-CenterViewController.NUMBER_OF_DAYS, to: today)
            let image = ImageCache.default.retrieveImageInDiskCache(forKey: Constraint.PIC_QUERY_URL+Constraint.dateFormatter.string(from: date!)+Constraint.BG_QUERY_SUFFIX)!
            imgObj.imageDataArray = Array<Data>()
            if let data = UIImageJPEGRepresentation(image, 1.0) {
                imgObj.imageDataArray.append(data)
            }
            imgObj.title = "title"
            imgObj.description = "description"
            let message = SendMessageToQQReq(content:imgObj)
            QQApiInterface.sendReq(toQZone: message)
        }else {
            Constraint.myToast(message: "请等待图片下载完成")
        }
    }
    @IBAction func onWeiboBtnClick(_ sender: Any) {
    }
    @IBAction func onWechatBtnClick(_ sender: Any) {
    }
    @IBAction func onBackToTodayBtnClick(_ sender: Any) {
        pagerController.scrollToController(at: CenterViewController.NUMBER_OF_DAYS-2, animate: true)
    }
    
    
    func openDrawer() {
        view.addSubview(drawerController.view)
        addChildViewController(drawerController)
        drawerController.didMove(toParentViewController: self)
        drawerController.vDrawer.isHidden = false
        
        let ani = CABasicAnimation(keyPath: "position")
        ani.duration = 0.3
        ani.fromValue = NSValue(cgPoint: CGPoint(x:-view.frame.width*0.4, y:view.center.y))
        ani.toValue = NSValue(cgPoint: CGPoint(x:view.frame.width*0.4, y:view.center.y))
        drawerController.vDrawer.layer.add(ani, forKey: "")
    }
    
    func checkPrivilege() {
        UNUserNotificationCenter.current().getNotificationSettings {
            [weak self](settings) in
            switch settings.authorizationStatus {
            case .authorized:
                return
            case .notDetermined:
                UNUserNotificationCenter.current()
                    .requestAuthorization(options: [.alert, .sound, .badge]) {
                        (accepted, error) in
                        if !accepted {
                            print("用户不允许消息通知。")
                        }
                }
            case .denied:
                DispatchQueue.main.async(execute: { () -> Void in
                    let alertController = UIAlertController(title: "消息推送已关闭",
                                                            message: "想要及时获取消息。点击“设置”，开启通知。",
                                                            preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:nil)
                    let settingsAction = UIAlertAction(title:"设置", style: .default, handler: {
                        (action) -> Void in
                        let url = URL(string: UIApplicationOpenSettingsURLString)
                        if let url = url, UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10, *) {
                                UIApplication.shared.open(url, options: [:],
                                                          completionHandler: {
                                                            (success) in
                                })
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                    })
                    alertController.addAction(cancelAction)
                    alertController.addAction(settingsAction)
                    
                    self!.present(alertController, animated: true, completion: nil)
                })
            }
        }
    }
}

extension CenterViewController: TYPagerControllerDataSource, TYPagerControllerDelegate {
    func numberOfControllersInPagerController() -> Int {
        return CenterViewController.NUMBER_OF_DAYS
    }
    func pagerController(_ pagerController: TYPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        var vc: UIViewController
        if index != CenterViewController.NUMBER_OF_DAYS-1 {
            let date = Calendar.current.date(byAdding: .day, value: index+2-CenterViewController.NUMBER_OF_DAYS, to: today)
            let dateComponents = Calendar.current.dateComponents(in: TimeZone(abbreviation: "GMT+8:00")!, from: date!)
            vc = ShadowImageController()
            weak var controller: ShadowImageController? = vc as! ShadowImageController
            controller!.img.tag = ShadowImageController.NOT_DOWNLOAD
            controller!.img.kf.setImage(with: URL(string: Constraint.PIC_QUERY_URL+Constraint.dateFormatter.string(from: date!))!, placeholder:#imageLiteral(resourceName: "default_backgroud"))
            ImageDownloader.default.downloadImage(with: URL(string: Constraint.PIC_QUERY_URL+Constraint.dateFormatter.string(from: date!)+Constraint.BG_QUERY_SUFFIX)!, progressBlock: {
                receivedSize, totalSize in
                let percentage = (Double(receivedSize) / Double(totalSize)) * 360.0
                controller!.progressRing.angle = percentage
            },completionHandler:{
                image,error,url,originalData in
                if error == .none {
                    ImageCache.default.store(image!, forKey: (url!.absoluteString)){
                        controller!.progressRing.angle = 0
                        controller!.img.tag = ShadowImageController.HAS_DOWNLOADED
                    }
                }else {
                    controller!.progressRing.angle = 0
                    Constraint.myToast(message: "图片下载失败")
                }
            })
            controller!.setDate(dateComponents.year!, dateComponents.month!, dateComponents.day!)
        }else {
            vc = self.storyboard!.instantiateViewController(withIdentifier: "LastPager") 
        }
        return vc
    }
    
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, animated: Bool) {
        if toIndex==CenterViewController.NUMBER_OF_DAYS-1 {
            btnDrawer.isHidden = true
            btnShare.isHidden = true
            (pagerController.controller(for: CenterViewController.NUMBER_OF_DAYS-1) as! LastPagerController).setButtonDisplay(isHidden: false)
        }else if fromIndex==CenterViewController.NUMBER_OF_DAYS-1 {
            btnDrawer.isHidden = false
            btnShare.isHidden = false
            (pagerController.controller(for: CenterViewController.NUMBER_OF_DAYS-1) as! LastPagerController).setButtonDisplay(isHidden: true)
        }else if toIndex==CenterViewController.NUMBER_OF_DAYS-2 {
            btnBackToToday.isHidden = true
        }else if fromIndex==CenterViewController.NUMBER_OF_DAYS-2 {
            btnBackToToday.isHidden = false
        }
    }
    
}


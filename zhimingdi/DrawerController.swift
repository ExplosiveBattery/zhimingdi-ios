//
//  DrawerController.swift
//  LoginTest
//
//  Created by Vega on 2018/3/28.
//  Copyright © 2018年 Vega. All rights reserved.
//
import UIKit
import Kingfisher
import FFToast
import Alamofire
import SlideMenuControllerSwift

class DrawerController: UIViewController {
    let defaults = UserDefaults.standard
    @IBOutlet var imgAvater: UIImageView!
    @IBOutlet var lblNickname: UILabel!
    @IBOutlet var vDrawer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imgAvater.kf.setImage(with: defaults.url(forKey: "avatar_url")!)
        imgAvater.layer.shouldRasterize = true
        imgAvater.layer.masksToBounds = true
        imgAvater.layer.cornerRadius = 40.0
        
        lblNickname.text = defaults.string(forKey: "nick_name")!
        
        view.addGestureRecognizer(UITapGestureRecognizer(target:self,action:#selector(onShadowClick)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogoutBtnClick(_ sender: Any) {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        
        if parent!.presentingViewController != nil {
            parent!.dismiss(animated: true, completion: nil)
        }else {
            let sbdLogin = UIStoryboard(name:"Login", bundle:nil)
            UIApplication.shared.keyWindow?.rootViewController = sbdLogin.instantiateInitialViewController()!
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
        }
    }
    
    @IBAction func onStarBtnClick(_ sender: Any) {
        let params: [String:Any] = ["accessToken": defaults.string(forKey: "access_token")!]
        Alamofire.request(Constraint.PIC_STAR_URL, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers:Constraint.HEADER).responseJSON{
            [weak self](response) in
            switch response.result {
            case .success(let json):
                let controller = self!.storyboard?.instantiateViewController(withIdentifier: "MultiImage") as! MultiImageController
                controller.type = .StarImage
                controller.array = json as! Array<String>
                self!.present(controller, animated: true, completion: nil)
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    @IBAction func onHistoryBtnClick(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MultiImage") as! MultiImageController
        controller.type = .HistoryImage
        present(controller, animated: true, completion: nil)
    }
    @IBAction func onClearBtnClick(_ sender: Any) {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
        Constraint.myToast(message: "缓存清理完成",duration:1.5)
    }
    @IBAction func onDonateBtnClick(_ sender: Any) {
        Constraint.myToast(message: "其实，我开玩笑的")
    }
    @objc func onShadowClick() {
        vDrawer.isHidden = true
        view.removeFromSuperview()
        removeFromParentViewController()
    }
}


//
//  LoginController.swift
//  LoginTest
//
//  Created by Vega on 2018/4/7.
//  Copyright © 2018年 Vega. All rights reserved.
//

import UIKit
import FFToast
import Alamofire

class LoginController: UIViewController {
    static var tencent: TencentOAuth?
    let defaults = UserDefaults.standard

    @IBAction func onQQLoginBtnClick(_ sender: Any) {
        LoginController.tencent = TencentOAuth.init(appId: "1106824010", andDelegate: self)
        let permissions = [kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]
        LoginController.tencent!.authMode = kAuthModeClientSideToken;
        LoginController.tencent!.authorize(permissions)
    }
    
    @IBAction func onWechatLoginBtnClick(_ sender: Any) {
        dismiss(animated: false, completion: nil)
        Constraint.myToast(message: "对不起，微信不允许个人开发者申请登录权限")
    }
    @IBAction func onWeiboLoginBtnClick(_ sender: Any) {
        Constraint.myToast(message: "还没有申请苹果开发者账号，不支持微博登录")
    }
}

extension LoginController:TencentSessionDelegate {
    func tencentDidLogin() {
        if LoginController.tencent!.accessToken != nil && LoginController.tencent!.accessToken.count != 0 {
            LoginController.tencent!.getUserInfo()
        }
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        
    }
    
    func tencentDidNotNetWork() {
        
    }
    
    func getUserInfoResponse(_ response: APIResponse!) {
        if response.retCode == 0 {
            if let res = response.jsonResponse {
                if let uid = LoginController.tencent!.getUserOpenID(),let name = res["nickname"],let imgURL = res["figureurl_2"] {
                    defaults.set(URL(string:imgURL as! String), forKey: "avatar_url")
                    defaults.set(name, forKey: "nick_name")
                    
                    let params = ["accessToken": "", "qqID":uid, "weiboID":""]
                    Alamofire.request(Constraint.USER_URL, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers:Constraint.HEADER).responseJSON{
                        [weak self](response) in
                        switch response.result {
                        case .success(let json):
                            let dict = json as! Dictionary<String,Any>
                            self!.defaults.set(dict["access_token"]!, forKey: "access_token")
                            let storyboard = UIStoryboard(name:"Main", bundle:nil)
                            self!.present(UIStoryboard(name:"Main", bundle:nil).instantiateInitialViewController()!,animated: false)
                        case .failure(let error):
                            print("\(error)")
                        }
                    }
                }
            }
            LoginController.tencent?.logout(nil)
        } else {
            // 获取授权信息异常
        }
        LoginController.tencent?.sessionDelegate = nil
        LoginController.tencent = nil
    }
}
//微博 SDK 个人信息 返回
//nickName =jo.getString("name");
//weiboID =jo.getString("id");
//avatarUrl =jo.getString("avatar_large");


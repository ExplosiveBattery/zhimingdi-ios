//
//  Constraint.swift
//  LoginTest
//
//  Created by Vega on 2018/4/5.
//  Copyright © 2018年 Vega. All rights reserved.
//
// ssh -p 62 root@115.159.116.127
// 7pX7hDLXkSQYRZG123
// 0ee5d783c453583bae7adcf6a27d4bef
//MariaDB [zhimingdi]> describe Marker;
//+-------------+-------------+------+-----+---------+----------------+
//    | Field       | Type        | Null | Key | Default | Extra          |
//    +-------------+-------------+------+-----+---------+----------------+
//    | Longitude   | double      | YES  |     | NULL    |                |
//    | Latitude    | double      | YES  |     | NULL    |                |
//    | Name        | varchar(10) | YES  |     | NULL    |                |
//    | RelativeURL | varchar(32) | YES  |     | NULL    |                |
//    | Type        | tinyint(1)  | YES  |     | NULL    |                |
//    | id          | int(11)     | NO   | PRI | NULL    | auto_increment |
//+-------------+-------------+------+-----+---------+----------------+
import Foundation
import UserNotifications
import FFToast

class Constraint {
    //URL
    public static let HOST_BASE_URL = "http://hellovega.cn";
    public static let ZHIMINGDI_BASE_URL = HOST_BASE_URL + "/zhimingdi";
    public static let USER_URL = ZHIMINGDI_BASE_URL+"/users.php"
    public static let AVATER_PATH_PREFIX = "/avater";
    public static let PIC_STAR_URL = ZHIMINGDI_BASE_URL + "/star.php"
    public static let PIC_QUERY_URL = ZHIMINGDI_BASE_URL + "/pic.php?id=";
    public static let VERSION_URL = ZHIMINGDI_BASE_URL+"/version.php?type=ios";
    public static let BG_QUERY_SUFFIX = "&type=1";  //背景图big
    public static let SM_QUERY_SUFFIX = "&type=0";  //缩略图small
                                                    //没有type表示normal大小（日历背景图）
    public static let USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; WOW64)"
    public static let HEADER = ["User-Agent":USER_AGENT]
    
    
    //day
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    public static let dfMonthAndDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMdd"
        return formatter
    }()
    public static let START_DATE = dateFormatter.date(from: "20180301")!
    public static let SECONDS_OF_DAY = 86400
    
    //record
    /*
     * 通过遍历获取某一天下一个序号
     * 20180303_0  表示记录中20180303那天第0件事情
     */
    public static func getNextIndex(date:String)->Int {
        var i1=0
        while UserDefaults.standard.string(forKey: date+"_"+String(describing:i1)) != nil {
            i1 += 1
        }
        return i1
    }
    /*
     * 指定删除某一天某一个序号
     * 将后面的序号前移一个单位,然后删除最后一个元素
     */
    public static func removeKey(date: String, index:Int) {
        var i = index
        while let value=UserDefaults.standard.string(forKey: date+"_"+String(describing:i+1)) {
            UserDefaults.standard.set(value, forKey: date+"_"+String(describing:i))
            i += 1
        }
        UserDefaults.standard.removeObject(forKey: date+"_"+String(describing:i))
    }
    
    
    //Notification
    public static func sendNotifications(date:Date) {
        let lastDate = Calendar.current.date(byAdding: .day, value: -1, to: date)
        var dateComponents = Calendar.current.dateComponents(in: TimeZone(abbreviation: "GMT+8:00")!, from: lastDate!)
        dateComponents.hour = 4
        dateComponents.minute = 20
        dateComponents.second = 0
        //let的成员不能改变，还是因为这个类型特殊

        let content = UNMutableNotificationContent()
        content.title = "植名地"
        content.body = "今明两天有重要的事情，不要忘记哦"
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "cn.hellovega.zhimingdi",
                                            content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request,withCompletionHandler:nil)
    }
    
    public static func myToast(message:String,duration:Double=3.0) {
        let toast = FFToast.init(toastWithTitle: nil, message: message, iconImage: nil)!
        toast.messageFont = UIFont(name: "FZQTK--GBK1-0", size: toast.messageFont.pointSize)!
        toast.toastType = FFToastType.default
        toast.toastPosition = FFToastPosition.bottomWithFillet
        toast.show()
    }
}

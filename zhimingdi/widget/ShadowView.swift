//
//  ShadowView.swift
//  LoginTest
//
//  Created by Vega on 2018/3/24.
//  Copyright © 2018年 Vega. All rights reserved.
//

import UIKit
import AVFoundation

//imageView.tag = IMAGE_VIEW_TAG;
public class ShadowView : UIView {
    private static let EVEN_DAY_FONT_SIZE = UIScreen.main.bounds.width*0.8
    private static let SINGLE_DAY_FONT_SIZE = UIScreen.main.bounds.width*1.2
    private static let MONTH_FONT_SIZE = EVEN_DAY_FONT_SIZE/6
    private static let WEEKDAY_FONT_SIZE = EVEN_DAY_FONT_SIZE/9
    private static let CHINESE_WEEKDAY = ["星期一","星期二","星期三","星期四","星期五","星期六","星期天"]
    private static let CHINESE_MONTH = ["一月","二月", "三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"]
    var year=0,month=0,day=0

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.69)
    }

    public func setDate(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }

    public override func draw(_ rect: CGRect) {
        //绘制遮罩
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
//        context.saveGState()
        context.setBlendMode(.clear)
            //设置通用文字属性
        var font = UIFont.systemFont(ofSize: ShadowView.EVEN_DAY_FONT_SIZE)
        let text_style=NSMutableParagraphStyle()
        text_style.alignment=NSTextAlignment.center
        var attributes=[NSAttributedStringKey.font:font, NSAttributedStringKey.paragraphStyle:text_style] as [NSAttributedStringKey : Any]
            //绘制日期
        if day<10 {
            font = font.withSize(ShadowView.SINGLE_DAY_FONT_SIZE)
        }
        var text = String(day)
        var text_rect=CGRect(x: 0, y: (rect.size.height-font.withSize(ShadowView.SINGLE_DAY_FONT_SIZE).ascender)/2, width: rect.size.width, height: font.lineHeight)
        text.draw(in: text_rect.integral, withAttributes: attributes)
            //绘制月份
        text_style.alignment=NSTextAlignment.left
        font=UIFont(name: "FZQTK--GBK1-0", size: ShadowView.MONTH_FONT_SIZE)!
        attributes[NSAttributedStringKey.font] = font
        text = ShadowView.CHINESE_MONTH[month-1];
        text_rect=CGRect(x: 15, y: rect.size.height-2*font.lineHeight, width: ShadowView.MONTH_FONT_SIZE*3, height: font.lineHeight)
        text.draw(in: text_rect.integral, withAttributes: attributes)
            //绘制星期
        font = font.withSize(ShadowView.WEEKDAY_FONT_SIZE)
        attributes[NSAttributedStringKey.font] = font
        text = ShadowView.CHINESE_WEEKDAY[ShadowView.getWeekDay(year,month,day)]
        text_rect=CGRect(x: 15, y: rect.size.height-1.6*font.lineHeight, width: ShadowView.WEEKDAY_FONT_SIZE*3, height: font.lineHeight)
        text.draw(in: text_rect.integral, withAttributes: attributes)
//        context.restoreGState()
    }
    
    //蔡勒公式 基姆拉尔森计算公式
    public static func getWeekDay(_ year:Int, _ month:Int, _ day:Int)->Int {
        var year = year
        var month = month
        if month==1||month==2 {
            year = year - 1
            month += 12
        }
        return (day + 2*month + 3*(month+1)/5 + year + year/4 - year/100 + year/400) % 7
    }
}

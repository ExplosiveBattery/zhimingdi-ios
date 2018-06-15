//
//  LastPagerController.swift
//  LoginTest
//
//  Created by Vega on 2018/3/30.
//  Copyright © 2018年 Vega. All rights reserved.
//


import UIKit
import FSCalendar
import PopupDialog

class LastPagerController: UIViewController {
    private let lunarChar = ["初一","初二","初三","初四","初五","初六","初七","初八","初九","初十","十一","十二","十三","十四","十五","十六","十七","十八","十九","二十","二一","二二","二三","二四","二五","二六","二七","二八","二九","三十"]
    private let lunarCalender = NSCalendar(identifier: .chinese)
    lazy var dlgBirth: PopupDialog = {
        let controller = BirthdayDialogController(nibName: "BirthdayDialogController", bundle: nil)
        let dlg = PopupDialog.init(viewController:controller, buttonAlignment: .horizontal,gestureDismissal: true)
        let btnClick = DefaultButton(title: "CONFIM") {
            [weak controller,weak cv, weak calendar] in
            if controller!.textfield.text!.isEmpty {
                let maxYear = Calendar.current.dateComponents(in: TimeZone(abbreviation: "GMT+8:00")!, from: self.calendar.maximumDate).year!
                let currentYear = Calendar.current.dateComponents(in: TimeZone(abbreviation: "GMT+8:00")!, from: Date()).year!
                for year in currentYear...maxYear {
                    let birthday: String = String(describing: year)+Constraint.dfMonthAndDay.string(from: controller!.datepicker.date)
                    UserDefaults.standard.set(controller!.textfield.text!+"生日" ,forKey: birthday+"_"+String(Constraint.getNextIndex(date:birthday)))
                }
                cv!.reloadData()
                calendar!.reloadData()
            }
        }
        
        dlg.addButtons([CancelButton(title: "CANCEL") {},btnClick])
        return dlg
    }()
    
    
    @IBOutlet var btnDrawer: UIButton!
    @IBOutlet var btnMention: UIButton!
    @IBOutlet var btnBirthday: UIButton!
    @IBOutlet var btnMap: UIButton!
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var vDatePickerCalendar: UIView!
    @IBOutlet var cv: UICollectionView!
    @IBOutlet var dpCalendar: UIDatePicker!
    
    fileprivate lazy var df: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    
    
    override func viewDidLoad() {
        lunarCalender!.locale = Locale(identifier: "zh-CN")
        
        calendar.locale = Locale(identifier: "zh-CN")
        calendar.select(calendar.today)
        calendar.deliver.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LastPagerController.onCalendarHeaderClick(_:)) ))
        calendar.appearance.weekdayFont = UIFont(name: "FZQTK--GBK1-0", size: calendar.appearance.weekdayFont.pointSize)
        
        cv.register(MentionCell.self, forCellWithReuseIdentifier: "MentionCell")
        
        dpCalendar.minimumDate = calendar.minimumDate
        dpCalendar.maximumDate = calendar.maximumDate
    }

    @IBAction func onDrawerBtnClick(_ sender: Any) {
        (parent!.parent! as! CenterViewController).openDrawer()
    }
    @IBAction func onMentionDialogBtnClick(_ sender: Any) {
        let controller = MentionDialogController(nibName: "MentionDialogController", bundle: nil)
        let dlgMention = PopupDialog.init(viewController:controller, buttonAlignment: .horizontal,gestureDismissal: true)
        controller.label.text = df.string(from: calendar.selectedDate!)
        let btnClick = DefaultButton(title: "CONFIM") {
            [weak controller, weak calendar, weak cv] in
            if !controller!.isHint {
                let date = Constraint.dateFormatter.string(from: calendar!.selectedDate!)
                UserDefaults.standard.set(controller!.textView.text ,forKey: date+"_"+String(Constraint.getNextIndex(date: date)))
                cv!.reloadData()
                calendar!.reloadData()
            }
        }
        dlgMention.addButtons([CancelButton(title: "CANCEL") {},btnClick])
        
        addChildViewController(dlgMention)
        view.addSubview(dlgMention.view)
    }
    @IBAction func onBirthdayBtnClick(_ sender: Any) {
        (dlgBirth.viewController as! BirthdayDialogController).textfield.text = ""
        addChildViewController(dlgBirth)
        view.addSubview(dlgBirth.view)
    }
    @IBAction func onMapBtnClick(_ sender: Any) {
    }
    @objc func onCalendarHeaderClick(_ ges : UITapGestureRecognizer) {
        if vDatePickerCalendar.isHidden {
            let ani = CABasicAnimation(keyPath: "position")
            ani.duration = 0.4
            ani.fromValue = NSValue(cgPoint: CGPoint(x:vDatePickerCalendar.center.x, y:vDatePickerCalendar.center.y+vDatePickerCalendar.fs_height))
            ani.toValue = NSValue(cgPoint: CGPoint(x:vDatePickerCalendar.center.x, y:vDatePickerCalendar.center.y))
            vDatePickerCalendar.layer.add(ani, forKey: "")
            
            vDatePickerCalendar.isHidden = false
        }
    }
    
    @IBAction func onCancelBtnClick(_ sender: Any) {
        vDatePickerCalendar.isHidden = true
    }
    
    @IBAction func onChooseBtnClick(_ sender: Any) {
        calendar.select(dpCalendar.date)    //改变至制定月份
        calendar.select(dpCalendar.date)    //改变至指定月份的指定日期
        vDatePickerCalendar.isHidden = true
    }
    
    public func setButtonDisplay(isHidden: Bool) {
        btnDrawer.isHidden = isHidden
        btnMention.isHidden = isHidden
        btnBirthday.isHidden = isHidden
        btnMap.isHidden = isHidden
    }
    
}

extension LastPagerController: FSCalendarDataSource,FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        cv.reloadData()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendar.select(calendar.currentPage)
        
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        return lunarChar[lunarCalender!.components(NSCalendar.Unit.day, from: date).day!-1]
    }
    
    func calendar(_ calendar: FSCalendar, hasEventFor date: Date) -> Bool {
        return Constraint.getNextIndex(date: Constraint.dateFormatter.string(from: date)) != 0
    }
}

extension LastPagerController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constraint.getNextIndex(date: Constraint.dateFormatter.string(from: calendar!.selectedDate!))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mentionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MentionCell", for: indexPath) as! MentionCell
        mentionCell.content.text = UserDefaults.standard.string(forKey: Constraint.dateFormatter.string(from: calendar!.selectedDate!)+"_"+String(describing: indexPath.item))
        mentionCell.addGestureRecognizer(UITapGestureRecognizer(target:self,action: #selector(LastPagerController.onMentionCellClick(_:))))
        return mentionCell
    }
    
    @objc func onMentionCellClick(_ ges: UITapGestureRecognizer) {
        let dlgMention = PopupDialog.init(title:"", message:"确认删除？", buttonAlignment: .horizontal,gestureDismissal: true)

        let btnClick = DefaultButton(title: "CONFIM") {
            [weak cv, weak calendar] in
            let indexPath = cv!.indexPath(for: ges.view as! UICollectionViewCell)!
            Constraint.removeKey(date: Constraint.dateFormatter.string(from: calendar!.selectedDate!), index: indexPath.item)
            cv!.deleteItems(at: [indexPath])
            calendar!.reloadData()
        }
        dlgMention.addButtons([CancelButton(title: "CANCEL") {},btnClick])
        
        addChildViewController(dlgMention)
        view.addSubview(dlgMention.view)
    }
}

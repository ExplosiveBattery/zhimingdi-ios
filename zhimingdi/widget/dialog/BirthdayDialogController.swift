//
//  BirthdayDialogController.swift
//  LoginTest
//
//  Created by Vega on 2018/4/2.
//  Copyright © 2018年 Vega. All rights reserved.
//

import UIKit

class BirthdayDialogController: UIViewController {

    @IBOutlet var textfield: UITextField!
    @IBOutlet var datepicker: UIDatePicker!
    
    override func viewDidLoad() {
        var views = datepicker.subviews[0].subviews
        views[1].isHidden = true
        views[2].isHidden = true
    }
    
}


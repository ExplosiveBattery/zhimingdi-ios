//
//  MentionDialogController.swift
//  LoginTest
//
//  Created by Vega on 2018/4/2.
//  Copyright © 2018年 Vega. All rights reserved.
//

import UIKit

class MentionDialogController: UIViewController {
    var isHint = true
    @IBOutlet var label: UILabel!
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        textView.delegate = self
    }
}

extension MentionDialogController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "说点什么吧..."
            textView.textColor = UIColor.lightGray
            isHint = true
        }else if isHint {
            let startIndex = textView.text.index(textView.text.startIndex, offsetBy: textView.selectedRange.location-1)
            let range = startIndex..<textView.text.index(after: startIndex)
            var str: String = textView.text
            str = String(str[range])
            textView.text = str
            textView.textColor = UIColor.black
            isHint = false
        }
    }

}

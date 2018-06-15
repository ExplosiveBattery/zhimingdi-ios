//
//  MentionCell.swift
//  LoginTest
//
//  Created by Vega on 2018/4/1.
//  Copyright © 2018年 Vega. All rights reserved.
//

import UIKit

class MentionCell: UICollectionViewCell {
    var content = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(content)
        contentView.backgroundColor = .white
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 5.0
        
        content.frame = frame
        content.numberOfLines = 2
        content.center = contentView.center
        content.textAlignment = .center
        content.textColor = .black
        content.font = UIFont(name: "FZQTK--GBK1-0", size: 15)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        contentView.frame = bounds
        super.layoutSubviews()
    }
    
}

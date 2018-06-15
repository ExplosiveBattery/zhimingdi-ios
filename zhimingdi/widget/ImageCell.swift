//
//  ImageCell.swift
//  LoginTest
//
//  Created by Vega on 2018/4/5.
//  Copyright © 2018年 Vega. All rights reserved.
//

import UIKit
import KDCircularProgress
import Kingfisher

class ImageCell: UICollectionViewCell {
    let content = UIImageView()
    let progressRing = KDCircularProgress()
    var date: String?
    
    fileprivate static let NOT_DOWNLOAD = 0
    fileprivate static let HAS_DOWNLOADED = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(content)
        
        content.frame = frame
        content.center = contentView.center
        
        progressRing.frame = frame
        progressRing.center = contentView.center
        progressRing.trackColor = UIColor.clear
        progressRing.set(colors: UIColor(white:0.97, alpha:0.63))
        progressRing.progressThickness = 0.2
        progressRing.startAngle = -90
        progressRing.glowAmount = 2
        progressRing.roundedCorners = true
        contentView.addSubview(progressRing)
        contentView.addGestureRecognizer(UITapGestureRecognizer(target:self,action:#selector(ImageCell.onViewClick)))
        
        contentView.tag = ImageCell.NOT_DOWNLOAD
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        contentView.frame = bounds
        super.layoutSubviews()
    }
    
    @objc func onViewClick(_ ges : UITapGestureRecognizer) {
        if contentView.tag == ImageCell.NOT_DOWNLOAD {
            ImageDownloader.default.downloadImage(with: URL(string: Constraint.PIC_QUERY_URL+date!+Constraint.BG_QUERY_SUFFIX)!,progressBlock: {
                    [weak progressRing](receivedSize, totalSize) in
                    let percentage = (Double(receivedSize) / Double(totalSize)) * 360.0
                        progressRing?.angle = percentage
                    if receivedSize==totalSize {
                        progressRing?.angle = 0
                    }
            })
            contentView.tag = ImageCell.HAS_DOWNLOADED
        }else {
            
        }
    }
    
}


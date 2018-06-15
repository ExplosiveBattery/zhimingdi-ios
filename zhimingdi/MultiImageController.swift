//
//  MultiImageController.swift
//  LoginTest
//
//  Created by Vega on 2018/4/5.
//  Copyright © 2018年 Vega. All rights reserved.

import UIKit


class MultiImageController: UIViewController {
    enum MultiImageType {
        case HistoryImage
        case StarImage
    }
    var type: MultiImageType?
    var array: Array<String>?
    
    @IBOutlet var label: UILabel!
    @IBOutlet var collectionView: UICollectionView!


    override func viewDidLoad() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        
        if type == .StarImage {
            label.text = "收藏图片"
        }else {
            label.text = "历史图谱"
        }
    }
    
    @IBAction func onBackBtnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}

extension MultiImageController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if type == .StarImage {
            return array!.count
        }else {
            return (Int)(Date().timeIntervalSince(Constraint.START_DATE))/Constraint.SECONDS_OF_DAY
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        indexPath.item
        
        let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        if type == .StarImage {
            imageCell.content.kf.setImage(with: URL(string: Constraint.PIC_QUERY_URL+array![indexPath.item]+Constraint.SM_QUERY_SUFFIX))
            imageCell.date = array![indexPath.item]
        }else {
            let date = Constraint.dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: indexPath.item, to: Constraint.START_DATE)!)
            imageCell.content.kf.setImage(with: URL(string: Constraint.PIC_QUERY_URL+date+Constraint.SM_QUERY_SUFFIX))
            imageCell.date = date
        }
        return imageCell
    }
}

//
//  WDTHeader.swift
//  Widdit
//
//  Created by Игорь Кузнецов on 04.07.16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit

class WDTHeader: UIView {
    
    
    var heightLayoutConstraint = NSLayoutConstraint()
    var bottomLayoutConstraint = NSLayoutConstraint()
    
//    var scrollView = UIScrollView()
//    var contentView = UIView()
    var containerView = UIView()
    var containerLayoutConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.redColor()
        self.addSubview(containerView)
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[containerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["containerView" : containerView]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[containerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["containerView" : containerView]))
        containerLayoutConstraint = NSLayoutConstraint(item: containerView, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1.0, constant: 0.0)
        self.addConstraint(containerLayoutConstraint)
        
//        containerView.addSubview(scrollView)
//       // scrollView.pagingEnabled = true
//        scrollView.snp_makeConstraints { (make) in
//            make.edges.equalTo(containerView)
//        }
//        
//        scrollView.addSubview(contentView)
//        contentView.snp_makeConstraints { (make) in
//            make.edges.equalTo(scrollView)
//        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setImages(images: [UIImage]) {
        var lastView = UIImageView()
        
        for (index, image) in images.enumerate() {
            let imageView: UIImageView = UIImageView.init()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.backgroundColor = UIColor.whiteColor()
            imageView.clipsToBounds = true
            imageView.contentMode = .ScaleAspectFill
            imageView.image = image
            
            
            if index == 0 {
                containerView.addSubview(imageView)
                
                containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["imageView" : imageView]))
                bottomLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: containerView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
                containerView.addConstraint(bottomLayoutConstraint)
                heightLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: containerView, attribute: .Height, multiplier: 1.0, constant: 0.0)
                containerView.addConstraint(heightLayoutConstraint)
                
                
                imageView.snp_updateConstraints(closure: { (make) in
                    make.width.equalTo(400)
                })
            } else {
//                contentView.addSubview(imageView)
//                imageView.snp_makeConstraints(closure: { (make) in
//                    make.left.equalTo(lastView.snp_right)
//                    make.top.equalTo(contentView)
//                    make.bottom.equalTo(contentView)
////                    make.right.equalTo(containerView).priority(751)
//                    make.width.equalTo(400).priority(750)
//                })
                
                
//                scrollView.contentSize = CGSizeMake(1000, 200)
                
                
            }
            
            lastView = imageView
            
        }
        
        
        
        

    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        containerLayoutConstraint.constant = scrollView.contentInset.top;
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top);
        containerView.clipsToBounds = offsetY <= 0
        bottomLayoutConstraint.constant = offsetY >= 0 ? 0 : -offsetY / 2
        heightLayoutConstraint.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
    
}

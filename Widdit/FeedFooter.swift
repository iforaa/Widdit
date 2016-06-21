//
//  FeedFooter.swift
//  Widdit
//
//  Created by Игорь Кузнецов on 21.06.16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit

class WDTFooterCardView: UIView {
    
    var shadowLayer:CAShapeLayer? = nil
    
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        
        if self.shadowLayer == nil {
            let maskPath = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: [.BottomLeft, .BottomRight],
                                        cornerRadii: CGSize(width: 4.0, height: 4.0))
            
            self.shadowLayer = CAShapeLayer()
            self.shadowLayer!.path = maskPath.CGPath
            self.shadowLayer!.fillColor = UIColor.WDTGrayBlueColor().CGColor
            
            self.shadowLayer!.shadowColor = UIColor.darkGrayColor().CGColor
            self.shadowLayer!.shadowPath = self.shadowLayer!.path
            self.shadowLayer!.shadowOffset = CGSize(width: 0.0, height: 2.0)
            self.shadowLayer!.shadowOpacity = 0.5
            self.shadowLayer!.shadowRadius = 2
            
            layer.insertSublayer(self.shadowLayer!, atIndex: 0)
        }
        
        
        
    }
}

class FeedFooter: UITableViewHeaderFooterView {


    var replyBtn: UIButton = UIButton(type: .Custom)
//    var horlLineView = UIView()
    var imDownBtn: UIButton = UIButton(type: .Custom)
    var cardView: WDTFooterCardView = WDTFooterCardView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        
        self.contentView.addSubview(self.cardView)
        self.cardView.addSubview(self.imDownBtn)
        self.cardView.addSubview(self.replyBtn)
//        self.cardView.addSubview(self.horlLineView)
        self.cardSetup()
        
//        self.horlLineView.backgroundColor = UIColor.grayColor()
//        self.horlLineView.alpha = 0.5

        self.replyBtn.backgroundColor = UIColor.WDTGrayBlueColor()
        self.replyBtn.setTitleColor(UIColor.grayColor(), forState: .Normal)
        self.replyBtn.setTitle("Reply", forState: .Normal)
        self.replyBtn.titleLabel?.font = UIFont.WDTAgoraRegular(14)
        
        
        self.imDownBtn.backgroundColor = UIColor.WDTGrayBlueColor()
        self.imDownBtn.setTitleColor(UIColor.grayColor(), forState: .Normal)
        self.imDownBtn.titleLabel?.font = UIFont.WDTAgoraRegular(14)
        


//        self.horlLineView.snp_makeConstraints { (make) in
//            make.top.equalTo(self.cardView).offset(2)
//            make.width.equalTo(self.cardView).multipliedBy(0.9)
//            make.centerX.equalTo(self.cardView)
//            make.height.equalTo(1)
//        }
        
        self.replyBtn.snp_remakeConstraints { (make) in
            make.top.equalTo(self.cardView).offset(10)
            make.left.equalTo(self.cardView).offset(10)
            make.right.equalTo(self.cardView.snp_centerX)
            make.bottom.equalTo(self.cardView)
        }
        
        self.imDownBtn.snp_remakeConstraints { (make) in
            make.top.equalTo(self.cardView).offset(10)
            make.left.equalTo(self.cardView.snp_centerX)
            make.right.equalTo(self.cardView).offset(-10)
            make.bottom.equalTo(self.cardView)
            
        }
        
    }
    

    func hideSubvies(hidden: Bool) {
        
//        self.horlLineView.hidden = hidden
        self.replyBtn.hidden = hidden
        self.imDownBtn.hidden = hidden
        
    }
    
    func cardSetup() {
        self.cardView.snp_remakeConstraints { (make) in
            make.top.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
            make.bottom.equalTo(self.contentView).offset(-10)
        }
        
        self.cardView.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

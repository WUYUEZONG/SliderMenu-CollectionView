//
//  YZButton.swift
//  MyDemosInSwift
//
//  Created by zW on 16/8/14.
//  Copyright © 2016年 allen.wu. All rights reserved.
//

import UIKit

enum YZButtonType {
    case scale
    case normal
}

let YZButtonTagStart: NSInteger = 1000
let YZButtonScaleMaxFloat = 1.3
let YZButtonScaleMinFloat = 1.0
let YZButtonTransAnimationInterval : NSTimeInterval = 0.25

protocol YZButtonDelegate {

    func didSelectedAtButton(button: YZButton?)
}

class YZButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var scaleFloat = 0.0;
    var highlightColor : UIColor!

    var delegate: YZButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        dataInit()
    }


    class func initWithType(frame: CGRect,type: YZButtonType) -> YZButton? {

        switch type {
        case .scale:
            return YZScaleTypeButton.init(frame: frame)
        case .normal:
            return YZButton.init(frame: frame)
        }
    }

    func addAction(action: UIControlActionBlock) {
        self.inEventDoSomething(.TouchUpInside, doSomething: action)
    }

    func dataInit() {

    }
}


class YZScaleTypeButton: YZButton {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var isNeededAnimation : Bool = false
    private var defaultHightlightColor = UIColor.init(red: 147/255.0, green: 224/255.0, blue: 1, alpha: 1);

    override var highlightColor: UIColor! {
        set {
            if (newValue != nil) {
                defaultHightlightColor = highlightColor
            }
        }
        get {
            return defaultHightlightColor
        }
    }

    override var scaleFloat: Double {
        didSet {

            var scaleColorFloat = scaleFloat;
            var titleColor:UIColor!
            if scaleColorFloat < 1.05 {
                titleColor = UIColor.whiteColor()
            } else {
                if scaleColorFloat < 1.20 {
                    scaleColorFloat = 1.2
                }

            titleColor = highlightColor.colorWithAlphaComponent(CGFloat(scaleColorFloat/YZButtonScaleMaxFloat))
            }
            self.setTitleColor(titleColor, forState: .Normal)
            if isNeededAnimation {
                if scaleFloat >= YZButtonScaleMaxFloat {
                    UIView.animateWithDuration(YZButtonTransAnimationInterval, animations: {
                        self.transform = self.transScale(YZButtonScaleMaxFloat)
                    })
                } else {
                    if scaleFloat <= 1.05 {
                        UIView.animateWithDuration(YZButtonTransAnimationInterval, animations: {
                            self.transform = self.transBack()
                        })
                    }
                }
            } else {
                if scaleFloat > YZButtonScaleMaxFloat - 0.05 {
                    self.transform = self.transScale(YZButtonScaleMaxFloat)
                } else {
                    if scaleFloat <= 1.05 {
                        self.transform = self.transBack()
                    } else {
                        self.transform = self.transScale(scaleFloat)
                    }
                }
            }
            isNeededAnimation = false
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
    }


    override func dataInit() {
        self.addAction { (sender) in
            // 选择时的缩放动画
            self.isNeededAnimation = true
            self.scaleFloat = YZButtonScaleMaxFloat
            self.delegate?.didSelectedAtButton(self)
        }
    }


    func transScale(scaleFloat: Double) -> CGAffineTransform {
        return CGAffineTransformMakeScale(CGFloat(scaleFloat), CGFloat(scaleFloat));
    }

    func transBack() -> CGAffineTransform {
        return CGAffineTransformIdentity
    }
}
//
//  SliderMenuView.swift
//  MyDemosInSwift
//
//  Created by allen on 16/8/26.
//  Copyright © 2016年 allen.wu. All rights reserved.
//

import UIKit

protocol SliderMenuViewDelegate {

    func didSelectedAtIndex(index: NSInteger , animated: Bool)
}

class SliderMenuView: YZView, YZButtonDelegate {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var titles: [String] = [];
    var delegate : SliderMenuViewDelegate!
    var index : NSInteger = 0 {
        didSet {
            initIndex = index
            if !YZButtons.isEmpty {
                YZButtons[index]?.scaleFloat = YZButtonScaleMaxFloat
                self.delegate.didSelectedAtIndex(index, animated: isAnimated)
                selectTitleGotoCenter(index)
            }
            isAnimated = true
        }
    }

    override var backgroundColor: UIColor? {
        didSet {
            mainScrolleView.backgroundColor = backgroundColor
        }
    }

    private var isAnimated: Bool = false
    private var initIndex : NSInteger = 0;
    private var titleWidths : [NSNumber] = []
    private var YZButtons : [YZButton?] = []
    private var mainScrolleView: UIScrollView!
    private var buttonsTotalLength: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        mainScrolleView = UIScrollView.init(frame: CGRectMake(0, 0, frame.width, frame.height))
        mainScrolleView.showsVerticalScrollIndicator = false
        mainScrolleView.showsHorizontalScrollIndicator = false
        mainScrolleView.backgroundColor = UIColor.init(red: 255/255.0, green: 66/255.0, blue: 93/255, alpha: 1)
        	
        self.addSubview(mainScrolleView)


    }

    override func drawRect(rect: CGRect) {
        drawMainViews()
    }

    /// 构建画面
    func drawMainViews() {
        //
        titleWidths = getTitleWidths(titles)
        if YZButtons.isEmpty {
            for index in 0..<titles.count {
                let button = YZButton.initWithType(CGRectMake(getButtonMinX(index), 0, CGFloat.init(titleWidths[index]), self.frame.height), type: .scale)
                button?.setTitle(titles[index], forState: .Normal)
                button?.delegate = self
                button?.tag = YZButtonTagStart+index
                YZButtons.append(button)
                mainScrolleView.addSubview(button!)
            }
            mainScrolleView.contentSize = CGSizeMake(buttonsTotalLength, self.frame.height)
        }
        isAnimated = false
        index = initIndex
    }

    /// 根据title宽度返回item宽度
    func getTitleWidths(titles: [String]) -> [NSNumber] {
        var titleWidthArray: [NSNumber] = [];
        var widths : [NSNumber] = [];
        for title in titles {
            let titleWidth = NSNumber(double: (title.width() + 50))
            titleWidthArray.append(titleWidth)
        }
        buttonsTotalLength = getTotalLength(titleWidthArray)
        if buttonsTotalLength <= self.frame.width {
            buttonsTotalLength = self.frame.width
            let width = self.frame.width/CGFloat.init(titles.count)
            for _ in 0..<titles.count{
                widths.append(width)
            }
            titleWidthArray = widths
        }
        return titleWidthArray
    }

    /// 获得items的总长度
    func getTotalLength(buttonWidths: [NSNumber]) -> CGFloat {
        var totalLength: CGFloat = 0;
        for width in buttonWidths {
            let butttonWith = CGFloat.init(width)
            totalLength += butttonWith
        }
        return totalLength <= self.frame.width ? self.frame.width : totalLength
    }

    /// 根据title不同宽度获取item该显示的最小x坐标
    func getButtonMinX(index: NSInteger) -> CGFloat {
        var minX: CGFloat = 0;
        for itemIndex in 0..<index {
            minX += CGFloat.init(titleWidths[itemIndex])
        }
        return minX
    }

    /// 将item置中心位置
    func selectTitleGotoCenter(index: NSInteger) {
        if !YZButtons.isEmpty {
            let indexButton = YZButtons[index]!
            let judageLength = (self.frame.width + indexButton.frame.width)/2

            if buttonsTotalLength > self.frame.width {
                if indexButton.frame.maxX <= judageLength{
                    mainScrolleView.setContentOffset(CGPointZero, animated: true)
                } else if indexButton.frame.minX >= buttonsTotalLength - judageLength {
                    mainScrolleView.setContentOffset(CGPointMake(buttonsTotalLength-self.frame.width, 0) , animated: true)
                } else {
                    // 可滑动
                    mainScrolleView.setContentOffset(CGPointMake(indexButton.frame.midX-self.frame.width/2, 0), animated: true)
                }
            }
        }
    }

    /// 给对应的item进行缩放
    func itemScaledByDistance(distance: Double) {

        let scaleFloat = (fabs(distance)/Double(self.frame.width))*YZButtonScaleMaxFloat

        let currentItem = YZButtons[index]
        let nextItem : YZButton?
        if distance > 0 {
            // 左
            if index <= 0 {
                nextItem = YZButton.init(frame: CGRectZero)
            } else {
                nextItem = YZButtons[index-1]
            }
        } else {
            if index >= YZButtons.count-1 {
                nextItem = YZButton.init(frame: CGRectZero)
            } else {
                nextItem = YZButtons[index+1]
            }
        }
        nextItem?.scaleFloat = 1 + scaleFloat
        currentItem?.scaleFloat = YZButtonScaleMaxFloat - scaleFloat
    }

    /// 设定最终状态，除需要高亮的外全部返回初始状态
    func sliderMenuWillScrollToIndex(targetIndex: NSInteger) {
        let lastItem : YZButton?
        let nextItem : YZButton?
        if targetIndex == 0 {
            nextItem = YZButtons[targetIndex + 1]
            lastItem = YZButton.init(frame: CGRectZero)
        } else if targetIndex >= YZButtons.count - 1 {
            nextItem = YZButton.init(frame: CGRectZero)
            lastItem = YZButtons[targetIndex - 1]
        } else {
            nextItem = YZButtons[targetIndex + 1]
            lastItem = YZButtons[targetIndex - 1]
        }
        /// 返回初始状态
        lastItem?.scaleFloat = YZButtonScaleMinFloat
        nextItem?.scaleFloat = YZButtonScaleMinFloat
        index = targetIndex;

    }

    // MARK: YZButtonDelegate
    func didSelectedAtButton(button: YZButton?) {
        if button?.tag != YZButtonTagStart+index {
            YZButtons[index]?.scaleFloat = YZButtonScaleMinFloat;
        }
        index = (button?.tag)! - YZButtonTagStart;
    }

}




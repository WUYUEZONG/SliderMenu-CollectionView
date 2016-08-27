//
//  ViewController.swift
//  MyDemosInSwift
//
//  Created by zW on 16/8/13.
//  Copyright © 2016年 allen.wu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SliderMenuInfoViewDelegate, SliderMenuViewDelegate {

    var sliderMenu :SliderMenuView!
    var collection : SliderMenuInfoView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let statusBarBackgroundView = YZView.init(frame: CGRectMake(0, 0, self.view.frame.width, 20))
        statusBarBackgroundView.backgroundColor = UIColor.init(red: 255/255.0, green: 66/255.0, blue: 93/255, alpha: 1)
            
        self.view.addSubview(statusBarBackgroundView)

        sliderMenu = SliderMenuView.init(frame: CGRectMake(0, 20, self.view.frame.width, 44))
        sliderMenu.titles = ["你","好","Swift","编程","之","美","新生","梦","想"]
        sliderMenu.delegate = self
        sliderMenu.index = 3
        self.view.addSubview(sliderMenu)

        collection = SliderMenuInfoView.init(frame: CGRectMake(0, 64, self.view.frame.width, self.view.frame.height-64))
        collection.models = [UIImage.init(named: "image1")!,
                             UIImage.init(named: "image2")!,
                             UIImage.init(named: "image3")!,
                             UIImage.init(named: "image4")!,
                             UIImage.init(named: "image5")!,
                             UIImage.init(named: "image6")!,
                             UIImage.init(named: "image7")!,
                             UIImage.init(named: "image8")!,
                             UIImage.init(named: "image9")!]
        collection.gestureDelegate = self
        self.view.addSubview(collection)

    }

    //MARK: - Delegate

    func didSelectedAtIndex(index: NSInteger, animated: Bool) {
        collection.scrollToItemAtIndexPath(NSIndexPath.init(forRow: index, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: animated)
    }

    func collectionView(collectionView: SliderMenuInfoView, panning pan: UIPanGestureRecognizer) {
        sliderMenu.itemScaledByDistance(Double(pan.translationInView(collectionView).x))
    }

    func collectionView(collectionView: SliderMenuInfoView, didEndPan pan: UIPanGestureRecognizer, to targetIndex: NSInteger) {
        sliderMenu.sliderMenuWillScrollToIndex(targetIndex)
    }




}


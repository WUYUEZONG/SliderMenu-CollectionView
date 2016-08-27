//
//  SliderMenuInfoView.swift
//  MyDemosInSwift
//
//  Created by allen on 16/8/26.
//  Copyright © 2016年 allen.wu. All rights reserved.
//

import UIKit



protocol SliderMenuInfoViewDelegate {
    /// 手指还未离开屏幕时的移动
    func collectionView(collectionView: SliderMenuInfoView, panning pan: UIPanGestureRecognizer)
    /// 手指离开屏幕时，targetIndex : 将要停止的到目标Cell的 Index
    func collectionView(collectionView: SliderMenuInfoView, didEndPan pan: UIPanGestureRecognizer, to targetIndex: NSInteger)
}

class SliderMenuInfoView: UICollectionView , UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {


    var models:[UIImage] = []
    var gestureDelegate : SliderMenuInfoViewDelegate!

    private var targetIndex : NSInteger = 0

    private let SliderMenuCollectionCellIdentifier = "SliderMenuCollectionCellIdentifier"

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }

    init(frame: CGRect) {

        let edgeInset : CGFloat = 10
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: frame.width - edgeInset, height: frame.height - edgeInset)
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .Horizontal

        super.init(frame: frame, collectionViewLayout: layout)

        self.registerClass(SliderMenuInfoViewCell.self, forCellWithReuseIdentifier: SliderMenuCollectionCellIdentifier)

        self.delegate = self
        self.dataSource = self
        self.pagingEnabled = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.contentInset = UIEdgeInsets.init(top: edgeInset/2, left: edgeInset/2, bottom: edgeInset/2, right: edgeInset/2)
        self.backgroundColor = UIColor.whiteColor()
        self.panGestureRecognizer.addTarget(self, action: #selector(panGestureActionInState(_:)))
    }


    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let offsetX = targetContentOffset.memory.x
        targetIndex = lroundf(Float(offsetX/self.frame.width))
    }

    func panGestureActionInState(gesture: UIPanGestureRecognizer) {

        if gesture.state == .Changed {
            self.gestureDelegate.collectionView(self, panning: gesture)
        }

        if gesture.state == .Ended {
            self.gestureDelegate.collectionView(self, didEndPan: gesture, to: targetIndex)
        }

    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SliderMenuCollectionCellIdentifier, forIndexPath: indexPath) as! SliderMenuInfoViewCell
        cell.image = models[indexPath.row]
        return cell
    }




    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK - : SliderMenuInfoViewCell
class SliderMenuInfoViewCell : UICollectionViewCell {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var image : UIImage! {
        didSet {
            imageView.image = image
        }
    }
    private var imageView : UIImageView! = UIImageView.init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.contentView.addSubview(imageView)
        
    }
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        imageView.frame = rect
    }


}



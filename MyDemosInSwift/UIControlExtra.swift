//
//  UIControlExtra.swift
//  MyDemosInSwift
//
//  Created by zW on 16/8/14.
//  Copyright © 2016年 allen.wu. All rights reserved.
//

import UIKit

typealias UIControlActionBlock = @convention(block)(sender: AnyObject)->()
var UIControlActionBlockKey = "UIControlActionBlockKey"

extension UIControl {

    func inEventDoSomething(event: UIControlEvents, doSomething:UIControlActionBlock) {
        self.addTarget(self, action: #selector(doSomeAction), forControlEvents: event)
        let actionObject: AnyObject = unsafeBitCast(doSomething, AnyObject.self)
        objc_setAssociatedObject(self, &UIControlActionBlockKey, actionObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    @objc private func doSomeAction(sender: AnyObject) {
        let actionBlock: UIControlActionBlock = unsafeBitCast(objc_getAssociatedObject(self, &UIControlActionBlockKey), UIControlActionBlock.self)
        actionBlock(sender: sender);
    }
}

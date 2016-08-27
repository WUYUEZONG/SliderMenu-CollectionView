//
//  StringExtra.swift
//  MyDemosInSwift
//
//  Created by allen on 16/8/26.
//  Copyright © 2016年 allen.wu. All rights reserved.
//

import UIKit

extension String {

    func width() -> Double {
        let string: NSString = NSString.init(string: self);
        let stringSize = string.boundingRectWithSize(CGSizeMake(CGFloat.max, 30), options: .UsesLineFragmentOrigin, attributes: nil, context: nil)
        return Double(stringSize.width)
    }
}
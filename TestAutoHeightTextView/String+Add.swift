//
//  String+Add.swift
//  TestSwift
//
//  Created by 周鑫 on 2019/3/12.
//  Copyright © 2019 周鑫. All rights reserved.
//

import UIKit

extension String {
    public func getHeight(width: CGFloat, fontSize: CGFloat, space: CGFloat = 0) -> CGFloat {
        let str: NSString = self as NSString
        var attributes = Dictionary<NSAttributedString.Key, Any>()
        attributes.updateValue(UIFont.systemFont(ofSize: fontSize), forKey: NSAttributedString.Key.font)
        if space > 0 {
            let paraStyle = NSMutableParagraphStyle()
            paraStyle.lineSpacing = space
            attributes.updateValue(paraStyle, forKey: NSAttributedString.Key.paragraphStyle)
        }
        return str.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size.height
    }
}

struct RuleText {
    enum Error: Swift.Error {
        case empty                      // 空字符串
        case excessiveLength            // 超出长度
    }
    
    private(set) var value: String
    
    @discardableResult
    init(_ string: String, maxLength: Int? = 0) throws {
        if string.isEmpty {
            throw Error.empty
        }
        
        guard maxLength == 0 || string.count < maxLength! else {
            throw Error.excessiveLength
        }
        self.value = string
    }
}

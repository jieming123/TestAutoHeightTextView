//
//  UIButton+Add.swift
//  TestSwift
//
//  Created by 周鑫 on 2019/2/25.
//  Copyright © 2019 周鑫. All rights reserved.
//

import UIKit

private var onClickKey: Void?
private var touchEventKey: Void?

extension UIButton {
    typealias ClickClosure = (_ btn: UIButton) -> Void
    
    var onClick: ClickClosure? {
        get {
            return objc_getAssociatedObject(self, &onClickKey) as? ClickClosure
        }
        set {
            if touchEvents == nil {
                touchEvents = .touchUpInside
            }
            addTarget(self, action: #selector(invoke), for: touchEvents!)
            objc_setAssociatedObject(self, &onClickKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    var touchEvents: UIControl.Event? {
        get {
            return objc_getAssociatedObject(self, &touchEventKey) as? UIControl.Event
        }
        set {
            objc_setAssociatedObject(self, &touchEventKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @objc func invoke(_ btn: UIButton) {
        if onClick != nil {
            onClick!(btn)
        }
    }
    
    
}

//
//  WQTextView.swift
//  TestSwift
//
//  Created by zhouxin on 2019/3/12.
//  Copyright © 2019 zhouxin. All rights reserved.
//

import UIKit

class WQTextView: UITextView {
    private var defaultFontSize: CGFloat = 13
    private var containerView: UIView!
    private var placeHolderLabel: UILabel!
    private var ob: NSKeyValueObservation?
    private var _isObserverFrame: Bool!
    private var _isFixContainerH: Bool!
    private var _height: CGFloat!
    private var space: CGFloat!
    
    typealias ChangeFrameClosure = (CGFloat) -> ()
    typealias InputErrorClosure = (RuleText.Error) -> ()
    
    public var changeFrameClosure: ChangeFrameClosure?
    public var inputErrorClosure: InputErrorClosure?
    /// 是否设置与container一样的高度
    public var isFixContainerH: Bool! {
        get { return _isFixContainerH }
        set {
            _isFixContainerH = newValue
            if newValue {
                frame.size.height = containerView.frame.size.height
            } else {
                frame.size.height = _height
            }
        }
    }
    
    /// 是否监听frame变化，默认为true
    public var isObserverFrame: Bool! {
        get { return _isObserverFrame }
        set {
            _isObserverFrame = newValue
            if newValue {
                containerView.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
            } else {
                containerView.removeObserver(self, forKeyPath: "frame")
            }
        }
    }
    /// 占位字符
    public var placeholder: String? {
        didSet {
            placeHolderLabel.text = placeholder
        }
    }
    /// 占位字符颜色
    public var placeholderColor: UIColor? {
        didSet {
            placeHolderLabel.textColor = placeholderColor
        }
    }
    /// 最大行数，默认为0，表示不限制行数
    public var maxLines: Int = 0
    /// 最大字数，默认为0，表示不限制字数
    public var maxLength: Int = 0
    /// 当前行数
    private(set) var lineCount: Int = 0
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        getView()
        _height = frame.size.height
        isObserverFrame = true
        isFixContainerH = true
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChanged(_:)), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc private func textViewDidChanged(_ notify: Notification) {
        do {
            try RuleText(text, maxLength: self.maxLength)
        } catch {
            if inputErrorClosure != nil {
                inputErrorClosure!(error as! RuleText.Error)
            }
        }
    }
    
    override var font: UIFont? {
        didSet {
            placeHolderLabel.font = font
        }
    }
    
    private func getView() {
        containerView = (value(forKey: "_containerView") as! UIView)        
        placeHolderLabel = UILabel()
        placeHolderLabel.numberOfLines = 1
        placeHolderLabel.textColor = .lightGray
        placeHolderLabel.sizeToFit()
        addSubview(placeHolderLabel)
        font = UIFont.systemFont(ofSize: defaultFontSize)
        placeHolderLabel.font = UIFont.systemFont(ofSize: defaultFontSize)
        setValue(placeHolderLabel, forKey: "_placeholderLabel")
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change else {
            return
        }
        space = placeHolderLabel.frame.origin.x * 2
        let textH = text.getHeight(width: frame.size.width - space, fontSize: font!.pointSize)
        lineCount = Int(textH / font!.lineHeight)
        if lineCount >= 1 && (lineCount <= maxLines || maxLines == 0) {
            var textFrame = frame
            let rect = change[.newKey] as? CGRect
            let height: CGFloat = (rect?.size.height)!
            if !isFixContainerH && _height > height { return }
            if changeFrameClosure != nil {
                changeFrameClosure!(height)
            }
            textFrame.size.height = height
            UIView.animate(withDuration: 0.26) {
                self.frame = textFrame
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

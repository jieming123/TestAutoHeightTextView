//
//  ViewController.swift
//  TestAutoHeightTextView
//
//  Created by 周鑫 on 2019/3/13.
//  Copyright © 2019 周鑫. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        testTextView()
    }

    private func testTextView() {
        let padding: CGFloat = 15
        let bgView = UIView(frame: CGRect(x: 10, y: 100, width: 300, height: 0))
        bgView.backgroundColor = .gray
        view.addSubview(bgView)
        
        let textView = WQTextView(frame: CGRect(x: 10, y: padding, width: 280, height: 30))
        textView.backgroundColor = .cyan
        textView.placeholder = "please enter"
        textView.maxLines = 3
        textView.maxLength = 100
        textView.inputErrorClosure = { error in
            print(error)
        }
        textView.changeFrameClosure = { height in
            var bgFrame = bgView.frame
            bgFrame.size.height = height + padding * 2
            UIView.animate(withDuration: 0.26, animations: {
                bgView.frame = bgFrame
            })
        }
        bgView.addSubview(textView)
        bgView.frame.size.height = textView.frame.size.height + padding * 2
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 100, y: 300, width: 100, height: 100)
        btn.onClick = { button in
            textView.text.removeAll()
        }
        btn.setTitle("clear", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        view.addSubview(btn)
    }
}


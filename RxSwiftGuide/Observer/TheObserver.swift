//
//  Observer.swift
//  RxSwiftGuide
//
//  Created by qingfengiOS on 2018/6/29.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TheObserver: UIViewController {

    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let btn = UIButton(frame: CGRect(x: 150, y: 100, width: 100, height: 60))
        btn.backgroundColor = UIColor.green
        btn.setTitle("click me", for: UIControlState.normal)
        self.view.addSubview(btn)

        /*
         如何创建观察者
         
         现在我们已经知道观察者主要是做什么的了。那么我们要怎么创建它们呢？
         
         和 Observable 一样，框架已经帮我们创建好了许多常用的观察者。例如：view 是否隐藏，button 是否可点击， label 的当前文本，imageView 的当前图片等等。
         
         另外，有一些自定义的观察者是需要我们自己创建的。这里介绍一下创建观察者最基本的方法，例如，我们创建一个弹出提示框的的观察者：
         */
        btn.rx.tap.subscribe(onNext: { [weak self] in
            self?.showAlert()
            }, onError: { error in
                print("发生错误： \(error.localizedDescription)")
        }, onCompleted:{
            print("任务完成")
        })
            .disposed(by: disposeBag)
    }

    
    func showAlert()  {
        let alertController = UIAlertController(title: "title", message: "message", preferredStyle: UIAlertControllerStyle.alert)
        
        let sure = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(sure)
        self.present(alertController, animated: true, completion: nil)
    }

    

}

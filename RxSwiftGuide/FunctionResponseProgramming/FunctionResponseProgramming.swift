//
//  FunctionResponseProgramming.swift
//  RxSwiftGuide
//
//  Created by qingfengiOS on 2018/6/20.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FunctionResponseProgramming: UIViewController {

    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        normalAlert()
        
        rxAlert()
    }
    
    
    
    func normalAlert() {
        // 按钮点击序列
        let taps: Array<Void> = [(),(),()]
        // 每次点击后弹出提示框
        taps.forEach {
            showAlert()
        }
        /*
         这样处理点击事件是非常理想的，但是问题是这个序列里面的元素（点击事件）是异步产生的，传统序列是无法描叙这种元素异步产生的情况。为了解决这个问题，于是就产生了可被监听的序列Observable<Element>。它也是一个序列，只不过这个序列里面的元素可以是同步产生的，也可以是异步产生的
         */
    }

    func rxAlert() {
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.bounds = CGRect(x: 0, y:0, width: 100, height: 50)
        button.center = self.view.center
        button.backgroundColor = UIColor.red
        button.setTitle("rxAlert", for: UIControlState.normal)
        self.view .addSubview(button)
        
        let taps: Observable<Void> = button.rx.tap.asObservable()
        taps.subscribe(onNext: { self.showAlert() }).disposed(by: disposeBag)
        
    }
    
    func showAlert() {
        print("show alert")
        let alert: UIAlertController = UIAlertController(title: "alert", message: "message", preferredStyle: UIAlertControllerStyle.alert)
        
        let sureAction = UIAlertAction(title: "sure", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(sureAction)
        self.present(alert, animated: true, completion: nil)
    }

}

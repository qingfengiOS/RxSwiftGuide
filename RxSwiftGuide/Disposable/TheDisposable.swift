//
//  Disposable.swift
//  RxSwiftGuide
//
//  Created by qingfeng on 2018/7/17.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//
//可被清除的资源
import UIKit
import RxCocoa
import RxSwift

class TheDisposable: UIViewController {

    /*
     通常来说，一个序列如果发出了 error 或者 completed 事件，那么所有内部资源都会被释放。如果你需要提前释放这些资源或取消订阅的话，那么你可以对返回的 可被清除的资源（Disposable） 调用 dispose 方法：
     */
    var disposable: Disposable?
    let textField: UITextField = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.disposable = textField.rx.text.orEmpty.subscribe(onNext: { text in
            print(text)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.disposable?.dispose()
    }
    
    /*
     通常来说，一个序列如果发出了 error 或者 completed 事件，那么所有内部资源都会被释放。如果你需要提前释放这些资源或取消订阅的话，那么你可以对返回的 可被清除的资源（Disposable） 调用 dispose 方法
     
     调用 dispose 方法后，订阅将被取消，并且内部资源都会被释放。通常情况下，你是不需要手动调用 dispose 方法的，这里只是做个演示而已。我们推荐使用 清除包（DisposeBag） 或者 takeUntil 操作符 来管理订阅的生命周期。
    */
}

//MARK:-DisposeBag自动清除包
/// 清除包
/*
 因为我们用的是 Swift ，所以我们更习惯于使用 ARC 来管理内存。那么我们能不能用 ARC 来管理订阅的生命周期了。答案是肯定了，你可以用 清除包（DisposeBag） 来实现这种订阅管理机制：
 */
class TheDisposeBag: UIViewController {
    var disposeBag = DisposeBag()
    let textField: UITextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.rx.text.orEmpty.subscribe(onNext: { text in
            print(text)
        }).disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.disposeBag = DisposeBag()
    }
    /*
     当 清除包 被释放的时候，清除包 内部所有 可被清除的资源（Disposable） 都将被清除
     */
}

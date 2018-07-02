//
//  TheBinder.swift
//  RxSwiftGuide
//
//  Created by qingfengiOS on 2018/7/2.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TheBinder: UIViewController {

    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var usernameValidOutlet: UILabel!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidOutlet: UILabel!
    
    @IBOutlet weak var doSomethingOutlet: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        /*
         Binder 主要有以下两个特征：
         
         不会处理错误事件
         确保绑定都是在给定 Scheduler 上执行（默认 MainScheduler）
         一旦产生错误事件，在调试环境下将执行 fatalError，在发布环境下将打印错误信息。
         */
        
        usernameValidOutlet.text = "Username has to be at least 3 characters"
        passwordValidOutlet.text = "Password has to be at least 3 characters"
//        useObserver()
        
        //由于这个观察者是一个 UI 观察者，所以它在响应事件时，只会处理 next 事件，并且更新 UI 的操作需要在主线程上执行。
        //因此一个更好的方案就是使用 Binder：
        useBinder()
        
    }

    func useObserver() {
        let oberver: AnyObserver<Bool> = AnyObserver { [weak self] (event) in
            
            switch event {
            case .next(let isHidden):
                self?.usernameValidOutlet.isHidden = isHidden
            case .error(let error):
                print("error = \(error)")
                break
            case .completed:
                break
            }
        }
        
        let usernameValid = usernameOutlet.rx.text.orEmpty
            .map { $0.count >= 3}
            .share(replay: 1)
        
        usernameValid
            .bind(to: oberver)
            .disposed(by: disposeBag)
        
    }
    
    
    func useBinder() {
        //用户名
//        let observer: Binder<Bool> = Binder(usernameValidOutlet) { (view,isHidden) in
//            view.isHidden = isHidden
//        }

//        usernameValid
//            .bind(to: observer)
//            .disposed(by: disposeBag)

        let usernameValid = usernameOutlet.rx.text.orEmpty
            .map { $0.count >= 3}
            .share(replay: 1)
        
        usernameValid//使用extension的扩展
        .bind(to: usernameValidOutlet.rx.isHidden)
        .disposed(by: disposeBag)
        
        //密码
        let pwdObserver: Binder<Bool> = Binder(passwordValidOutlet) { (view, isHidden) in
            view.isHidden = isHidden
        }
        let pwdValid = passwordOutlet.rx.text.orEmpty
            .map { $0.count >= 3 }
            .share(replay: 1)
        pwdValid
            .bind(to: pwdObserver)
            .disposed(by: disposeBag)
        
        //combineLatest
        let allValid = Observable.combineLatest(usernameValid, pwdValid){ $0 && $1 }
            .share(replay: 1)
        allValid.bind(to: doSomethingOutlet.rx.isEnabled)
                .disposed(by: disposeBag)
        
//        allValid.bind(to: doSomethingOutlet.rx.alpha) { isalpha = 0.5 }
//            .disposed(by: disposeBag)
        
        
    }

}

//MARK:-复用
extension Reactive where Base: UIView {
    
    public var isHidden: Binder<Bool> {
        
        return Binder(self.base) { view, hidden in
            view.isHidden = hidden
        }
    }
    
}

extension Reactive where Base: UIView {
    
    public var alpha: Binder<CGFloat?> {
        
        return Binder(self.base) { view, alpha in
            view.alpha = alpha!
        }
    }
}







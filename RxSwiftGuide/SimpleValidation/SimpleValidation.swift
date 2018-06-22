//
//  SimpleValidation.swift
//  RxSwiftGuide
//
//  Created by qingfengiOS on 2018/6/20.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate let minimalUsernameLength = 5
fileprivate let minimalPasswordLength = 5

class SimpleValidation: UIViewController {

    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var usernameValidOutlet: UILabel!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidOutlet: UILabel!
    
    @IBOutlet weak var doSomethingOutlet: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameValidOutlet.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValidOutlet.text = "Password has to be at least \(minimalPasswordLength) characters"

        //当用户名输入不到 5 个字时显示提示语，并且无法输入密码
        let usenameValid = usernameOutlet.rx.text.orEmpty
            .map{ $0.count >= minimalUsernameLength }
            .share(replay: 1)

        // 用户名是否有效 -> 密码输入框是否可用
        usenameValid
            .bind(to: passwordOutlet.rx.isEnabled)
            .disposed(by: disposeBag)

        // 用户名是否有效 -> 用户名提示语是否隐藏
        usenameValid.bind(to: usernameValidOutlet.rx.isHidden)
                    .disposed(by: disposeBag)

        //密码是否有效
        let passwordValid = passwordOutlet.rx.text.orEmpty
            .map{ $0.count >= minimalPasswordLength }
            .share(replay: 1)
        // 密码是否有效 -> 密码提示语是否隐藏
        passwordValid.bind(to: passwordValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)

        //所有输入有效
        let allValid = Observable.combineLatest(
                                    usenameValid,
                                    passwordValid){ $0 && $1 }
                                  .share(replay: 1)
        allValid.bind(to: doSomethingOutlet.rx.isEnabled)
            .disposed(by: disposeBag)
        
        //按钮点击事件
        doSomethingOutlet.rx.tap.subscribe(onNext:{ [weak self] in self?.showAlert() })
            .disposed(by: disposeBag)
        
    }

    func showAlert() {
        let alertView = UIAlertView(
            title: "RxExample",
            message: "This is wonderful",
            delegate: nil,
            cancelButtonTitle: "OK"
        )
        
        alertView.show()
    }
    
    //Rx分解
    func justLearn() {
        // Observable<String>
        let text = usernameOutlet.rx.text.orEmpty.asObservable()
        
        // Observable<Bool>
        let passwordValid = text
        
        // Operator
        .map { $0.count >= minimalPasswordLength }
        
        // Observer<Bool>
        let observer = passwordValidOutlet.rx.isHidden
        
        // Disposable
        let disposeable = passwordValid.subscribeOn(MainScheduler.instance)
                                        .observeOn(MainScheduler.instance)
                                        .bind(to: observer)
        
        // 取消绑定，你可以在退出页面时取消绑定
        disposeable.dispose()
        
        
        
    }
    

}

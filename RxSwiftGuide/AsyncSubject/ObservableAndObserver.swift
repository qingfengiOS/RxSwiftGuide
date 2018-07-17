//
//  TheAsyncSubject.swift
//  RxSwiftGuide
//
//  Created by qingfengiOS on 2018/7/2.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ObservableAndObserver: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        asyncSubject()
        publishSubject()
        replaySubject()
        behavioerSubject()
    }

    //MARK:-AsyncSubject
    func asyncSubject() {
        let subject = AsyncSubject<String>()
        subject
            .subscribe { print("Subscription: 1 Event :", $0) }
            .disposed(by: disposeBag)
        
        subject.onNext("🐶")
        subject.onNext("🐈")
        subject.onNext("🐴")
        subject.onCompleted()
        /*
         AsyncSubject 将在源 Observable 产生完成事件后，发出最后一个元素（仅仅只有最后一个元素），如果源 Observable 没有发出任何元素，只有一个完成事件。那 AsyncSubject 也只有一个完成事件。
         
         它会对随后的观察者发出最终元素。如果源 Observable 因为产生了一个 error 事件而中止， AsyncSubject 就不会发出任何元素，而是将这个 error 事件发送出来
         */
    }

    
    //MARK:-PublishSubject
    func publishSubject() {
        print("-----------------------")
        let subject = PublishSubject<String>()
        subject
            .subscribe { print("Subscription: 1 Event:", $0) }
            .disposed(by: disposeBag)
        subject.onNext("🐶")
        subject.onNext("🐱")
        
        subject
            .subscribe { print("Subscription: 2 Event:", $0) }
            .disposed(by: disposeBag)
        subject.onNext("A")
        subject.onNext("B")
        subject.onNext("C")
        subject.onNext("D")
        
        /*
         PublishSubject 将对观察者发送订阅后产生的元素，而在订阅前发出的元素将不会发送给观察者。如果你希望观察者接收到所有的元素，你可以通过使用 Observable 的 create 方法来创建 Observable，或者使用 ReplaySubject。
         
         如果源 Observable 因为产生了一个 error 事件而中止， PublishSubject 就不会发出任何元素，而是将这个 error 事件发送出来。
         */
    }
    
    //MARK:-ReplaySubject
    func replaySubject () {
        print("-----------------------")
        let subject = ReplaySubject<Int>.create(bufferSize: 1)
        
        subject
            .subscribe { print("Subscription: 1 Event:", $0) }
            .disposed(by: disposeBag)
        subject.onNext(0)
        subject.onNext(0)
        
        subject
            .subscribe { print("Subscription: 2 Event:", $0) }
            .disposed(by: disposeBag)
        subject.onNext(1)
        subject.onNext(2)
        subject.onNext(3)
        
        
       /*
         ReplaySubject 将对观察者发送全部的元素，无论观察者是何时进行订阅的。
         
         这里存在多个版本的 ReplaySubject，有的只会将最新的 n 个元素发送给观察者，有的只会将限制时间段内最新的元素发送给观察者。
         
         如果把 ReplaySubject 当作观察者来使用，注意不要在多个线程调用 onNext, onError 或 onCompleted。这样会导致无序调用，将造成意想不到的结果。
        */
    }
    
    //MARK:-BehavioerSubject
    func behavioerSubject() {
        print("-----------------------")
        let subject = BehaviorSubject(value: "❤️")//默认值
        
        subject
            .subscribe{ print("Subscription: 1 Event", $0) }
            .disposed(by: disposeBag)

        subject.onNext("🐩")
        subject.onNext("🐈")
        
        subject
            .subscribe{ print("Subscription: 2 Event", $0) }
            .disposed(by: disposeBag)
        
        subject.onNext("A")
        subject.onNext("B")
        
        subject
            .subscribe { print("Subscription: 3 Event", $0) }
            .disposed(by: disposeBag)
        
        subject.onNext("🍐")
        subject.onNext("🍊")
        /*
         当观察者对 BehaviorSubject 进行订阅时，它会将源 Observable 中最新的元素发送出来（如果不存在最新的元素，就发出默认元素）。然后将随后产生的元素发送出来。
         
         如果源 Observable 因为产生了一个 error 事件而中止， BehaviorSubject 就不会发出任何元素，而是将这个 error 事件发送出来。
         */
    }
    
    
}

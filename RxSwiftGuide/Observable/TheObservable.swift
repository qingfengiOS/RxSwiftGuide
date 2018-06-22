//
//  TheObservable.swift
//  RxSwiftGuide
//
//  Created by qingfengiOS on 2018/6/22.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//
//Observable - 可被监听的序列
import UIKit
import RxSwift
import RxCocoa

typealias JSON = Any

class TheObservable: UIViewController {

    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        create()
        observerJson()
    
    }
    
    func create () {
        /*
         所有的事物都是序列
         
         实际上，框架已经帮我们创建好了许多常用的序列。例如：button的点击，textField的当前文本，switch的开关状态，slider的当前数值等等。
         
         另外，有一些自定义的序列是需要我们自己创建的。这里介绍一下创建序列最基本的方法，例如，我们创建一个 [0, 1, ... 8, 9] 的序列
         */
        let numbers: Observable<Int> = Observable.create { observer -> Disposable in
            
            observer.onNext(0)
            observer.onNext(1)
            observer.onNext(2)
            observer.onNext(3)
            observer.onNext(4)
            observer.onNext(5)
            observer.onNext(6)
            observer.onNext(7)
            observer.onNext(8)
            observer.onNext(9)
            observer.onCompleted()
            return Disposables.create()
        }
        /*
         创建序列最直接的方式就是调用Observer.create,然后在构造函数里面描述元素产生的过程。
         
         oberver.onNext(0)就代表了一个元素的产生，其值为0。而后一次产生1~9,最后使用oberver.onCompleted() 表示元素已经完全产生，没有更多元素了。
         
         */
        print("numbers = \(numbers)")
    }
    
    /*
     可以用这种方式来封装功能组件，例如，闭包回调：
     */
    func observerJson() {
        let json: Observable<JSON> = Observable.create { (observer) -> Disposable in
            
            let url: URL = NSURL.init(string: "https://facebook.github.io/react-native/movies.json")! as URL
            
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                guard error == nil else {
                observer.onError(error!)
                return
            }
            
                guard let data = data,
                    let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) else {
                        observer.onError(error!)
                        return
                }
            
            observer.onNext(jsonObject)
            observer.onCompleted()
        })
        
            task.resume()
        
        return Disposables.create {
               task.cancel()
            }
        }
        
        /*
         在闭包回调中，如果任务失败，就调用 observer.onError(error!)。如果获取到目标元素，就调用 observer.onNext(jsonObject)。由于我们的这个序列只有一个元素，所以在成功获取到元素后，就直接调用 observer.onCompleted() 来表示任务结束。最后 Disposables.create { task.cancel() } 说明如果数据绑定被清除（订阅被取消）的话，就取消网络请求。
         */
        
        json.subscribe(onNext: { (json) in
            print("请求成功：json = \(json)")
        }, onError: { (error) in
            print("请求失败：error = \(error)")
        }, onCompleted: {
            print("请求完成")
        }).disposed(by: disposeBag)
        
        /*
         这里subscribe后面的onNext,onError, onCompleted 分别响应我们创建 json 时，构建函数里面的onNext,onError, onCompleted 事件。我们称这些事件为 Event
         */
        
        
    }
    
    
    
}


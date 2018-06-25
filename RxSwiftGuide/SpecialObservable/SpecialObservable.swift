//
//  SpecialObservable.swift
//  RxSwiftGuide
//
//  Created by qingfengiOS on 2018/6/24.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//
//特征序列
/*
 我们都知道 Swift 是一个强类型语言，而强类型语言相对于弱类型语言的一个优点是更加严谨。我们可以通过类型来判断出，实例有哪些特征。同样的在 RxSwift 里面 Observable 也存在一些特征序列，这些特征序列可以帮助我们更准确的描述序列。并且它们还可以给我们提供语法糖，让我们能够用更加优雅的方式书写代码，他们分别是：
 1、Single
 2、Completable
 3、Maybe
 4、Driver
 5、ControlEvent
 */
import UIKit
import RxCocoa
import RxSwift

class SpecialObservable: UIViewController {

    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        
        getRepo("ReactiveX/RxSwift")
            .subscribe(onSuccess: { json in
            print("JSON: ", json)
        }, onError: {error in
            print("Error: ", error)
        })
            .disposed(by: disposeBag)
        
        
        cacheLocally()
            .subscribe(onCompleted: {
                print("Completed with no error")
            }, onError: { error in
                print("Completed with an error: \(error)")
            })
            .disposed(by: disposeBag)
        
        
        generateString()
            .subscribe(onSuccess: { element in
                print("Completed with element: \(element)")
                
            },onError: { error in
                print("Completed with an error: \(error)")
            },onCompleted: {
                print("Completed with no error")
            })
            .disposed(by: disposeBag)
        
    }
    
    //MARK:-Single
    /*
     Single是Observable的另外一个版本。不像Observable可以发出多个元素，它要么只能发出一个元素，要么产生一个error事件。
     1、发出一个元素，或者一个error
     2、不会共享状态的变化
     
     一个比较常见的例子就是执行 HTTP 请求，然后返回一个应答或错误。不过你也可以用 Single 来描述任何只有一个元素的序列。
     */
    
    func getRepo(_ repo: String) -> Single<[String: Any]> {
        
        return Single.create { single in
            let url = URL(string: "https://api.github.com/repos/\(repo)")!
            
            let task = URLSession.shared.dataTask(with: url) {data,_,error in
                
                if let error = error {
                    single(.error(error))
                    return
                }
                
                guard let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
                    let result = json as? [String: Any] else {
//                        single(.error(DataError.cantParseJSON))
                        return
                }
                
                single(.success(result))
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
        /*
         sucess - 产生一个单独的元素
         error - 产生一个错误
         
         同样可以对 Observable 调用 .asSingle() 方法，将它转换为 Single。
         */
    }
    
    
    //MARK:-Completable
    /*
     Completable是Observable的另外一个版本。不像Observable可以发出多个元素，它要么只能产生一个completed事件，要么产生一个error事件。
     
     1、发出0个元素
     2、发出一个completed事件或者一个error事件
     3、不会共享状态的变化
     
     Completable 适用于那种你只关心任务是否完成，而不需要在意任务返回值的情况。它和 Observable<Void> 有点相似。
     */
    func cacheLocally() -> Completable {
        return Completable.create { completable in
            //存储一些本地数据
            /* .... */
            
//            guard success else {
//                completable(.error(cacheError.failedCaching))
//                return Disposables.create {}
//            }
            
            completable(.completed)
            return Disposables.create {}
            
        }
        /*
         completed - 产生完成事件
         error - 产生一个错误
         */
    }
    
    
    //MARK:-Maybe
    /*
     Maybe 是 Observable 的另外一个版本。它介于 Single 和 Completable 之间，它要么只能发出一个元素，要么产生一个 completed 事件，要么产生一个 error 事件。
     
     发出一个元素或者一个 completed 事件或者一个 error 事件
     不会共享状态变化
     如果你遇到那种可能需要发出一个元素，又可能不需要发出时，就可以使用 Maybe。
     */
    func generateString() -> Maybe<String> {
        return Maybe<String>.create { maybe in
            maybe(.success("RxSwift"))
            
            //OR
            
            maybe(.completed)
            
            //OR
//            maybe(.error(error))
            
            return Disposables.create {}
        }
        /*
         同样可以对 Observable 调用 .asMaybe() 方法，将它转换为 Maybe。
         */
    }
    
    
}



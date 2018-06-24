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
    }
    /*
     同样可以对 Observable 调用 .asSingle() 方法，将它转换为 Single。
     */
    
}



//
//  TheOperator.swift
//  RxSwiftGuide
//
//  Created by qingfeng on 2018/7/17.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//
// 操作符
import UIKit
import RxCocoa
import RxSwift

class Hamburg: NSObject {

}

class FrenchFries: NSObject {
    
}

class TheOperator: UIViewController {
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        filter()
        map()
        zip()
    }

    //MARK:-filter (过滤)
    func filter () {
        let rxTemprature: Observable<Double> = Observable.create { observer -> Disposable in
            return Disposables.create()
        }
        rxTemprature.filter { temperature in
            temperature > 33
        }
            .subscribe(onNext: { temprature in
                print("高温：\(temprature)")
            })
            .disposed(by: disposeBag)

    }
    //MARK:-map(转换)
    func map() {
        let json: Observable<JSON> = Observable.create({ observer -> Disposable in
            return Disposables.create()
        })
        
//        json.map(Model.init())
//            .subscribe(onNext: { model in
//                print("得到model：\(model)")
//            })
//            .disposed(by: disposeBag)
    }
    //MARK:-zip (配对)
    func zip() {
        let hamburg: Observable<Hamburg> = Observable.create({ observer -> Disposable in
            return Disposables.create()
        })
        
        let frenchFries: Observable<FrenchFries> = Observable.create({ observer ->Disposable in
            return Disposables.create()
        })
        
        Observable
            .zip(hamburg, frenchFries).subscribe(onNext: { (hum, fren) in
            print("取得汉堡: \(hamburg) 和薯条：\(frenchFries)")
        })
            .disposed(by: disposeBag)
        
    }
    
    
}

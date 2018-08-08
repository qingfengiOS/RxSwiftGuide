//
//  ViewController.swift
//  RxSwiftGuide
//
//  Created by qingfengiOS on 2018/6/19.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    let kCellIdentifier = "cellIdentifier"
    @IBOutlet weak var tableView: UITableView!
    var dataArray: [String] = []
    
    let disposeBag = DisposeBag()
    
    //MARK:-View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        dataArray = ["SimpleValidation",
                     "FunctionalProgramming",
                     "FunctionResponseProgramming",
                     "DataBind",
                     "TheObservable",
                     "SpecialObservable",
                     "Driver",
                     "TheObserver",
                     "TheBinder",
                     "ObservableAndObserver",
                     "TheOperator",
                     "TheDisposable",
                    ]
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellIdentifier)
        
        rxKeywords()
        networkWithMoya()
    }

    //MARK:-TableViewDelegate/DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: kCellIdentifier)
        cell.textLabel?.text = dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = getViewContrlooerByClassName(className: self.dataArray[indexPath.row])
        self.navigationController? .pushViewController(viewController!, animated: true)
    }
    
    //MARK:-CustomMethos
    func getViewContrlooerByClassName(className: String) -> UIViewController? {
        guard let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            return nil
        }
        guard let viewcontroller = NSClassFromString(namespace + "." + className) else {
            return nil
        }
        guard let type = viewcontroller as? UIViewController.Type else {
            return nil
        }
        let resViewController = type.init()
        
        return resViewController
    }

    //MARK:- RxSwift关键字
    func rxKeywords() {
        never()
        empty()
        just()
        of()
        from()
        create()
        range()
        repeatElement()
    }
    
    func never() {
        let neverSequence = Observable<String>.never()
        neverSequence
            .subscribe{ (_) in
                print("this will never be printed")
            }.disposed(by: disposeBag)
        
        print("-----------------")
    }
    
    func empty() {
        Observable<String>
            .empty()
            .subscribe{ event in
                print(event)
            }.disposed(by: disposeBag)
        
        print("-----------------")
    }
    
    func just() {
        Observable.just("🍎")
            .subscribe{ event in
                print(event)
            }.disposed(by: disposeBag)
        
        print("-----------------")
    }
    
    func of() {
        //of是创建一个sequence能发出很多种事件信号
        Observable.of("🐈","🐩","🐲")
            .subscribe(onNext: { element in
                print(element)
            }).disposed(by: disposeBag)
        //        如果把上面的onNext:去掉的话，结果会是这样子，也正好对应了我们subscribe中，subscribe只监听事件。
        print("如果把上面的onNext:去掉的话，结果会是这样子，也正好对应了我们subscribe中，subscribe只监听事件")
        Observable.of("🐈","🐩","🐲")
            .subscribe({ element in
                print(element)
            }).disposed(by: disposeBag)
        
        print("-----------------")
    }
    
    func from() {
        Observable.from(["🍐", "🍌", "🍊"])
            .subscribe(onNext:{ element in
                print(element)
            }).disposed(by: disposeBag)
    }
    
    
    /// create操作符传入一个观察者observer，然后调用observer的onNext，onCompleted和onError方法。返回一个可观察的obserable序列。
    func create() {
        let myJust = { (element: String) -> Observable<String> in
            return Observable.create{ observer in
                observer.on(.next(element))
                observer.on(.completed)
                return Disposables.create()
            }
        }
        
        myJust("🔴")
            .subscribe{ print($0) }
            .disposed(by: disposeBag)
        print("-----------------")
    }
    
    
    /// range就是创建一个sequence，他会发出这个范围中的从开始到结束的所有事件
    func range() {
        Observable.range(start: 1, count: 3)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        print("-----------------")
    }
    
    
    /// 创建一个sequence，发出特定的事件n次
    func repeatElement() {
        Observable.repeatElement("A")
            .take(2)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        print("-----------------")
    }
    
    
    func networkWithMoya() {
        let provider = MoyaProvider<MyAPI>()
        provider.request(.Show) { (result) in
            print(result)
        }
    }
    
}


enum MyAPI {
    case Show
    case Create(title: String, body: String, userId: Int)
}

extension MyAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://jsonplaceholder.typicode.com")!
    }
    var path: String {
        switch self {
        case .Show:
            return "/posts"
        case .Create(title: _, body: _, userId: _):
            return "/posts"
        }
    }
    var method: Moya.Method {
        switch self {
        case .Show:
            return .get
        case .Create(title: _, body: _, userId: _):
            return .post
        }
    }
    var paramter: [String: Any]? {
        
        switch self {
        case .Show:
            return nil
        case .Create(let title, let body, let userId):
            return ["title": title, "body": body, "userId": userId]
        }
    }
    var sampleData: Data {
        switch self {
        case .Show:
            return "[]".data(using: String.Encoding.utf8)!
        case .Create(_, _, _):
            return "Create post successfully".data(using: String.Encoding.utf8)!
        }
    }
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}

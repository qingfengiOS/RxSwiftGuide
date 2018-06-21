//
//  DataBind.swift
//  RxSwiftGuide
//
//  Created by qingfengiOS on 2018/6/21.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DataBind: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rxImageView: UIImageView!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        let image: UIImage = UIImage(named: "banner")!
        self.imageView.image = image

        
        let imageObserver: Observable<UIImage?> = Observable.just(UIImage(named: "banner"))
        imageObserver.bind(to:rxImageView.rx.image)
        .disposed(by: disposeBag)
        /*
         将一个图片序列“同步”到imageView上。这个序列里面的图片可以是异步产生的。而这种“同步机制”就是数据绑定（订阅）。
        */
        
    }

    
    

}

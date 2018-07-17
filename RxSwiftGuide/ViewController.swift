//
//  ViewController.swift
//  RxSwiftGuide
//
//  Created by qingfengiOS on 2018/6/19.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    let kCellIdentifier = "cellIdentifier"
    @IBOutlet weak var tableView: UITableView!
    var dataArray: [String] = []
    
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

}


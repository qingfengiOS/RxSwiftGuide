//
//  FunctionalProgramming.swift
//  RxSwiftGuide
//
//  Created by qingfengiOS on 2018/6/20.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

import UIKit

class FunctionalProgramming: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //获取全校学生
        let allStudents: [Student] = Student.getScholleStudents()
        
        
        //通过filter函数，获取指定条件的学生
        let gradeThreeClassTwoStudents: [Student] = allStudents.filter { student in student.grade == 3 && student.classes == 2 }
        let _: [Student] = allStudents.filter{ stu in Double(stu.score) < 60.0 }
        
        
        
        //同样的我们将性别的判断函数传递给 filter 方法，这样就能从三年二班的学生中过滤出男同学，然后将唱歌作为函数传递给 forEach 方法。于是每一个男同学都要唱《Fade》😄
        gradeThreeClassTwoStudents
            .filter{ stu in stu.sex == true }
            .forEach{ boy in boy.singSongs(boyName:boy.name, songName: "Fade") }
        
        
        //用分数判定来筛选出90分以上的同学，然后用map转换为学生家长，最后用forEach让每个家长上台领奖。
        gradeThreeClassTwoStudents
            .filter{ stu in stu.score > 90}
            .map{ stu in stu.parent}
            .forEach{ parent in parent.receiveAPrize(name: parent.name) }
        
        
        allStudents
            .sorted{ stu0, stu1 in stu0.score > stu1.score }
            .forEach{ stu in print("score: \(stu.score),  name: \(stu.name)") }
    }
    
    /*
     这就是函数式编程，它使我们可以通过组合不同的方法，以及不同的函数来获取目标结果。你可以想象如果我们用传统的 for 循环来完成相同的逻辑，那将会是一件多么繁琐的事情。所以函数试编程的优点是显而易见的：
     灵活
     高复用
     简洁
     易维护
     适应各种需求变化
     */

}

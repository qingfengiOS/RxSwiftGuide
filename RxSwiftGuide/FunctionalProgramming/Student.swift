//
//  Student.swift
//  RxSwiftGuide
//
//  Created by qingfengiOS on 2018/6/20.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

import UIKit

struct Student {

    var name: String
    var score: Double
    var sex: Bool
    var grade: Int
    var classes: Int
    var parent: Parent
    
    
    init(name: String, score: Double, sex: Bool, grade: Int, classes: Int, parent: Parent) {
        self.name = name
        self.score = score
        self.sex = sex
        self.grade = grade
        self.classes = classes
        self.parent = parent
    }
    
    
    /// 获取全校学生
    ///
    /// - Returns: 全校学生数组
    static func getScholleStudents() -> [Student] {
        var students = Array<Student>()
        
        let s1 = Student(name: "Ming", score: 60, sex: true, grade: 3, classes: 2, parent: Parent(name: "Ming Father"))
        students.append(s1)
        
        let s2 = Student(name: "Feng", score: 90, sex: false, grade: 3, classes: 1, parent: Parent(name: "Feng Father"))
        students.append(s2)
        
        let s3 = Student(name: "Qing", score: 88, sex: true, grade: 5, classes: 2, parent: Parent(name: "Qing Father"))
        students.append(s3)
        
        let s4 = Student(name: "Ali", score: 99, sex: true, grade: 3, classes: 2, parent: Parent(name: "Ali Father"))
        students.append(s4)
        
        let s5 = Student(name: "Fizz", score: 55, sex: true, grade: 4, classes: 2, parent: Parent(name: "Fizz Father"))
        students.append(s5)
        
        return students ;
    }
    
    func singSongs(boyName: String, songName: String) {
        print("\(boyName) sing the song name of \(songName)")
    }
}

struct Parent {
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func receiveAPrize(name: String) {
        print("\(name)上台领奖")
    }
}


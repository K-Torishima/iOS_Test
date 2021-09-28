//
//  ViewController.swift
//  iOS_Test
//
//  Created by 鳥嶋 晃次 on 2021/09/28.
//

import UIKit

class ViewController: UIViewController {
    
    var subClass: SubClass!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.subClass = SubClass(viewController: self)
        let result = subClass.multiply(num1: 12, num2: 23)
        print(result)
    }
}

class SubClass {
    
    // テストシナリオ
    // vcに掛け算の結果を返すメソッドを持たせる
    // 掛け算の結果が正常てあるかをテストで確認する
    
    private let viewController: ViewController
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
    
    func multiply(num1: Int, num2: Int) -> Int {
        return num1 * num2
    }
}

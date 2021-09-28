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
        
        // これはよくある確認実行特にコミットしないもの
        // これはコミットに残せない
        print(add(1, 2))
        
        
        // デバック時にテストを自動で実行する
        // このコードはデバック時以外では動作されないので、コミットしても良い
        // 自動化された繰り返し実行可能なものではる
        // しかしこのコードは課題がある
        // こんなのを毎回書くのは現実的ではない
        // 期待する結果にならなかった場合強制終了されるので一つテストしたいだけなのに動作確認ができなくなってしまう
        // 生産性がかなり低い
        // 統一化されていないためスケールしない
        #if DEBUG
        let x = add(1, 1)
        
        if x != 2 {
            fatalError("add(1,1)の結果が2でなかった. (実際の値: \(x)")
        }
        
        let y = add(1, 2)
        
        if y != 3 {
            fatalError("add(1,2)の結果が3でなかった. (実際の値: \(y)")
        }
        
        #endif
        
        
    }
    
    func add(_ x: Int, _ y: Int) -> Int {
        return x + y
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


// テストフレームワークを使う場合はこれでOK
//class AddTests: XCTestCase {
//func test_足し算が行えること() {
//XCTAssertEqual(add(1, 1), 2)
//XCTAssertEqual(add(1, 2), 3)
//}
//}

// テスティングフレームワークを使うことで自分で作る必要がない
// テストケースを増やしたい場合もテスト用のクラスやメソッドを増やすこともできる
// よって統一的な仕組みができる


// テストを書く目的
/*
 
 - より早い段階で不具合に気づく
 - コードや設計を継続的に改善できる状態にする
 - APIの利用方法をドキュメント化できる
 
 いらないコメントを書くくらいならテストを書いたほうが良い、
 テストを書いておけばその動作は確認できるし、テスト側にコメントが書ける
 
 次大事なところなので
 2.1.2 目的を読む
 
 */

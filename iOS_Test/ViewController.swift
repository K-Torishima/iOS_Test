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
 また不具合がある場合の切り分けになる、テストコードがなければモバイルが悪いのか、サーバーが悪いのかがわからない
 テストコードを書いていればそっちが悪いですね。って言えるし、テストを書くメリットが増える
 忙しいというのを理由にしてはいけない。
 
 APIのユニットテストを書いておくことによって対象APIの利用方法がわかるようになる
 細かくドキュメントを書くのも良いが読みづらいのでやめておいた方が良さそう
 だったらテストを書いてこれが使い方ですってなってる方が良さそう。
 
 
 ユニットテストの特徴
 - 高速かつ正確に実行できる
 　- リグレッションテストができる
 　　　メモ：
      リグレッションとは
 　　　 ソフトウェア開発の過程で不具合が発見されプログラムが修正されることはよくあるが、
       その修正によってそれまで正常に動作していた部分が異状をきたすようになることがある。
       このような現象を「デグレード」「リグレッション」などという

      リグレッションテストとは、
       ソフトウェアテストの一つで、プログラムの一部を変更・修正した際に、
       その変更によって予想外の影響が現れていないか確かめるもの。
 
 - 網羅的なテストが行いやすい
   - UIテストや手動テストは内部実装を意識しないテストになりがち
   - ユニットテストでは、内部構造を意識したテストが行いやすい
 
 
 内部構造をどこまで把握してテストするか
 - ブラックボックステスト
   - テスト対象の内部構造を知らない状態で外側から要求仕様を満たしているかを検証する方法
   - 実際のユーザーの視点で定めた仕様でテストする形になります。
 
 - ホワイトボックステスト
   - 内部モジュールが正しく機能しているかテストを行うこと
   - クラスや構造体といった内部の作りに対して、開発者が意図した通りに実装が行えるかテストする形になる
 
 - グレーボックステスト
   - ブラックボックスとホワイトボックスの中間と言えるもの
   - 外側から要求仕様を満たしているかをテストするかつ内部構造を部分的に把握し、必要に応じて操作する
   - 画面上からアプリのテストを行いつつも、通信処理が完了するまでの待機については内部的に行うといった方法が考えられる、

 
 ユニットテストにおいては一般的にホワイトボックスが利用される
 内部的な処理の構造（制御フローなど）に着目してテストをすることで網羅的なテストが行える
 
 
 アサーションの考え方
 
 テストでは、ある「状態」に対して、特定の操作を行い、その「結果」をアサーションで検証するのが一般的
 
 「状態」- テスト対象のオブジェクトの状態や環境を意味するもの
 「操作」- テスト対象の関数やメソッドを呼び出すことに相当する
 「結果」- 関数の戻り値やオブジェクトの状態の変化
 
  「操作」によって発生したそれらの「結果」について、期待した通りになっているか検証するのが、ユニットテストの基本となる
 
 */

// SampleCode
struct Counter {
    var count: Int
    mutating func increment() -> Int {
        count += 1
        return count
    }
}

/*
 上記のように３つのフェーズに分けて考える方法はAAAパターンという名前がつけられている
 (Arrange Act and Assert)
 
 Arrenge （状態をセットアップ）し, Act（操作）し, Assert（検証）する
 
 後片付け（クリーンアップ）が必要な場合もある
 グローバルなデータベースに変化を与えるテストを行った場合、テストが終わったタイミングで対象のデータベースを削除する必要がある場合とか
 （Realmに書き込んだりするテストとかの場合）
 
 片付けも考慮されたテストのことを
 Four-Phase Test　という
 「setup」「exercise」「verify」「teardown」
 
 // setup
 var counter = Counter(count: 0)
 // exercise
 let result = counter.increment()
 // verify
 XCTAssertEqual(result, 1) XCTAssertEqual(counter.count, 1)
 // teardown
 // (必要であれば後片付け)
 
 
 // 境界値は結構あるので注意する
 13 歳以上の判定の場合、正しい判定条件は age >= 13 、誤って age > 13 とするとバグになってしまう
 
 こういった条件式の間違いや、植木算エラーといった単純なプログラミングミスを検出する上で、境界値をテストすることはとても有効
 
 植木算エラーとは
 境目の数と区画の数を混同することによるバグ。
 「10 メートル間隔で 100 メートルまで植木を植える場合に植木は何本必要か?」
 という問いに対する直感的な答えは 10 だが、実際には両端に植木が必要なので 11 が正解
 
 
 テストコードの保守性を高める
 
 - テストケース名をわかりやすくする
 - テストを適切な粒度に保つ
 - テストの構造をわかりやすくする
 - 失敗時のエラーメッセージをわかりやすくする
 
 
 テスト名をわかりやすくするには
 test_<テスト対象メソッド>_<テストの説明>という形式が良い
 起動させるだけなので、むしろ日本語の方が良さそう
 
 テストを適切な粒度に保つには
 何がしたいかをはっきりする
 開発するときと同じで、長いメソッドにしない
 テストするスコープを分割して細かにしていくのが良さそう
 
 一つのテストでは一つの観点に対してのテストをするのが大切
 そうすることで特定のテストが失敗した場合に、どの観点のテストが失敗したかすぐに判断できる
 
 テストの構造をわかりやすくする
 インスタンスをいろんなところで生成するのではなく一つにまとめると良い
 
 // テストフィクスチャのセットアップをまとめる
 let rot13 = Rot(by: 13)
 let rot1 = Rot(by: 1)
 func testEncode_指定した数だけ文字がローテートされること() {
     XCTAssertEqual(rot13.encode("HELLO"), "URYYB")
     XCTAssertEqual(rot13.encode("URYYB"), "HELLO")
     XCTAssertEqual(rot13.encode("Hello"), "Uryyb")
     XCTAssertEqual(rot1.encode("HELLO"), "IFMMP")
 }
 func testEncode_アルファベット以外が含まれていた場合はnilになること() {
     XCTAssertNil(rot13.encode("Hello!"))
 }
 func testEncode_空文字列の場合は空になること() {
     XCTAssertEqual(rot13.encode(""), "")
 }


 フレームワークによっては、グルーピングできる
 
 // テストの性質ごとにグルーピングした内容
 func testEncode_指定した数だけ文字がローテートされること() {
     XCTContext.runActivity(named: "13文字ローテート") { _ in
         XCTContext.runActivity(named: "大文字のみ") { _ in
             XCTAssertEqual(rot13.encode("HELLO"), "URYYB")
             XCTAssertEqual(rot13.encode("URYYB"), "HELLO")
         }
         
         XCTContext.runActivity(named: "小文字を含む") { _ in
             XCTAssertEqual(rot13.encode("Hello"), "Uryyb") }
     }
     
     XCTContext.runActivity(named: "1文字ローテート") { _ in
         XCTAssertEqual(rot1.encode("HELLO"), "IFMMP") }
 }

 
 失敗時のエラーメッセージをわかりやすくする
 
 メッセージを追加できる
 func testEncode_アルファベット以外が含まれていた場合はnilになること() {
     XCTAssertNil(rot13.encode("Hello!"), "文字列`Hello!`には記号である!が含まれているので結果がnilになること")
 }
 
 
 テストダブルで依存コンポーネントを差し替える
 2,4,1から
 
 
 
 */




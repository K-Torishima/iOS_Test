//
//  SampleTest.swift
//  iOS_TestTests
//
//  Created by 鳥嶋 晃次 on 2021/10/04.
//


func validate(password: String) -> Bool {
    // ７も含む７以下ならfalse
    if password.count <= 7 {
        return false
    }
    
    // 数字が2文字を含む　８以上ならtrue
    let numString = password.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    return numString.count >= 2
}

import XCTest

// テストの境界線を書いてみると何がテスト対象なのかがわかる
// 重要なのは境界値でちゃんと切り分けて、テストケースが作れるか
// それを整理してCodeにかけるかが重要


class SampleTest: XCTestCase {
    
    // 8文字以上であること
    func test_数字が2文字含まれており_合計7文字入力された場合にfalseが返されること() {
        XCTAssertFalse(validate(password: "1234567"))
    }
    
    func test_数字が2文字含まれており_合計8文字入力された場合にtrueが返され得ること() {
        XCTAssertTrue(validate(password: "12345678"))
    }
    
    func test_数字が2文字含まれており_合計9文字入力された場合にtrueが返されること() {
        XCTAssertTrue(validate(password: "aaaaaaa12"))
    }
    
    // 数値に文字以上利用されること
    func test_数字以外が7文字と＿数字が1文字入力された場合にfalseが返されること() {
        XCTAssertFalse(validate(password: "abcdefg1"))
    }
    
    func test_数字以外を7文字と_数字が2文字入力された場合にtrueが返されること() {
        XCTAssertTrue(validate(password: "abcdefg12"))
    }
    
    func test_数字以外を7文字と_数字が3文字入力された場合にtrueが返されること() {
        XCTAssertTrue(validate(password: "abcdefg123"))
    }
    
    
    /* アサーションメソッド一覧
     XCTAssert(exp:)                         XCTAssertTrueと同じ
     XCTAssertTrue(exp:)                     trueであれば成功
     XCTAssertFalse(exp:)                    falseであれば成功
     XCTAssertNil(exp:)                      nilであれば成功
     XCTAssertNotNil(exp:)                   nilでなければ成功
     XCTAssertEqual(exp1:exp2:)              等しければテスト成功
     XCTAssertNotEqual(exp1:exp2:)           等しくなければテスト成功
     XCTAssertGreaterThan(exp1:exp2:)        １が２より大きければ成功
     XCTAssertGreaterThanOrEqual(exp1:exp2:) １が２以上であれば成功
     XCTAssertLessThan(exp1:exp2:)           １が２より小さければ成功
     XCTAssertLessThanOrEqual(exp1:exp2:)    １が２以下であれば成功
     XCTFail()　                              テストを失敗させる
     XCTAssertThrowsError(exp:)               例外をスローすればテスト成功
     XCTAssertNoThrowError(exp:)              例外をスローしなければテスト成功
     
     Errorメッセージは拡張できるので、そこは色々やっていくと良い
     3ヶ月後の自分は他人とよく言われるので、アサーションのメッセージや、コメント、テスト実装におけるメソッドの分け方に関しては
     付属できるものに関しては付属する
     ＊　安易にコメントを残すとよくわからなくなるので、そこは注意する
     
     */
    
    
    /*
     
     テストを構造化する
     XCContextというクラスを用いることでテストを構造化できる
     XCTContextはテストメソッドのサブステップとして扱うことができる
     テストレポートにも結果が表示される
     
     
     
     
     
     
     */
}


// テストレポート確認方法
// https://zenn.dev/yorifuji/articles/xcode-test-report

class PasswordValidatorTests: XCTestCase {
    func test_パスワードバリデーションの文字数() {
        XCTContext.runActivity(named: "数字が2文字以上含まれる場合") { _ in
            
            XCTContext.runActivity(named: "合計7文字が入力された場合") { _ in
                XCTAssertFalse(validate(password: "abcde12"))
            }
            
            XCTContext.runActivity(named: "合計8文字が入力された場合") { _ in
                XCTAssertTrue(validate(password: "abcdef12"))
            }
            
            XCTContext.runActivity(named: "合計9文字が入力された場合") { _ in
                XCTAssertTrue(validate(password: "abcdefg12"))
            }
        }
    }
}

// 独自にアサーションメソッドが作れるがあまり良さそうではない気がするので基本的には作らない方針で行った方が良さそう。
// 以下の感じでアサーションメソッドをラップして使う
//func assertOnlyNumeric(string: String,
//                       file: StaticString = #file,
//                       line: UInt = #line) {
//    XCTAssertTrue(
//        string.isOnlyNumeric(), "\"\(string)\" is not only numeric.", file: file,
//        line: line)
//}


//　非同期処理テスト

// テスト対象コード
// 3秒の待機時間後、クロージャーによって固定の文字列が返却される非同期処理の関数
// global()を使って並列実行する非同期処理を生成している
func asyncString(comletion: ((String) -> ())?) {
    DispatchQueue.global().async {
        sleep(3)
        comletion?("文字列A")
    }
}


// 以下正しい非同期のテスト
/*
XCTest 非同期処理の待機時間を作るために XCTestExpectation というクラスを使う
作成した XCTestExpectation クラスのインスタンスを wait(for:timeout:) 関数の引数に渡して、
指定した秒数以内にそのインスタンスの fulfill() メソッドが呼び出されれば、
非同期処理 の待機の終了を表現できる
もしも指定した秒数以内に fulfill() メソッドが呼び出されない場合、そのテストは失敗する

*/

class AsyncTest: XCTestCase {
    func test_AsyncString() {
        // 非同期処理の待機と完了を表現するためのインスタンス
        let exp = XCTestExpectation(description: "Async String")
        
        
        asyncString { string in
            XCTAssertEqual(string, "文字列A")
            exp.fulfill() // 期待した処理が行われたとしてマークされる
        }
        
        // 待機を行うXCTestExpectationのインスタンスを指定する
        // timeoutで指定した5秒以内にexpのfulfillが呼び出されない場合、
        // このテストは失敗となる
        wait(for: [exp], timeout: 5.0)
    }
}

// 以下は間違った非同期テスト
// XCTestExpectation を利用せず、待機時間を作らなかった場合の間違った非同期処理のテスト
// 次のコードでもテストは通が、これは XCTest がテストメソッドの中でひとつも評価を 行なっていない場合でも、
// テストを成功させてしまう特徴を持つからであり、実際に適切な検証が 行われたわけではない。

class AsyncBadTests1: XCTestCase {
    func test_AsyncString() {
        asyncString { string in
            XCTAssertEqual(string, "文字列A")
        }
    }
}

// 以下は本来であれば、比較する値と期待する値が一致しないためテストが失敗するはずだが、
// そもそもアサーションが評価されていないため、テストが成功してしまう

class AsyncBadTests2: XCTestCase {
    func test_AsyncString() {
        asyncString { string in
            // テストが失敗することを期待しているが
            // アサーションが評価されないためテストが成功してしまう。
            XCTAssertEqual(string, "文字列B")
        }
    }
}

/*
 // 例外テストについて
 例外テストはエラーハンドリングのテストを行うときに使う
 どんなエラーが返却されるかはその後のロジックに関わるので
 どんなエラーが返却されたかを確認するホワイトボックスなテストが必要になる
 
 例外のテストには、XCTAssertThrowError(expression:T)というアサーションメソッドを利用する
 XCAssertThrowsError(expression:T)は、Error型を返却するクロージャを持ったインターフェースが用意されている
 Error型を受けたクロージャの変数を、期待しているError型にキャストしてXCAssertEqualで比較する
 */

enum OperationError: Error {
    case divisionByZero
}

// 0は割り算だと割れないので例外としてスローさせる
func divide(_ x: Int, by y: Int) throws -> Int {
    if y == 0 {
        throw OperationError.divisionByZero
    }
    
    return x / y
}

class ExceptionTests: XCTestCase {
    func test_divideWhenDivisionByZero() {
        XCTAssertThrowsError(try divide(10, by: 0)) { error in
            let error = error as? OperationError
            XCTAssertEqual(error, OperationError.divisionByZero)
        }
    }
}

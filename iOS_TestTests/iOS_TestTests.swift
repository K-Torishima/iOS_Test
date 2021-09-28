//
//  iOS_TestTests.swift
//  iOS_TestTests
//
//  Created by 鳥嶋 晃次 on 2021/09/28.
//

import XCTest

// ↓ これがないとテストしたいモジュールにアクセスできない
@testable import iOS_Test

class iOS_TestTests: XCTestCase {
    
    var user = User()
    
    override func setUpWithError() throws {
        print("setUp")
        // ここでインスタンスを書き換えたりできる、通る通らないがわかると良さそう
        user.age = 30
        // テストの開始時に最初に呼ばれる関数、テストケースを回すために必要な設定やインスタンスの生成などをここで行う
    }

    override func tearDownWithError() throws {
        print("tearDown")
        // テスト終了時に一度だけ呼ばれる関数

    }

    func testExample() throws {
        // テスト対象の関数
        // この関数一つに対してテストケースを一つ書く。
        // 第一引数と第二引数が等しいことを検査するためのテスト
        XCTAssertEqual(user.age, 30) // 等しいのでテスト通過
        // XCTAssertEqual(calculator.age, 20) // 等しくないのでテスト通過しない
        //　第一引数と第二引数が等しくないときに検査するためのテスト
        XCTAssertNotEqual(user.age, 20) // 等しくないためテスト通過
        // XCTAssertNotEqual(calculator.age, 30) // 等しいためテスト通過しない
        
        // test対象がtrueかどうか
        XCTAssertTrue(user.isMale)
        // 検査対象がFalseかどうか
        XCTAssertFalse(user.isFemale)
        // 検査対象がnilかどうか
        XCTAssertNil(user.catName)

    }

    func testPerformanceExample() throws {
        // パフォーマンス測定の関数
        self.measure {
            // 計算したい処理を記載
        }
    }

}

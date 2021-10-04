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
    
    
    
    
    
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

//
//  StubSample.swift
//  iOS_TestTests
//
//  Created by 鳥嶋 晃次 on 2021/10/12.
//

import XCTest

// スタブを使ってテスト対象の処理を制御するサンプルコード
// ログイン状態に応じてダイアログの表示、非表示を切り替える例になる

protocol AuthManagerProtocol {
    var isLoggedIn: Bool { get }
}

class StabAuthManager: AuthManagerProtocol {
    var isLoggedIn: Bool = false
}

class DialogManager {
    private let authManager: AuthManagerProtocol
    
    init(authManager: AuthManagerProtocol) {
        self.authManager = authManager
    }
    
    var shouldShowLoginDialog: Bool {
        return !authManager.isLoggedIn
    }
}

class DialogManagerTests: XCTestCase {
    
    func testShowLoginDialog_ログイン済み() {
        let stubAuthManager = StabAuthManager()
        stubAuthManager.isLoggedIn = true
        let dialogManager = DialogManager(authManager: stubAuthManager)
        XCTAssertFalse(dialogManager.shouldShowLoginDialog)
    }
    
    func testShowLoginDialog_未ログイン() {
        let stubAuthManager = StabAuthManager()
        stubAuthManager.isLoggedIn = false
        let dialogManager = DialogManager(authManager: stubAuthManager)
        XCTAssertTrue(dialogManager.shouldShowLoginDialog)
    }
}

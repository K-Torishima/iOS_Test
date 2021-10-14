//
//  Protocols.swift
//  iOS_Test
//
//  Created by 鳥嶋 晃次 on 2021/10/13.
//

import Foundation

// 以下のProtocolを使ってSpyをジェネレートしてみる
protocol SearchRepositoryPresenterInput: AnyObject {
    var numberOfRows: Int { get }
    var hasNext: Bool { get set }
    func viewDidLoad()
    func viewWillAppear()
    func nabigateViewController()
}

class presenter: SearchRepositoryPresenterInput {

    var invokedNumberOfRowsGetter = false
    var invokedNumberOfRowsGetterCount = 0
    var stubbedNumberOfRows: Int! = 0

    var numberOfRows: Int {
        invokedNumberOfRowsGetter = true
        invokedNumberOfRowsGetterCount += 1
        return stubbedNumberOfRows
    }

    var invokedHasNextSetter = false
    var invokedHasNextSetterCount = 0
    var invokedHasNext: Bool?
    var invokedHasNextList = [Bool]()
    var invokedHasNextGetter = false
    var invokedHasNextGetterCount = 0
    var stubbedHasNext: Bool! = false

    var hasNext: Bool {
        set {
            invokedHasNextSetter = true
            invokedHasNextSetterCount += 1
            invokedHasNext = newValue
            invokedHasNextList.append(newValue)
        }
        get {
            invokedHasNextGetter = true
            invokedHasNextGetterCount += 1
            return stubbedHasNext
        }
    }

    var invokedViewDidLoad = false
    var invokedViewDidLoadCount = 0

    func viewDidLoad() {
        invokedViewDidLoad = true
        invokedViewDidLoadCount += 1
    }

    var invokedViewWillAppear = false
    var invokedViewWillAppearCount = 0

    func viewWillAppear() {
        invokedViewWillAppear = true
        invokedViewWillAppearCount += 1
    }

    var invokedNabigateViewController = false
    var invokedNabigateViewControllerCount = 0

    func nabigateViewController() {
        invokedNabigateViewController = true
        invokedNabigateViewControllerCount += 1
    }
}

//
//  MockSample.swift
//  iOS_TestTests
//
//  Created by 鳥嶋 晃次 on 2021/10/12.
//

import XCTest

protocol LoggerProtocol {
    func sendLog(massage: String)
}

class MockLogger: LoggerProtocol {
    var invokedSendLog = false
    var invokedSendLogCount = 0
    var sendLogProperties: [String] = []

    func sendLog(massage: String) {
        invokedSendLog = true
        invokedSendLogCount += 1
        sendLogProperties.append(massage)
    }
}

class Calculator {
    private let logger: LoggerProtocol
    
    init(logger: LoggerProtocol) {
        self.logger = logger
    }
    
    private enum CalcAction {
        case add(Int)
        // ...
    }
    
    private var calcActions: [CalcAction] = []
    
    func add(num: Int) {
        calcActions.append(.add(num))
    }
    
    func calc() -> Int {
        logger.sendLog(massage: "start calc.")
        
        var total = 0
        
        calcActions.forEach {
            switch $0 {
            case .add(let num):
                logger.sendLog(massage: "Add \(num).")
                total += num
            }
        }
        
        logger.sendLog(massage: "Total is \(total).")
        logger.sendLog(massage: "Finish calc.")
        return total
    }
}

class CalculatorTests: XCTestCase {
    func testadd() {
        let mockLogger = MockLogger()
        let calulator = Calculator(logger: mockLogger)
        let expectedSendMessages = [
            "start calc.",
            "Add 1.",
            "Total is 1.",
            "Finish calc."
        ]
        
        calulator.add(num: 1)
        XCTAssertEqual(calulator.calc(), 1)
        
        XCTAssertTrue(mockLogger.invokedSendLog)
        XCTAssertEqual(mockLogger.invokedSendLogCount, 4)
        XCTAssertEqual(mockLogger.sendLogProperties, expectedSendMessages)
    }
}

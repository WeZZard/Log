//
//  LogTests.swift
//  LogTests
//
//  Created on 16/10/2018.
//

import XCTest


@testable
import Log


class LogTests: XCTestCase {
    func testLogWithSubsystemCategoryTypeDsoMessageArgs_doesNotThrow() {
        XCTAssertNoThrow(Log.log(category: "Any", message: ""))
    }
    
    func testLogWithSubsystemClassTypeDsoMessageArgs_doesNotThrow() {
        XCTAssertNoThrow(Log.log(class: NSObject.self, message: ""))
    }
    
    func testLogWithSubsystemObjectTypeDsoMessageArgs_doesNotThrow() {
        XCTAssertNoThrow(Log.log(object: NSObject(), message: ""))
    }
    
    func testLogWithPresetBehaviorTypeDsoMessageArgs_doesNotThrow() {
        XCTAssertNoThrow(Log.log(message: ""))
    }
}

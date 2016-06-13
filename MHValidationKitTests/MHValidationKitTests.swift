//
//  MHValidationKitTests.swift
//  MHValidationKitTests
//
//  Created by Milen Halachev on 6/13/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import XCTest
@testable import MHValidationKit

class MHValidationKitTests: XCTestCase {
    
    override func setUp() {
        
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        
        super.tearDown()
    }
    
    func testValidatorOperators() {
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssertEqual((AnyValidator<String>(result: true) || AnyValidator<String>(result: true)).validate(nil), true || true)
        XCTAssertEqual((AnyValidator<String>(result: true) || AnyValidator<String>(result: false)).validate(nil), true || false)
        XCTAssertEqual((AnyValidator<String>(result: false) || AnyValidator<String>(result: true)).validate(nil), false || true)
        XCTAssertEqual((AnyValidator<String>(result: false) || AnyValidator<String>(result: false)).validate(nil), false || false)
        
        XCTAssertEqual((AnyValidator<String>(result: true) && AnyValidator<String>(result: true)).validate(nil), true && true)
        XCTAssertEqual((AnyValidator<String>(result: true) && AnyValidator<String>(result: false)).validate(nil), true && false)
        XCTAssertEqual((AnyValidator<String>(result: false) && AnyValidator<String>(result: true)).validate(nil), false && true)
        XCTAssertEqual((AnyValidator<String>(result: false) && AnyValidator<String>(result: false)).validate(nil), false && false)
    }
}

extension AnyValidator {
    
    public init(@autoclosure(escaping) value: () -> Bool) {
        
        self.init { _ -> Bool in
            
            return value()
        }
    }
}

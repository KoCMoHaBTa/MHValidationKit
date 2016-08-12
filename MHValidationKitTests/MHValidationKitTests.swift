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
        
        XCTAssertEqual((AnyValidator<String>(result: true) || AnyValidator<String>(result: true)).validate(nil).boolValue, true || true)
        XCTAssertEqual((AnyValidator<String>(result: true) || AnyValidator<String>(result: false)).validate(nil).boolValue, true || false)
        XCTAssertEqual((AnyValidator<String>(result: false) || AnyValidator<String>(result: true)).validate(nil).boolValue, false || true)
        XCTAssertEqual((AnyValidator<String>(result: false) || AnyValidator<String>(result: false)).validate(nil).boolValue, false || false)
        
        XCTAssertEqual((AnyValidator<String>(result: true) && AnyValidator<String>(result: true)).validate(nil).boolValue, true && true)
        XCTAssertEqual((AnyValidator<String>(result: true) && AnyValidator<String>(result: false)).validate(nil).boolValue, true && false)
        XCTAssertEqual((AnyValidator<String>(result: false) && AnyValidator<String>(result: true)).validate(nil).boolValue, false && true)
        XCTAssertEqual((AnyValidator<String>(result: false) && AnyValidator<String>(result: false)).validate(nil).boolValue, false && false)
    }
    
    func testSinglePairORValidatorMessages() {

        //MARK: true || true -> A
        XCTAssertEqual(
        (
            AnyValidator<Void>(result: ValidationResult(valid: true, messages: ["A"]))
         || AnyValidator<Void>(result: ValidationResult(valid: true, messages: ["B"]))
        )
         .validate(nil).messages, ["A"])
        
        //MARK: false || false -> B
        XCTAssertEqual(
        (
            AnyValidator<Void>(result: ValidationResult(valid: false, messages: ["A"]))
         || AnyValidator<Void>(result: ValidationResult(valid: false, messages: ["B"]))
        )
         .validate(nil).messages, ["B"])
        
        //MARK: true || false -> A
        XCTAssertEqual(
        (
            AnyValidator<Void>(result: ValidationResult(valid: true, messages: ["A"]))
         || AnyValidator<Void>(result: ValidationResult(valid: false, messages: ["B"]))
        )
         .validate(nil).messages, ["A"])
        
        //MARK: false || true -> B
        XCTAssertEqual(
        (
            AnyValidator<Void>(result: ValidationResult(valid: false, messages: ["A"]))
         || AnyValidator<Void>(result: ValidationResult(valid: true, messages: ["B"]))
        )
         .validate(nil).messages, ["B"])
    }
    
    func testSinglePairANDValidatorMessages() {

        //MARK: true && true -> B
        XCTAssertEqual(
        (
            AnyValidator<Void>(result: ValidationResult(valid: true, messages: ["A"]))
         && AnyValidator<Void>(result: ValidationResult(valid: true, messages: ["B"]))
        )
         .validate(nil).messages, ["B"])
        
        //MARK: false && false -> A
        XCTAssertEqual(
        (
            AnyValidator<Void>(result: ValidationResult(valid: false, messages: ["A"]))
         && AnyValidator<Void>(result: ValidationResult(valid: false, messages: ["B"]))
        )
         .validate(nil).messages, ["A"])
        
        //MARK: true && false -> B
        XCTAssertEqual(
        (
            AnyValidator<Void>(result: ValidationResult(valid: true, messages: ["A"]))
         && AnyValidator<Void>(result: ValidationResult(valid: false, messages: ["B"]))
        )
         .validate(nil).messages, ["B"])
        
        //MARK: false && true -> A
        XCTAssertEqual(
        (
            AnyValidator<Void>(result: ValidationResult(valid: false, messages: ["A"]))
         && AnyValidator<Void>(result: ValidationResult(valid: true, messages: ["B"]))
        )
         .validate(nil).messages, ["A"])
    }
}
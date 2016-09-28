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
    
    func testValidatorMessagesExample() {
        
        let passwordValidator = EmptyStringValidator()
            && StringLengthValidator(8) && PasswordCharactersValidator() && AnyValidator(validator: { (value) -> ValidationResult in
                
                if value?.lowercased().contains("milen") == true {
                    
                    return ValidationResult(valid: false, messages: ["Your password cannot be the same as your username"])
                }
                
                return true
            })
            && AnyValidator(result: ValidationResult(valid: true, messages: ["Valid Password"]))
        
        
        XCTAssertFalse(passwordValidator.validate("").boolValue)
        XCTAssertEqual(passwordValidator.validate("").messages.last, EmptyStringValidator.invalidMessage)
        
        XCTAssertFalse(passwordValidator.validate("  ").boolValue)
        XCTAssertEqual(passwordValidator.validate("  ").messages.last, EmptyStringValidator.invalidMessage)
        
        XCTAssertFalse(passwordValidator.validate("milen").boolValue)
        XCTAssertEqual(passwordValidator.validate("milen").messages.last, StringLengthValidator.invalidMessage(8))
        
        XCTAssertFalse(passwordValidator.validate("Milen123").boolValue)
        XCTAssertEqual(passwordValidator.validate("Milen123").messages.last, "Your password cannot be the same as your username")
        
        XCTAssertFalse(passwordValidator.validate("MilenABC").boolValue)
        XCTAssertEqual(passwordValidator.validate("MilenABC").messages.last, PasswordCharactersValidator.invalidMessageNumbers)
        
        XCTAssertFalse(passwordValidator.validate("manqcheto").boolValue)
        XCTAssertEqual(passwordValidator.validate("manqcheto").messages, [PasswordCharactersValidator.invalidMessageUpperCase, PasswordCharactersValidator.invalidMessageNumbers])
        
        XCTAssertTrue(passwordValidator.validate("QQbrbDQ9B7ENpy").boolValue)
        XCTAssertEqual(passwordValidator.validate("QQbrbDQ9B7ENpy").messages, ["Valid Password"])
    }
    
    func testValidatorStyling() {
        
        let textField = UITextField.Testable.create()
        
        let _ = textField.validate(using: AnyValidator(result: true))
        XCTAssertEqual(textField.backgroundColor, UITextField.Testable.validBackgroundColor)
        
        let _ = textField.validate(using: AnyValidator(result: false))
        XCTAssertEqual(textField.backgroundColor, UITextField.Testable.invalidBackgroundColor)
    }
    
    func testValidatableCollection_evaluateAll_false() {
        
        let data = [
            
            UITextField.Testable.create("123456"),
            UITextField.Testable.create("1234"),
            UITextField.Testable.create("1234a"),
            UITextField.Testable.create("1234ab"),
            UITextField.Testable.create("12345"),
            UITextField.Testable.create("123")
        ]
        
        let result = data.validate(using: StringLengthValidator(5) && NumericStringValidator(), evaluateAll: false)
        
        XCTAssertFalse(result.boolValue)
        XCTAssertEqual(result.messages.count, 1)
        
        XCTAssertEqual(data[0].backgroundColor, UITextField.Testable.validBackgroundColor)
        XCTAssertEqual(data[1].backgroundColor, UITextField.Testable.invalidBackgroundColor)
        XCTAssertNil(data[2].backgroundColor)
        XCTAssertNil(data[3].backgroundColor)
        XCTAssertNil(data[4].backgroundColor)
        XCTAssertNil(data[5].backgroundColor)
    }
    
    func testValidatableCollection_evaluateAll_true() {
        
        let data = [
            
            UITextField.Testable.create("123456"),
            UITextField.Testable.create("1234"),
            UITextField.Testable.create("1234a"),
            UITextField.Testable.create("1234ab"),
            UITextField.Testable.create("12345"),
            UITextField.Testable.create("123c")
        ]
        
        let result = data.validate(using: StringLengthValidator(5) && NumericStringValidator(), evaluateAll: true)
        
        XCTAssertFalse(result.boolValue)
        XCTAssertEqual(result.messages.count, 4)
        XCTAssertEqual(result.messages, [StringLengthValidator.invalidMessage(5), NumericStringValidator.invalidMessage, NumericStringValidator.invalidMessage, StringLengthValidator.invalidMessage(5)])
        
        XCTAssertEqual(data[0].backgroundColor, UITextField.Testable.validBackgroundColor)
        XCTAssertEqual(data[1].backgroundColor, UITextField.Testable.invalidBackgroundColor)
        XCTAssertEqual(data[2].backgroundColor, UITextField.Testable.invalidBackgroundColor)
        XCTAssertEqual(data[3].backgroundColor, UITextField.Testable.invalidBackgroundColor)
        XCTAssertEqual(data[4].backgroundColor, UITextField.Testable.validBackgroundColor)
        XCTAssertEqual(data[5].backgroundColor, UITextField.Testable.invalidBackgroundColor)
    }
    
    func testValidatableCollection_evaluateAll_true_reverse() {
        
        let data = [
            
            UITextField.Testable.create("123456"),
            UITextField.Testable.create("1234"),
            UITextField.Testable.create("1234a"),
            UITextField.Testable.create("1234ab"),
            UITextField.Testable.create("12345"),
            UITextField.Testable.create("123c")
        ]
        
        let result = data.validate(using: NumericStringValidator() && StringLengthValidator(5), evaluateAll: true)
        
        XCTAssertFalse(result.boolValue)
        XCTAssertEqual(result.messages.count, 4)
        XCTAssertEqual(result.messages, [StringLengthValidator.invalidMessage(5), NumericStringValidator.invalidMessage, NumericStringValidator.invalidMessage, NumericStringValidator.invalidMessage])
        
        XCTAssertEqual(data[0].backgroundColor, UITextField.Testable.validBackgroundColor)
        XCTAssertEqual(data[1].backgroundColor, UITextField.Testable.invalidBackgroundColor)
        XCTAssertEqual(data[2].backgroundColor, UITextField.Testable.invalidBackgroundColor)
        XCTAssertEqual(data[3].backgroundColor, UITextField.Testable.invalidBackgroundColor)
        XCTAssertEqual(data[4].backgroundColor, UITextField.Testable.validBackgroundColor)
        XCTAssertEqual(data[5].backgroundColor, UITextField.Testable.invalidBackgroundColor)
    }
    
    func testValidatableValidatorContainerCollection_evaluateAll_false() {
        
        let data = [
            
            NumericTextField.Testable.create("asd123"),
            NumericTextField.Testable.create("123"),
            NumericTextField.Testable.create("asd123")
        ]
        
        let result = data.validate(byEvaluatingAll: false)
        
        XCTAssertFalse(result.boolValue)
        XCTAssertEqual(result.messages.count, 1)
        
        XCTAssertEqual(data[0].backgroundColor, UITextField.Testable.invalidBackgroundColor)
        XCTAssertNil(data[1].backgroundColor)
        XCTAssertNil(data[2].backgroundColor)
    }
    
    func testValidatableValidatorContainerCollection_evaluateAll_true() {
        
        let data = [
            
            NumericTextField.Testable.create("asd123"),
            NumericTextField.Testable.create("123"),
            NumericTextField.Testable.create("asd123")
        ]
        
        let result = data.validate(byEvaluatingAll: true)
        
        XCTAssertFalse(result.boolValue)
        XCTAssertEqual(result.messages.count, 2)
        
        XCTAssertEqual(data[0].backgroundColor, UITextField.Testable.invalidBackgroundColor)
        XCTAssertEqual(data[1].backgroundColor, UITextField.Testable.validBackgroundColor)
        XCTAssertEqual(data[2].backgroundColor, UITextField.Testable.invalidBackgroundColor)
    }
    
    func testValidatorStylerReferences() {
        
        let button = UIButton()
        let view = UIView()
        let label = UILabel()
        
        button.validatorStyler = ValidatorStyler(styler: { (target, valid) in
            
            XCTAssertTrue(target === button)
            XCTAssertTrue(valid.boolValue)
        })
        
        view.validatorStyler = ValidatorStyler(styler: { (target, valid) in
            
            XCTAssertTrue(target === view)
            XCTAssertFalse(valid.boolValue)
        })
        
        label.validatorStyler = ValidatorStyler(styler: { (target, valid) in
            
            XCTAssertTrue(target === label)
            XCTAssertTrue(valid.boolValue)
        })
        
        XCTAssertNotNil(button.validatorStyler)
        XCTAssertNotNil(view.validatorStyler)
        XCTAssertNotNil(label.validatorStyler)
        
        button.validatorStyler?.style(button, for: true)
        view.validatorStyler?.style(view, for: false)
        label.validatorStyler?.style(label, for: true)
    }
}




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
                
                if value?.lowercaseString.containsString("milen") == true {
                    
                    return ValidationResult(valid: false, messages: ["Your password cannot be the same as your username"])
                }
                
                return true
            })
            && AnyValidator(result: ValidationResult(valid: true, messages: ["Valid Password"]))
        
        
        XCTAssertFalse(passwordValidator.validate(""))
        XCTAssertEqual(passwordValidator.validate("").messages.last, EmptyStringValidator.invalidMessage)
        
        XCTAssertFalse(passwordValidator.validate("  "))
        XCTAssertEqual(passwordValidator.validate("  ").messages.last, EmptyStringValidator.invalidMessage)
        
        XCTAssertFalse(passwordValidator.validate("milen"))
        XCTAssertEqual(passwordValidator.validate("milen").messages.last, StringLengthValidator.invalidMessage(8))
        
        XCTAssertFalse(passwordValidator.validate("Milen123"))
        XCTAssertEqual(passwordValidator.validate("Milen123").messages.last, "Your password cannot be the same as your username")
        
        XCTAssertFalse(passwordValidator.validate("MilenABC"))
        XCTAssertEqual(passwordValidator.validate("MilenABC").messages.last, PasswordCharactersValidator.invalidMessageNumbers)
        
        XCTAssertFalse(passwordValidator.validate("manqcheto"))
        XCTAssertEqual(passwordValidator.validate("manqcheto").messages, [PasswordCharactersValidator.invalidMessageUpperCase, PasswordCharactersValidator.invalidMessageNumbers])
        
        XCTAssertTrue(passwordValidator.validate("QQbrbDQ9B7ENpy"))
        XCTAssertEqual(passwordValidator.validate("QQbrbDQ9B7ENpy").messages, ["Valid Password"])
    }
    
    func testValidatorStyling() {
        
        let textField = UITextField.Testable.create()
        
        textField.validate(AnyValidator(result: true))
        XCTAssertEqual(textField.backgroundColor, UITextField.Testable.validBackgroundColor)
        
        textField.validate(AnyValidator(result: false))
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
        
        let result = data.validate(StringLengthValidator(5) && NumericStringValidator(), evaluateAll: false)
        
        XCTAssertFalse(result)
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
        
        let result = data.validate(StringLengthValidator(5) && NumericStringValidator(), evaluateAll: true)
        
        XCTAssertFalse(result)
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
        
        let result = data.validate(NumericStringValidator() && StringLengthValidator(5), evaluateAll: true)
        
        XCTAssertFalse(result)
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
        
        let result = data.validate(false)
        
        XCTAssertFalse(result)
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
        
        let result = data.validate(true)
        
        XCTAssertFalse(result)
        XCTAssertEqual(result.messages.count, 2)
        
        XCTAssertEqual(data[0].backgroundColor, UITextField.Testable.invalidBackgroundColor)
        XCTAssertEqual(data[1].backgroundColor, UITextField.Testable.validBackgroundColor)
        XCTAssertEqual(data[2].backgroundColor, UITextField.Testable.invalidBackgroundColor)
    }
}



//do tuka dobre - iskame da mojem da pokazvame i razli4en tekst v zavisimost ot tova koi validator e fail-nal ili successnal
//toes osven dali e valid - trqq znaem koi to4no e - da imame nqkaf feedback vuv ValidatorStylable
//
//su6to taka iskame toq validatorStyler da e more generic za vsqkvi elementi
//trqq kato kompozirame nqkolko validatora - da znaem koi to4no e fail-nal


extension UITextField: ValueContainer, Validatable, ValidatorStylable {
    
    public var value: String? {
        
        return self.text
    }
    
    private static var validatorStylerKey = ""
    public var validatorStyler: ValidatorStyler<UITextField>? {
        
        get {
            
            return objc_getAssociatedObject(self, &self.dynamicType.validatorStylerKey) as? ValidatorStyler<UITextField>
        }
        
        set {
            
            objc_setAssociatedObject(self, &self.dynamicType.validatorStylerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func updateValidationStyle(result: ValidationResult) {
        
        self.validatorStyler?.style(self, valid: result.boolValue)
    }
}

class NumericTextField: UITextField, ValidatorContainer {
    
    var validator: AnyValidator<String> {
     
        return AnyValidator(validator: NumericStringValidator())
    }
}

extension UITextField {
    
    struct Testable {
        
        static func create(text: String? = nil) -> UITextField {
        
            let textField = UITextField()
            
            textField.text = text
            textField.validatorStyler = validatorStyler
            textField.backgroundColor = nil
            
            
            return textField
        }
        
        static var validatorStyler = ValidatorStyler<UITextField>(styler: { (target, valid) in
            
            target.backgroundColor = valid ? UIColor.greenColor() : UIColor.redColor()
        })
        
        static var validBackgroundColor = UIColor.greenColor()
        static var invalidBackgroundColor = UIColor.redColor()
    }
}

extension NumericTextField {
    
    struct Testable {
    
        static func create(text: String? = nil) -> NumericTextField {
            
            let textField = NumericTextField()
            
            textField.text = text
            textField.validatorStyler = validatorStyler
            textField.backgroundColor = nil
            
            
            return textField
        }
        
        static var validatorStyler = ValidatorStyler<UITextField>(styler: { (target, valid) in
            
            target.backgroundColor = valid ? UIColor.greenColor() : UIColor.redColor()
        })
        
        static var validBackgroundColor = UIColor.greenColor()
        static var invalidBackgroundColor = UIColor.redColor()
    }
}

public class ValidatorStyler<T> {
    
    public typealias Styler = (target: T, valid: Bool) -> Void
    
    private let _styler: Styler
    
    public init(styler: Styler) {
        
        _styler = styler
    }
    
    public func style(target: T, valid: Bool) {
        
        _styler(target: target, valid: valid)
    }
}

///validate if input string is not empty
struct EmptyStringValidator: Validator {
    
    static let invalidMessage = "The input must not be empty"
    
    func validate(value: String?) -> ValidationResult {
        
        let valid = value?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).isEmpty == false
        let messages = valid ? [] : [self.dynamicType.invalidMessage]
        return ValidationResult(valid: valid, messages: messages)
    }
}

///validate if input string meets minimum char length
struct StringLengthValidator: Validator {
    
    static func invalidMessage(lenght: Int) -> String {
        
        return "The input must be at least \(lenght) characters long"
    }
    
    let lenght: Int
    
    init(_ lenght: Int) {
        
        self.lenght = lenght
    }
    
    func validate(value: String?) -> ValidationResult {
        
        let valid = value?.utf8.count >= self.lenght
        let messages = valid ? [] : [self.dynamicType.invalidMessage(self.lenght)]
        return ValidationResult(valid: valid, messages: messages)
    }
}

///validates if input string meet some password requirements
struct PasswordCharactersValidator: Validator {
    
    static let invalidMessageLowerCase = "The password must contains lower case letters"
    static let invalidMessageUpperCase = "The password must contains capital letters"
    static let invalidMessageNumbers = "The password must contains numbers"
    
    func validate(value: String?) -> ValidationResult {
        
        var valid = true
        var messages = [String]()
        
        if value?.rangeOfCharacterFromSet(NSCharacterSet.lowercaseLetterCharacterSet()) == nil {
            
            valid = false
            messages.append(self.dynamicType.invalidMessageLowerCase)
        }
        
        if value?.rangeOfCharacterFromSet(NSCharacterSet.uppercaseLetterCharacterSet()) == nil {
            
            valid = false
            messages.append(self.dynamicType.invalidMessageUpperCase)
        }
        
        if value?.rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet()) == nil {
            
            valid = false
            messages.append(self.dynamicType.invalidMessageNumbers)
        }
        
        return ValidationResult(valid: valid, messages: messages)
    }
}

///validate if input string contains a substring
struct SubstringValidator: Validator {
    
    let substring: String
    
    init(_ substring: String) {
        
        self.substring = substring
    }
    
    func validate(value: String?) -> ValidationResult {
        
        let valid = value?.containsString(self.substring) == true
        return ValidationResult(valid: valid)
    }
}

///Validate if input string is numeric only
struct NumericStringValidator: Validator {
    
    static let invalidMessage = "The input must contains only numbers"
    
    func validate(value: String?) -> ValidationResult {
        
        let valid = value?.rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet) == nil
        let messages = valid ? [] : [self.dynamicType.invalidMessage]
        return ValidationResult(valid: valid, messages: messages)
    }
}

//
//  Samples.swift
//  MHValidationKit
//
//  Created by Milen Halachev on 8/15/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation
import MHValidationKit


extension UITextField: ValueContainer, Validatable, ValidatorStylable {
    
    public typealias Value = String
    
    public var value: String? {
        
        return self.text
    }
}

extension UIView: ValidatorStylable {
    
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
            textField.validatorStyler = ValidatorStyler(styler: { (target, valid) in
                
                target.backgroundColor = valid ? UIColor.greenColor() : UIColor.redColor()
            })
            
            textField.backgroundColor = nil
            
            
            return textField
        }
        
        static var validBackgroundColor = UIColor.greenColor()
        static var invalidBackgroundColor = UIColor.redColor()
    }
}

extension NumericTextField {
    
    struct Testable {
        
        static func create(text: String? = nil) -> NumericTextField {
            
            let textField = NumericTextField()
            
            textField.text = text
            textField.validatorStyler = ValidatorStyler(styler: { (target, valid) in
                
                target.backgroundColor = valid ? UIColor.greenColor() : UIColor.redColor()
            })
            textField.backgroundColor = nil
            
            
            return textField
        }
        
        static var validBackgroundColor = UIColor.greenColor()
        static var invalidBackgroundColor = UIColor.redColor()
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

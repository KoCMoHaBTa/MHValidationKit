//
//  Samples.swift
//  MHValidationKit
//
//  Created by Milen Halachev on 8/15/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation
import MHValidationKit

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


extension UIView: ValidatorStylable {
    
}

extension UITextField: ValueContainer, Validatable {
    
    public typealias Value = String
    
    public var value: String? {
        
        return self.text
    }
}

class NumericTextField: UITextField, ValidatorContainer {
    
    var validator: AnyValidator<String> {
        
        return AnyValidator(validator: NumericStringValidator())
    }
}

extension UITextField {
    
    struct Testable {
        
        static func create(_ text: String? = nil) -> UITextField {
            
            let textField = UITextField()
            
            textField.text = text
            textField.validatorStyler = ValidatorStyler(styler: { (target, valid) in
                
                target.backgroundColor = valid.boolValue ? UIColor.green : UIColor.red
            })
            
            textField.backgroundColor = nil
            
            
            return textField
        }
        
        static var validBackgroundColor = UIColor.green
        static var invalidBackgroundColor = UIColor.red
    }
}

extension NumericTextField {
    
    struct Testable {
        
        static func create(_ text: String? = nil) -> NumericTextField {
            
            let textField = NumericTextField()
            
            textField.text = text
            textField.validatorStyler = ValidatorStyler(styler: { (target, valid) in
                
                target.backgroundColor = valid.boolValue ? UIColor.green : UIColor.red
            })
            textField.backgroundColor = nil
            
            
            return textField
        }
        
        static var validBackgroundColor = UIColor.green
        static var invalidBackgroundColor = UIColor.red
    }
}



///validate if input string is not empty
struct EmptyStringValidator: Validator {
    
    static let invalidMessage = "The input must not be empty"
    
    func validate(_ value: String?) -> ValidationResult {
        
        let valid = value?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty == false
        let messages = valid ? [] : [type(of: self).invalidMessage]
        return ValidationResult(valid: valid, messages: messages)
    }
}

///validate if input string meets minimum char length
struct StringLengthValidator: Validator {
    
    static func invalidMessage(_ lenght: Int) -> String {
        
        return "The input must be at least \(lenght) characters long"
    }
    
    let lenght: Int
    
    init(_ lenght: Int) {
        
        self.lenght = lenght
    }
    
    func validate(_ value: String?) -> ValidationResult {
        
        let valid = value?.utf8.count >= self.lenght
        let messages = valid ? [] : [type(of: self).invalidMessage(self.lenght)]
        return ValidationResult(valid: valid, messages: messages)
    }
}

///validates if input string meet some password requirements
struct PasswordCharactersValidator: Validator {
    
    static let invalidMessageLowerCase = "The password must contains lower case letters"
    static let invalidMessageUpperCase = "The password must contains capital letters"
    static let invalidMessageNumbers = "The password must contains numbers"
    
    func validate(_ value: String?) -> ValidationResult {
        
        var valid = true
        var messages = [String]()
        
        if value?.rangeOfCharacter(from: CharacterSet.lowercaseLetters) == nil {
            
            valid = false
            messages.append(type(of: self).invalidMessageLowerCase)
        }
        
        if value?.rangeOfCharacter(from: CharacterSet.uppercaseLetters) == nil {
            
            valid = false
            messages.append(type(of: self).invalidMessageUpperCase)
        }
        
        if value?.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil {
            
            valid = false
            messages.append(type(of: self).invalidMessageNumbers)
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
    
    func validate(_ value: String?) -> ValidationResult {
        
        let valid = value?.contains(self.substring) == true
        return ValidationResult(valid: valid)
    }
}

///Validate if input string is numeric only
struct NumericStringValidator: Validator {
    
    static let invalidMessage = "The input must contains only numbers"
    
    func validate(_ value: String?) -> ValidationResult {
        
        let valid = value?.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        let messages = valid ? [] : [type(of: self).invalidMessage]
        return ValidationResult(valid: valid, messages: messages)
    }
}

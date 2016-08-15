//
//  CollectionType+Validatable.swift
//  MHValidationKit
//
//  Created by Milen Halachev on 6/13/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation

//mimic that a colloection of validatable elements is a validatable
extension CollectionType where Generator.Element: Validatable {
    
    /**
     
     Validates all emements in the receiver for a given validator.
     
     - parameter validator: The validator used to validate each element.
     - parameter evaluateAll: true to continue evaluation after false result. Default to false. Example usage - if elements are stylable - you can continue validation in order to show approiate style for all elements.
     - returns: true if all elements are valid.
     
     */
    
    func validate<V where V: Validator, V.Value == Generator.Element.Value>(validator: V, evaluateAll: Bool = false) -> ValidationResult {
        
        var boolValue = true
        var messages = [String]()
        
        self.forEach { (element) in
            
            let result = element.validate(validator)
            boolValue = boolValue && result
            messages = messages + result.messages
            
            //if result is false and there is not need to evaluate all - stop evaluating
            if !result && !evaluateAll {
                
                return
            }
        }
        
        let result = ValidationResult(valid: boolValue, messages: messages)
        return result
    }
}

extension CollectionType where Generator.Element: Validatable, Generator.Element: ValidatorContainer {
    
    /**
     
     Validates all emements in the receiver with their own validator.
     
     - parameter evaluateAll: true to continue evaluation after false result. Default to false. Example usage - if elements are stylable - you can continue validation in order to show approiate style for all elements.
     - returns: true if all elements are valid.
     
     */
    
    func validate(evaluateAll: Bool = false) -> ValidationResult {
        
        var boolValue = true
        var messages = [String]()
        
        self.forEach { (element) in
            
            let result = element.validate()
            boolValue = boolValue && result
            messages = messages + result.messages
            
            //if result is false and there is not need to evaluate all - stop evaluating
            if !result && !evaluateAll {
                
                return
            }
        }
        
        let result = ValidationResult(valid: boolValue, messages: messages)
        return result
    }
}

////evaluates an element with a validator with a given result
//private func evaluateElement<E, V where E: Validatable, V: Validator, V.Value == E.Value>(element: E, validator: V, inout result: ValidationResult) {
//    
//    
//}






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
    
    //true if all elements are valid
    func validate<V where V: Validator, V.Value == Generator.Element.Value>(validator: V, evaluateAll: Bool = false) -> Bool {
        
        var result = true
        
        for element in self {
            
            result = element.validate(validator) && result
            
            if evaluateAll && !result {
                
                break
            }
        }
        
        return result
    }
}

extension CollectionType where Generator.Element: Validatable, Generator.Element: ValidatorContainer {
    
    func validate(evaluateAll: Bool = false) -> Bool {
        
        var result = true
        
        for element in self {
            
            result = element.validate(element.validator) && result
            
            if evaluateAll && !result {
                
                break
            }
        }
        
        return result
    }
}

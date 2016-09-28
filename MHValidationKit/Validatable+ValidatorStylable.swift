//
//  Validatable+ValidatorStylable.swift
//  MHValidationKit
//
//  Created by Milen Halachev on 6/13/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation

extension Validatable where Self: ValueContainer, Self: ValidatorStylable {
    
    public func validate<V>(using validator: V) -> ValidationResult where V: Validator, V.Value == Value {
        
        let result = validator.validate(self.value)
        
        self.style(for: result)
        
        return result
    }
}

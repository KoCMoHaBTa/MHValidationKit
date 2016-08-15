//
//  Validatable+ValueContainer.swift
//  MHValidationKit
//
//  Created by Milen Halachev on 6/13/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation

extension Validatable where Self: ValueContainer {
    
    public func validate<V where V: Validator, V.Value == Value>(validator: V) -> ValidationResult {
        
        return validator.validate(self.value)
    }
}
//
//  Validatable+ValidatorContainer.swift
//  MHValidationKit
//
//  Created by Milen Halachev on 6/13/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation

extension Validatable where Self: ValidatorContainer {
    
    func validate() -> ValidationResult {
        
        return self.validate(self.validator)
    }
}
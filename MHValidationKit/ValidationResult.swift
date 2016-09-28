//
//  ValidationResult.swift
//  MHValidationKit
//
//  Created by Milen Halachev on 8/12/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation

public struct ValidationResult {
    
    public let valid: Bool
    public var messages: [String]
    
    public init(valid: Bool, messages: [String] = []) {
        
        self.valid = valid
        self.messages = messages
    }
}

//BooleanType protocol has dissapeared - but we still need this
extension ValidationResult {
    
    public var boolValue: Bool {
        
        return self.valid
    }
}

extension ValidationResult: ExpressibleByBooleanLiteral {
    
    public init(booleanLiteral value: Bool) {
        
        self.init(valid: value)
    }
}


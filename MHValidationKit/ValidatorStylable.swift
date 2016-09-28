//
//  ValidatorStylable.swift
//  MHValidationKit
//
//  Created by Milen Halachev on 6/13/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation

public protocol ValidatorStylable {
    
    associatedtype Target
    var validatorStyler: ValidatorStyler<Target>? { get }
    func style(for result: ValidationResult)
}

extension ValidatorStylable where Target == Self {
    
    public func style(for result: ValidationResult) {
        
        self.validatorStyler?.style(self, for: result)
    }
}


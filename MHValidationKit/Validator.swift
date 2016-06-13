//
//  Validator.swift
//  MHValidationKit
//
//  Created by Milen Halachev on 6/13/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation

public protocol Validator {
    
    associatedtype Value
    
    func validate(value: Value?) -> Bool
}

public struct AnyValidator<V>: Validator {
    
    private let _validate: (value: V?) -> Bool
    
    public init(validator: (value: V?) -> Bool) {
        
        _validate = validator
    }
    
    public init<T where T: Validator, T.Value == V>(validator: T) {
        
        self.init(validator: validator.validate)
    }
    
    public func validate(value: V?) -> Bool {
        
        return _validate(value: value)
    }
}

@warn_unused_result
public func ||<LV, RV where LV: Validator, RV: Validator, LV.Value == RV.Value>(lhs: LV, rhs: RV) -> AnyValidator<LV.Value> {
    
    return AnyValidator(validator: { (value) -> Bool in
        
        return lhs.validate(value) || rhs.validate(value)
    })
}

@warn_unused_result
public func &&<LV, RV where LV: Validator, RV: Validator, LV.Value == RV.Value>(lhs: LV, rhs: RV) -> AnyValidator<LV.Value> {
    
    return AnyValidator(validator: { (value) -> Bool in
        
        return lhs.validate(value) && rhs.validate(value)
    })
}
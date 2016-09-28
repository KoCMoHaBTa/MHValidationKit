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
    
    func validate(_ value: Value?) -> ValidationResult
}

public struct AnyValidator<V>: Validator {
    
    private let _validate: (_ value: V?) -> ValidationResult
    
    public init(validator: @escaping (_ value: V?) -> ValidationResult) {
        
        _validate = validator
    }
    
    public init( result: @autoclosure @escaping () -> ValidationResult) {
        
        self.init { _ -> ValidationResult in
            
            return result()
        }
    }
    
    public init<T>(validator: T) where T: Validator, T.Value == V {
        
        self.init(validator: validator.validate)
    }
    
    public func validate(_ value: V?) -> ValidationResult {
        
        return _validate(value)
    }
}

/// If `lhs` is `true`, return it.  Otherwise, evaluate `rhs` and
/// return its `boolValue`.

public func ||<LV, RV>(lhs: LV, rhs: RV) -> AnyValidator<LV.Value> where LV: Validator, RV: Validator, LV.Value == RV.Value {
    
    return AnyValidator(validator: { (value) -> ValidationResult in
        
        let lhsResult = lhs.validate(value)
        
        if lhsResult.boolValue == true {
            
            return lhsResult
        }
        
        return rhs.validate(value)
    })
}

/// If `lhs` is `false`, return it.  Otherwise, evaluate `rhs` and
/// return its `boolValue`.

public func &&<LV, RV>(lhs: LV, rhs: RV) -> AnyValidator<LV.Value> where LV: Validator, RV: Validator, LV.Value == RV.Value {
    
    return AnyValidator(validator: { (value) -> ValidationResult in
        
        let lhsResult = lhs.validate(value)
        
        if lhsResult.boolValue == false {
            
            return lhsResult
        }
        
        return rhs.validate(value)
    })
}





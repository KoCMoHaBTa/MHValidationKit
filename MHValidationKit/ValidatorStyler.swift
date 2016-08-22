//
//  ValidatorStyler.swift
//  MHValidationKit
//
//  Created by Milen Halachev on 8/22/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation

public class ValidatorStyler<T> {
    
    public typealias Styler = (target: T, result: ValidationResult) -> Void
    
    private let _styler: Styler
    
    public init(styler: Styler) {
        
        _styler = styler
    }
    
    public func style(target: T, result: ValidationResult) {
        
        _styler(target: target, result: result)
    }
}
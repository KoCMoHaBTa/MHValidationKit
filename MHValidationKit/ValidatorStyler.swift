//
//  ValidatorStyler.swift
//  MHValidationKit
//
//  Created by Milen Halachev on 8/22/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation

open class ValidatorStyler<T> {
    
    public typealias Styler = (_ target: T, _ result: ValidationResult) -> Void
    
    fileprivate let _styler: Styler
    
    public init(styler: @escaping Styler) {
        
        _styler = styler
    }
    
    open func style(_ target: T, for result: ValidationResult) {
        
        _styler(target, result)
    }
}

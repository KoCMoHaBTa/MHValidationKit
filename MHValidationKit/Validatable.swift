//
//  Validatable.swift
//  MHValidationKit
//
//  Created by Milen Halachev on 6/13/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation

public protocol Validatable {
    
    associatedtype Value
    
    func validate<V>(using validator: V) -> ValidationResult where V: Validator, V.Value == Value
}

//
//  ValidatorContainer.swift
//  MHValidationKit
//
//  Created by Milen Halachev on 6/13/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation

public protocol ValidatorContainer {
    
    associatedtype Value
    
    var validator: AnyValidator<Value> { get }
}
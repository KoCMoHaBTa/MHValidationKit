//
//  NSObjectProtocol+ValidatorStylable.swift
//  MHValidationKit
//
//  Created by Milen Halachev on 8/22/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation

private var validatorStylerKey = ""
extension NSObjectProtocol where Self: ValidatorStylable {
    
    public var validatorStyler: ValidatorStyler<Self>? {
        
        get {
            
            return objc_getAssociatedObject(self, &validatorStylerKey) as? ValidatorStyler<Self>
        }
        
        set {
            
            objc_setAssociatedObject(self, &validatorStylerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
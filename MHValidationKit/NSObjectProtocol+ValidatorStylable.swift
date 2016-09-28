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
        
        //hack around unsuccessfull type casting, eg ValidatorStyler<UITextField> to ValidatorStyler<UIView> and vice versa
        
        get {
            
            return ValidatorStyler<Self>(styler: { [unowned self] (target, result) in
                
                self._validatorStyler?.style(target, for: result)
            })
        }
        
        set {
            
            _validatorStyler = ValidatorStyler<Any>(styler: { (target, result) in
                
                if let target = target as? Self {
                    
                    newValue?.style(target, for: result)
                }
            })
        }
    }
    
    private var _validatorStyler: ValidatorStyler<Any>? {
        
        get {
            
            return objc_getAssociatedObject(self, &validatorStylerKey) as? ValidatorStyler<Any>
        }
        
        set {
            
            objc_setAssociatedObject(self, &validatorStylerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

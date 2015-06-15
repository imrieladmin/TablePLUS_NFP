//
//  ArrayExtensions.swift
//  TabletPLUS
//
//  Created by dhaval shah on 28/05/15.
//  Copyright (c) 2015 dhaval shah. All rights reserved.
//

import Foundation


extension Array {
    func indexOfObject(object : AnyObject) -> NSInteger {
        return (self as! NSArray).indexOfObject(object)
    }
    
    mutating func removeObject(object : AnyObject) {
        for var index = self.indexOfObject(object); index != NSNotFound; index = self.indexOfObject(object) {
            self.removeAtIndex(index)
        }
    }
}
 
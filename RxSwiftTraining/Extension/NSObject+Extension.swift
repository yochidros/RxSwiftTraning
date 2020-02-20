//
//  NSObject+Extension.swift
//  RxSwiftTraining
//
//  Created by yochidros on 2020/02/20.
//  Copyright © 2020 yochidros. All rights reserved.
//

import Foundation

protocol ClassName {
    static var className: String { get }
    var className: String { get }
}

extension ClassName {
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassName {}

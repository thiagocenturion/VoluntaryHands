//
//  Sequence+Extensions.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 12/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation

extension Sequence where Element == Bool {
    typealias LogicalOperator = ((Bool, @autoclosure () throws -> Bool) throws -> Bool)

    func reduce(_ combine: LogicalOperator) -> Bool {
        var started = false
        
        return self.reduce(into: true) { result, value in
            result = started ? try! combine(result, value) : value
            started = true
        }
    }
}

//
//  Binding+.swift
//  
//
//  Created by 윤범태 on 2023/03/25.
//

import SwiftUI

extension Binding {
    /// Execute block when value is changed.
    /// https://stackoverflow.com/questions/59379132/swiftui-call-function-on-variable-change
    /// Example:
    ///
    ///     Slider(value: $amount.didSet { print($0) }, in: 0...10)
    func didSet(execute: @escaping (Value) ->Void) -> Binding {
        return Binding(
            get: {
                return self.wrappedValue
            },
            set: {
                self.wrappedValue = $0
                execute($0)
            }
        )
    }
}

//
//  StatefulPreviewWrapper.swift
//  Story One
//
//  Created by 윤범태 on 2023/03/25.
//

import SwiftUI

// https://developer.apple.com/forums/thread/118589
struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content

    var body: some View {
        content($value)
    }

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        self._value = State(wrappedValue: value)
        self.content = content
    }
}

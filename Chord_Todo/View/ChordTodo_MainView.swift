//
//  ChordTodo_MainView.swift
//  
//
//  Created by 윤범태 on 2023/03/24.
//

import SwiftUI

extension String {
    static let cfgTodoList = "TODO_LIST"
}

struct ChordTodo_MainView: View {
    @State var showWriterView = false
    @State var isListUpdated = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            HeaderView {
                showWriterView = true
            }.sheet(isPresented: $showWriterView, onDismiss: {
                print("list up: this")
                if isListUpdated {
                    print("List Updated")
                    isListUpdated = false
                } else {
                    print("List not updated")
                }
            }, content: {
                WriteView(isWriteSuccess: $isListUpdated)
            })
            Divider()
            
            // TODO: - 이거 없으면 뷰 업데이트가 안됨 -> 뷰 새로고침 방법?
            Text(isListUpdated ? "Updated \(Date())" : "")
                .font(.system(size: 2))
                .frame(height: 0)
            ListView(isUpdated: $isListUpdated)
        }
        .padding(sides: [.left, .right], value: 20)
    }
}

struct ChordTodo_MainView_Previews: PreviewProvider {
    static var previews: some View {
        ChordTodo_MainView()
    }
}

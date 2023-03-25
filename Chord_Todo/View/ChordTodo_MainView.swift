//
//  ChordTodo_MainView.swift
//  
//
//  Created by 윤범태 on 2023/03/24.
//

import SwiftUI

struct ChordTodo_MainView: View {
    @State var showWriterView = false
    @State var isWriteSuccess = false
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView {
                showWriterView = true
            }.sheet(isPresented: $showWriterView, onDismiss: {
                if isWriteSuccess {
                    print("Write Success")
                    isWriteSuccess = false
                } else {
                    print("Write failed")
                }
            }, content: {
                WriteView(isWriteSuccess: $isWriteSuccess)
            })
            Divider()
            
            // TODO: - 이거 없으면 뷰 업데이트가 안됨 -> 뷰 새로고침 방법?
            Text(isWriteSuccess ? "" : "")
            ListView(isUpdated: $isWriteSuccess)
        }
        .padding(sides: [.left, .right], value: 20)
    }
}

struct ChordTodo_MainView_Previews: PreviewProvider {
    static var previews: some View {
        ChordTodo_MainView()
    }
}

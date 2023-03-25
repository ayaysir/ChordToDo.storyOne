//
//  WriteView.swift
//  
//
//  Created by 윤범태 on 2023/03/25.
//

import SwiftUI

struct WriteView: View {
    @Binding var isWriteSuccess: Bool
    
    @State private var todoTitle: String = ""
    @State private var chordText: String = "C"
    @State private var comment: String = ""
    
    @State private var showTitleAlert = false
    @State private var showChordEmpty = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Write").font(.largeTitle)
            Divider()
            Text("제목").bold()
            // 1st parameter -> Placeholder
            TextField("제목을 작성하세요.", text: $todoTitle)
            Text("코드").bold()
            TextField("코드를 작성하세요.", text: $chordText)
            Text("코멘트")
            TextEditor(text: $comment)
                .frame(height: 200)
            Button("Submit") {
                guard !todoTitle.isEmpty else {
                    showTitleAlert = true
                    return
                }
                
                guard !chordText.isEmpty else {
                    showChordEmpty = true
                    return
                }
                
                let todo = ChordTodo(title: todoTitle, chord: chordText, comment: comment)
                
                // Save to UserDefaults
                do {
                    var list = (try? UserDefaults.standard.getObject(forKey: "TODO_LIST", castTo: [ChordTodo].self)) ?? [ChordTodo]()
                    list.append(todo)
                    // print(list)
                    try UserDefaults.standard.setObject(list, forKey: "TODO_LIST")
                    isWriteSuccess = true
                    dismiss()
                } catch {
                    print("Write Error:", error)
                }
            }.alert(Text("이름을 입력해야 합니다."), isPresented: $showTitleAlert) {
                Button("OK", role: .cancel) {}
            }.alert(Text("코드를 입력해야 합니다."), isPresented: $showChordEmpty) {
                Button("OK", role: .cancel) {}
            }
        }.padding(sides: [.left, .right], value: 20)
    }
}

struct WriteView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(true) {
            WriteView(isWriteSuccess: $0)
        }
    }
}

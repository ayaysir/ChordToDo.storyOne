//
//  WriteView.swift
//  
//
//  Created by 윤범태 on 2023/03/25.
//

import SwiftUI

struct WriteView: View {
    enum Mode {
        case create, update
        
        var textValue: String {
            switch self {
            case .create:
                return "Create"
            case .update:
                return "Update"
            }
        }
    }
    
    @Binding var isWriteSuccess: Bool
    
    var mode: Mode = .create
    
    @State var todoTitle: String = ""
    @State var chordText: String = "C"
    @State var comment: String = ""
    /// Update 전용: UUID
    @State var id: UUID? = nil
    
    @State private var showTitleAlert = false
    @State private var showChordEmpty = false
    
    @Environment(\.dismiss) var dismiss
    
    private func addTodo() {
        let todo = ChordTodo(title: todoTitle, chord: chordText, comment: comment)
        
        // Save to UserDefaults
        do {
            var list = (try? UserDefaults.standard.getObject(forKey: .cfgTodoList, castTo: [ChordTodo].self)) ?? [ChordTodo]()
            list.append(todo)
            // print(list)
            try UserDefaults.standard.setObject(list, forKey: .cfgTodoList)
            isWriteSuccess = true
            dismiss()
        } catch {
            print("Create Error:", error)
        }
    }
    
    private func updateTodo() {
        guard let id = id else {
            return
        }
        
        do {
            var list = (try? UserDefaults.standard.getObject(forKey: .cfgTodoList, castTo: [ChordTodo].self)) ?? [ChordTodo]()
            if let replaceIndex = list.firstIndex(where: { $0.id == id }) {
                list[replaceIndex].title = todoTitle
                list[replaceIndex].chord = chordText
                list[replaceIndex].comment = comment
                list[replaceIndex].modifiedDate = Date()
                
                try UserDefaults.standard.setObject(list, forKey: .cfgTodoList)
                isWriteSuccess = true
                dismiss()
            }
            
            // print(list)
        } catch {
            print("Update Error:", error)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Write: \(mode.textValue)").font(.largeTitle)
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("제목").bold()
                // 1st parameter -> Placeholder
                TextField("제목을 작성하세요.", text: $todoTitle)
            }
            
            Spacer().frame(height: 30)
            
            VStack(alignment: .leading) {
                Text("코드").bold()
                TextField("코드를 작성하세요.", text: $chordText)
                Text("코드 작성 예) Cdim7, Cmaj7, C7 등...")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            
            Spacer().frame(height: 30)
            
            Text("코멘트")
            TextEditor(text: $comment)
                .frame(height: 200)
            HStack {
                Button("취소") {
                    dismiss()
                }.foregroundColor(.gray)
                
                Spacer()
                
                Button("Submit") {
                    guard !todoTitle.isEmpty else {
                        showTitleAlert = true
                        return
                    }
                    
                    guard !chordText.isEmpty else {
                        showChordEmpty = true
                        return
                    }
                    
                    print(mode)
                    
                    switch mode {
                    case .create:
                        addTodo()
                    case .update:
                        updateTodo()
                    }
                }.alert(Text("이름을 입력해야 합니다."), isPresented: $showTitleAlert) {
                    Button("OK", role: .cancel) {}
                }.alert(Text("코드를 입력해야 합니다."), isPresented: $showChordEmpty) {
                    Button("OK", role: .cancel) {}
                }.foregroundColor(.green)
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

//
//  MainView.swift
//  
//
//  Created by 윤범태 on 2023/03/24.
//

import SwiftUI

enum Side: Equatable, Hashable {
    case left
    case right
}

extension View {
    func padding(sides: [Side], value: CGFloat = 8) -> some View {
        HStack(spacing: 0) {
            if sides.contains(.left) {
                Spacer().frame(width: value)
            }
            self
            if sides.contains(.right) {
                Spacer().frame(width: value)
            }
        }
    }
}

struct MainView: View {
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
            
            .sheet(isPresented: $showWriterView) {
                WriteView(isWriteSuccess: $isWriteSuccess)
            }
            Divider()
            
            // Todo: 이거 없으면 뷰 업데이트가 안됨 -> 뷰 새로고침 방법?
            Text(isWriteSuccess ? "" : "")
            BodyView(isUpdated: $isWriteSuccess)
        }
        .padding(sides: [.left, .right], value: 20)
    }
}

struct HeaderView: View {
    @State var headerTitle: String = "코드 감정 기록기"
    let writeButtonHandler: () -> ()
    
    var body: some View {
        HStack {
            Text(headerTitle)
                .font(.title)
            Spacer()
            Button("Write") {
                writeButtonHandler()
            }
        }
    }
}

struct BodyView: View {
    @Binding var isUpdated: Bool
    @ObservedObject var viewModel = BodyViewModel()
    
    var body: some View {
        // Text(isUpdated ? "Updated" : "Failed")
        List {
            ForEach(viewModel.list.reversed(), id: \.self) { todo in
                Text("\(todo.title) : \(todo.chord)")
            }
        }.onAppear {
            print("Body View: OnApppear")
            viewModel.load()
        }
    }
    
}

class BodyViewModel: ObservableObject {
    @Published var list: [ChordTodo] = [ChordTodo(title: "First", chord: "F", comment: "Fisrt")]
    
    init() {
        load()
    }
    
    func load() {
        print("load called")
        if let list = try? UserDefaults.standard.getObject(forKey: "TODO_LIST", castTo: [ChordTodo].self) {
            self.list = list
        } else {
            print("fetch failed")
        }
    }
}

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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

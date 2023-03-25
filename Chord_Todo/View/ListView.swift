//
//  ListView.swift
//  
//
//  Created by 윤범태 on 2023/03/25.
//

import SwiftUI

struct ListView: View {
    @Binding var isUpdated: Bool
    @ObservedObject var viewModel = ListViewModel()
    // @State var showBody = false
    // @State var showUpdateForm = false
    @State var currentTodo: ChordTodo?
    @State var toUpdateTodo: ChordTodo?
    
    var body: some View {
        // Text(isUpdated ? "Updated" : "Failed")
        List {
            ForEach(viewModel.list.reversed(), id: \.self) { todo in
                HStack {
                    Text(todo.title)
                    Text(todo.chord)
                        .font(.title)
                    Text(todo.createdDate.formatted())
                        .font(.footnote)
                        .foregroundColor(.gray)
                }.onTapGesture {
                    /*
                     https://www.hohyeonmoon.com/blog/swiftui-sheet-inside-foreach/
                     List에서 Cell을 클릭하면 sheet 뜨게 하기
                     1. 현재 element를 저장할 @State 변수 생성
                     2. onTapGesture에서 현재 요소를 @State에 저장
                     3. List.sheet(item: $currentItem) 사용
                     */
                    currentTodo = todo
                }.swipeActions {
                    // 순서: 오른쪽 -> 왼쪽
                    Button("Delete") {
                        if var list = try? UserDefaults.standard.getObject(forKey: .cfgTodoList, castTo: [ChordTodo].self) {
                            list.removeAll { $0.id == todo.id }
                            print("deleted list", todo.id, list)
                            try? UserDefaults.standard.setObject(list, forKey: .cfgTodoList)
                            
                            // 이게 된다고?
                            isUpdated = true
                            isUpdated = false
                        }
                    }.tint(.red)
                    Button("Update") {
                        toUpdateTodo = todo
                        // print("press update:", toUpdateTodo, todo)
                    }.tint(.blue)
                }
            }
        }.task {
            print("List View: task")
            viewModel.load()
        }.onAppear {
            print("List View: OnApppear")
        }.sheet(item: $currentTodo, onDismiss: {
            if isUpdated {
                print("Inner List Updated")
                isUpdated = false
            }
        }) { todo in
            BodyView(isTodoStateChanged: $isUpdated, chordTodo: todo)
        }.sheet(item: $toUpdateTodo) {
            WriteView(isWriteSuccess: $isUpdated, mode: .update, todoTitle: $0.title, chordText: $0.chord, comment: $0.comment, id: $0.id)
        }
    }
}

class ListViewModel: ObservableObject {
    @Published var list: [ChordTodo] = [ChordTodo(title: "First", chord: "F", comment: "")]
    
    init() {
        load()
    }
    
    func load() {
        print("load called")
        if let list = try? UserDefaults.standard.getObject(forKey: .cfgTodoList, castTo: [ChordTodo].self) {
            self.list = list
        } else {
            print("fetch failed")
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(false) {
            ListView(isUpdated: $0)
        }
    }
}

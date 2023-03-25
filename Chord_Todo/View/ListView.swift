//
//  ListView.swift
//  
//
//  Created by 윤범태 on 2023/03/25.
//

import SwiftUI

class ListViewModel: ObservableObject {
    @Published var list: [ChordTodo] = [ChordTodo(title: "First", chord: "F", comment: "")]
    
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

struct ListView: View {
    @Binding var isUpdated: Bool
    @ObservedObject var viewModel = ListViewModel()
    @State var showBody = false
    @State var currentTodo: ChordTodo?
    
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
                }
            }
        }.task {
            print("List View: task")
            viewModel.load()
        }.onAppear {
            print("List View: OnApppear")
        }.sheet(item: $currentTodo) { todo in
            BodyView(chordTodo: todo)
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

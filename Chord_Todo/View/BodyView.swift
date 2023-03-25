//
//  BodyView.swift
//  Story One
//
//  Created by 윤범태 on 2023/03/25.
//

import SwiftUI

struct BodyView: View {
    @State var chordTodo: ChordTodo
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text(chordTodo.title)
                .font(.largeTitle)
            Divider()
            Text("코드")
                .font(.largeTitle)
            HStack {
                Text(chordTodo.chord)
                    .font(.title2)
                Button {
                    //
                } label: {
                    Image(systemName: "play.fill")
                }

            }
            Divider()
            Text(chordTodo.comment.isEmpty ? "No Comment..." : chordTodo.comment)
            Divider()
            Button("닫기") {
                dismiss()
            }
        }
    }
}

struct BodyView_Previews: PreviewProvider {
    static var previews: some View {
        BodyView(chordTodo: ChordTodo(title: "불안하다", chord: "Cdim", comment: "comment...."))
    }
}

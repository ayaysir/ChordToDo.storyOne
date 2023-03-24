//
//  StacksView.swift
//  Story One
//
//  Created by 윤범태 on 2023/03/23.
//

import SwiftUI

struct StacksView: View {
    var body: some View {
        // ZStack {
        //     Text("가나다")
        //     Spacer()
        //     Text("ABC")
        // }
        //     VStack {
        //         Text("가나다")
        //         Spacer()
        //             .frame(height: 30)
        //         Image(systemName: "play.fill")
        //         Spacer()
        //         Text("ABC")
        //         Spacer()
        //         Image(systemName: "pause.fill")
        //     }
        // }
        VStack(spacing: 50) {
            Text("가나다")
            Image(systemName: "play.fill")
            Text("ABC")
            Image(systemName: "pause.fill")
        }
    }
}

struct StacksView_Previews: PreviewProvider {
    static var previews: some View {
        StacksView()
    }
}

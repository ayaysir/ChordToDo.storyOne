//
//  HeaderView.swift
//  
//
//  Created by 윤범태 on 2023/03/25.
//

import SwiftUI

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

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView {}
    }
}

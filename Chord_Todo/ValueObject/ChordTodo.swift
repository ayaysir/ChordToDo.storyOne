//
//  ChordTodo.swift
//  
//
//  Created by 윤범태 on 2023/03/24.
//

import Foundation

struct ChordTodo: Codable, Hashable, Identifiable {
    var id: UUID = UUID()
    var createdDate: Date = Date()
    var modifiedDate: Date?
    var title: String
    var chord: String
    var comment: String
}

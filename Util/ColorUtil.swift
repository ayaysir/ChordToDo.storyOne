//
//  ColorUtil.swift
//  
//
//  Created by 윤범태 on 2023/03/23.
//

import SwiftUI

func randomColor() -> Color {
    let rNum: CGFloat = CGFloat.random(in:0...1)
    let gNum: CGFloat = CGFloat.random(in:0...1)
    let bNum: CGFloat = CGFloat.random(in:0...1)
    
    return Color(red: rNum, green: gNum, blue: bNum)
}

//
//  Emotion.swift
//  FaceIt
//
//  Created by Apollo Zhu on 1/30/22.
//

import Foundation

struct Emotion: Identifiable {
    var id: UUID = UUID()
    let name: String
    let expression: FacialExpression
}

//
//  FacialExpression.swift
//  FaceIt
//
//  Created by Apollo Zhu on 1/30/22.
//  Adapted from 2017 Stanford CS193p open course.
//

struct FacialExpression {
    let eyes: Eyes
    let mouth: Mouth
    
    var sadder: FacialExpression {
        FacialExpression(eyes: eyes, mouth: mouth.sadder)
    }
    var happier: FacialExpression {
        FacialExpression(eyes: eyes, mouth: mouth.happier)
    }
    
    enum Eyes {
        case open, closed, squinting
    }
    
    enum Mouth: Int {
        case frown, smirk, neutral, grin, smile
        
        var sadder: Mouth {
            Mouth(rawValue: rawValue - 1) ?? .frown
        }
        var happier : Mouth {
            Mouth(rawValue: rawValue + 1) ?? .smile
        }
    }
}

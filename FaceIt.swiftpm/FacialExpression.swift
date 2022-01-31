//
//  FacialExpression.swift
//  FaceIt
//
//  Created by Apollo Zhu on 1/30/22.
//  Adapted from 2017 Stanford CS193p open course.
//

import SwiftUI

struct FacialExpression {
    let eyes: Eyes
    let mouth: Mouth
    
    var sadder: FacialExpression {
        FacialExpression(eyes: eyes, mouth: mouth.sadder)
    }
    var happier: FacialExpression {
        FacialExpression(eyes: eyes, mouth: mouth.happier)
    }
    
    enum Eyes: CaseIterable {
        case open, closed, squinting
        
        var localizedName: LocalizedStringKey {
            switch self {
            case .open:
                return "Eyes Open"
            case .closed:
                return "Eyes Closed"
            case .squinting:
                return "Squinting"
            }
        }
    }
    
    enum Mouth: Int, CaseIterable {
        case frown, smirk, neutral, grin, smile
        
        var sadder: Mouth {
            Mouth(rawValue: rawValue - 1) ?? .frown
        }
        var happier : Mouth {
            Mouth(rawValue: rawValue + 1) ?? .smile
        }
        
        var localizedName: LocalizedStringKey {
            switch self {
            case .frown:
                return "Frown"
            case .smirk:
                return "Smirk"
            case .neutral:
                return "Neutral"
            case .grin:
                return "Grin"
            case .smile:
                return "Smile"
            }
        }
    }
}

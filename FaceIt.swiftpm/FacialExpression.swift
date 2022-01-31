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
        
        var localizedName: String {
            switch self {
            case .open:
                return String(localized: "Eyes Open")
            case .closed:
                return String(localized: "Eyes Closed")
            case .squinting:
                return String(localized: "Squinting")
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
        
        var localizedName: String {
            switch self {
            case .frown:
                return String(localized: "Frown")
            case .smirk:
                return String(localized: "Smirk")
            case .neutral:
                return String(localized: "Neutral")
            case .grin:
                return String(localized: "Grin")
            case .smile:
                return String(localized: "Smile")
            }
        }
    }
}

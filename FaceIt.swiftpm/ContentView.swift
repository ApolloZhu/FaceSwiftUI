//
//  ContentView.swift
//  FaceIt
//
//  Created by Apollo Zhu on 1/30/22.
//  Adapted from 2017 Stanford CS193p open course.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(BuiltinEmotions.allCases, id: \.self) { emotion in
                    NavigationLink(emotion.localizedName) {
                        FaceView(expression: emotion.expression)
                            .navigationTitle(emotion.localizedName)
                    }
                }
            }
            .navigationTitle("Emotions")
        }
    }
    
    private enum BuiltinEmotions: CaseIterable {
        case sad, happy, worried
        
        var localizedName: LocalizedStringKey {
            switch self {
            case .sad:
                return "Sad"
            case .happy:
                return "Happy"
            case .worried:
                return "Worried"
            }
        }
        
        var expression: FacialExpression {
            switch self {
            case .sad:
                return FacialExpression(eyes: .closed, mouth: .frown)
            case .happy:
                return FacialExpression(eyes: .open, mouth: .smile)
            case .worried:
                return FacialExpression(eyes: .open, mouth: .smirk)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

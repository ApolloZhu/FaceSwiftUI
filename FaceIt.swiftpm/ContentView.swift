//
//  ContentView.swift
//  FaceIt
//
//  Created by Apollo Zhu on 1/30/22.
//  Adapted from 2017 Stanford CS193p open course.
//

import SwiftUI

struct ContentView: View {
    @State var emotions: [Emotion] = [
        Emotion(name: NSLocalizedString("Sad", comment: ""),
                expression: FacialExpression(eyes: .closed, mouth: .frown)),
        Emotion(name: NSLocalizedString("Happy", comment: ""),
                expression: FacialExpression(eyes: .open, mouth: .smile)),
        Emotion(name: NSLocalizedString("Worried", comment: ""),
                expression: FacialExpression(eyes: .open, mouth: .smirk)),
    ]
    @State var showEditor = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach($emotions) { $emotion in
                    NavigationLink(emotion.name) {
                        FaceView(expression: Binding {
                            emotion.expression
                        } set: { newValue in
                            emotion = Emotion(id: emotion.id, name: emotion.name, expression: newValue)
                        })
                        .navigationTitle(emotion.name)
                    }
                }
            }
            .navigationTitle("Emotions")
            .toolbar {
                Button {
                    showEditor = true
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showEditor) {
                ExpressionEditor() { emotion in
                    emotions.append(emotion)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

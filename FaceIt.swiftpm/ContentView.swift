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
        Emotion(name: String(localized: "Sad"),
                expression: FacialExpression(eyes: .closed, mouth: .frown)),
        Emotion(name: String(localized: "Happy"),
                expression: FacialExpression(eyes: .open, mouth: .smile)),
        Emotion(name: String(localized: "Worried"),
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
                .onDelete { offsets in
                    emotions.remove(atOffsets: offsets)
                }
                .onMove { source, destination in
                    emotions.move(fromOffsets: source, toOffset: destination)
                }
            }
            .navigationTitle("Emotions")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showEditor = true
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigation) {
                    EditButton()
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

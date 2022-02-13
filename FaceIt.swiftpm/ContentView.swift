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
                ForEach(emotions) { emotion in
                    NavigationLink(emotion.name) {
                        InteractiveFaceView(expression: emotion.expression)
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
            .listStyle(.sidebar)
            .navigationTitle("Emotions")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showEditor = true
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
                #if os(iOS)
                ToolbarItem(placement: .navigation) {
                    EditButton()
                }
                #endif
            }
            .sheet(isPresented: $showEditor) {
                ExpressionEditor { emotion in
                    emotions.append(emotion)
                }
            }
            
            Text("Select an emotion from the list of emotions to display here.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ExpressionEditor.swift
//  FaceIt
//
//  Created by Apollo Zhu on 1/30/22.
//  Adapted from 2017 Stanford CS193p open course.
//

import SwiftUI

struct ExpressionEditor: View {
    @Environment(\.dismiss) var dismiss
    @State var name: String = ""
    @State var expression = FacialExpression(eyes: .open, mouth: .frown)
    let onSave: (Emotion) -> ()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                    .textFieldStyle(.plain)
                    .textInputAutocapitalization(.words)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                
                FaceView(expression: expression)
                    .aspectRatio(contentMode: .fill)
                    .padding()
                
                Picker("Eyes", selection: eyes) {
                    ForEach(FacialExpression.Eyes.allCases, id: \.self) { eye in
                        Text(eye.localizedName)
                            .tag(eye)
                    }
                }
                .pickerStyle(.segmented)
                
                Picker("Mouth", selection: mouth) {
                    ForEach(FacialExpression.Mouth.allCases, id: \.self) { mouth in
                        Text(mouth.localizedName)
                            .tag(mouth)
                    }
                }
                .pickerStyle(.segmented)
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        onSave(Emotion(name: name, expression: expression))
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private var eyes: Binding<FacialExpression.Eyes> {
        Binding {
            expression.eyes
        } set: { newValue in
            withAnimation {
                expression = FacialExpression(eyes: newValue, mouth: expression.mouth)
            }
        }
    }
    
    private var mouth: Binding<FacialExpression.Mouth> {
        Binding {
            expression.mouth
        } set: { newValue in
            withAnimation {
                expression = FacialExpression(eyes: expression.eyes, mouth: newValue)
            }
        }
    }
}

struct ExpressionEditor_Previews: PreviewProvider {
    static var previews: some View {
        ExpressionEditor() {
            print($0)
        }
    }
}

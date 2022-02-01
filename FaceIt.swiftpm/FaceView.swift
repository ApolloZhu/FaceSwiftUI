//
//  FaceView.swift
//  FaceIt
//
//  Created by Apollo Zhu on 1/30/22.
//  Adapted from 2017 Stanford CS193p open course.
//

import SwiftUI

struct FaceView: View {
    let expression: FacialExpression
    @State private var squintingEyesOpen = false
    @State private var isSquinting = false
    
    var body: some View {
        Face(eyesOpen: eyesOpen,
             mouthCurvature: Self.mouthCurvatures[expression.mouth]!)
            .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
            .foregroundColor(.accentColor)
            .onAppear {
                isSquinting = expression.eyes == .squinting
            }
            .onChange(of: expression.eyes) { newValue in
                isSquinting = newValue == .squinting
            }
            .onChange(of: isSquinting) { _ in
                blinkIfNeeded()
            }
            .accessibilityLabel(Text("Face"))
            .accessibilityValue(Text("\(expression.mouth.localizedName), \(expression.eyes.localizedName)"))
    }
    
    private var eyesOpen: Bool {
        switch expression.eyes {
        case .open:
            return true
        case .closed:
            return false
        case .squinting:
            return squintingEyesOpen
        }
    }
    
    private func blinkIfNeeded() {
        guard isSquinting else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + (squintingEyesOpen ? 0.4 : 2.5)) {
            blinkIfNeeded()
        }
        withAnimation(.easeInOut(duration: 0.4)) {
            squintingEyesOpen.toggle()
        }
    }
    
    private static let mouthCurvatures: [FacialExpression.Mouth : Double] = [
        .smile: 1.0,
        .grin: 0.5,
        .neutral: 0.0,
        .smirk: -0.5,
        .frown: -1.0,
    ]
}

struct FaceView_Previews: PreviewProvider {
    static var previews: some View {
        FaceView(expression: FacialExpression(eyes: .open, mouth: .neutral))
#if os(iOS)
        FaceView(expression: FacialExpression(eyes: .open, mouth: .neutral))
            .previewInterfaceOrientation(.landscapeLeft)
#endif
    }
}

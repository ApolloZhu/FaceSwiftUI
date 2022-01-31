//
//  FaceView.swift
//  FaceIt
//
//  Created by Apollo Zhu on 1/30/22.
//  Adapted from 2017 Stanford CS193p open course.
//

import SwiftUI

struct FaceView: View {
    @State var expression = FacialExpression(eyes: .open, mouth: .neutral)
    @State var scale: CGFloat = 0.9
    @GestureState private var magnifyBy: CGFloat = 1.0
    
    var body: some View {
        Face(eyesOpen: eyesOpen,
             mouthCurvature: Self.mouthCurvatures[expression.mouth]!)
            .scale(finalScale)
            .stroke(lineWidth: 5 * finalScale)
            .foregroundColor(.accentColor)
            .background() // ensures entire screen is responding to gesture
            .gesture(
                // Handle "pinch"
                MagnificationGesture()
                    .updating($magnifyBy) { currentState, gestureState, _ in
                        // Update transient scale
                        gestureState = currentState
                    }
                    .onEnded { magnifyBy in
                        // Persist final scale
                        scale *= magnifyBy
                    }
            )
            .onTapGesture {
                expression = FacialExpression(eyes: eyesOpen ? .closed : .open,
                                              mouth: expression.mouth)
            }
            .gesture(
                // This is more like "pan" than "swipe", but there's no swipe...
                DragGesture()
                    .onEnded { value in
                        let yOffset = value.translation.height
                        // This behavior is different from CS193p;
                        // It moves the mouth instead of the "happiness" value
                        if yOffset > 0 {
                            // swipe down
                            expression = expression.happier
                        } else if yOffset < 0 {
                            // swipe up
                            expression = expression.sadder
                        }
                    }
            )
    }
    
    private var finalScale: CGFloat {
        scale * magnifyBy
    }
    
    private var eyesOpen: Bool {
        switch expression.eyes {
        case .open:
            return true
        case .closed, .squinting:
            return false
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
        FaceView()
        
#if os(iOS)
        FaceView()
            .previewInterfaceOrientation(.landscapeLeft)
#endif
    }
}

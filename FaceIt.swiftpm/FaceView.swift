//
//  FaceView.swift
//  FaceIt
//
//  Created by Apollo Zhu on 1/30/22.
//  Adapted from 2017 Stanford CS193p open course.
//

import SwiftUI

struct FaceView: View {
    @Binding var expression: FacialExpression
    @State var scale: CGFloat = 0.9
    @GestureState private var magnifyBy: CGFloat = 1.0
    @State private var squintingEyesOpen = false
    @State var headRotation: Angle = .zero
    private(set) var backgroundColor = Color(uiColor: UIColor.systemBackground)
    
    var body: some View {
        Face(eyesOpen: eyesOpen,
             mouthCurvature: Self.mouthCurvatures[expression.mouth]!)
            .scale(finalScale)
            .stroke(lineWidth: 5 * finalScale)
            .foregroundColor(.accentColor)
            .rotationEffect(headRotation)
            // ensures entire screen is responding to gesture
            .background(backgroundColor)
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
                withAnimation {
                    switch expression.eyes {
                    case .open:
                        expression = FacialExpression(eyes: .closed,
                                                      mouth: expression.mouth)
                    case .closed:
                        expression = FacialExpression(eyes: .open,
                                                      mouth: expression.mouth)
                    case .squinting:
                        break
                    }
                }
            }
            .gesture(
                // This is more like "pan" than "swipe", but there's no swipe...
                DragGesture()
                    .onEnded { value in
                        let yOffset = value.translation.height
                        // This behavior is different from CS193p;
                        // It moves the mouth instead of the "happiness" value
                        withAnimation {
                            if yOffset > 0 {
                                // swipe down
                                expression = expression.happier
                            } else if yOffset < 0 {
                                // swipe up
                                expression = expression.sadder
                            }
                        }
                    }
            )
            .simultaneousGesture(
                TapGesture(count: 2)
                    .onEnded {
                        switch expression.eyes {
                        case .open, .closed:
                            expression = FacialExpression(eyes: .squinting,
                                                          mouth: expression.mouth)
                        case .squinting:
                            expression = FacialExpression(eyes: squintingEyesOpen ? .open : .closed,
                                                          mouth: expression.mouth)
                        }
                    }
            )
            .onAppear {
                blinkIfNeeded()
            }
            .onChange(of: expression.eyes) { newValue in
                blinkIfNeeded()
            }
            .simultaneousGesture(
                TapGesture(count: 3)
                    .onEnded {
                        shakeHead()
                    }
            )
            .accessibilityLabel(Text("Face"))
            .accessibilityValue(Text("\(expression.mouth.localizedName), \(expression.eyes.localizedName)"))
    }
    
    private var finalScale: CGFloat {
        scale * magnifyBy
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
        guard expression.eyes == .squinting else { return }
        withAnimation(.easeInOut(duration: 0.4)) {
            squintingEyesOpen = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            guard expression.eyes == .squinting else { return }
            withAnimation(.easeInOut(duration: 0.4)) {
                squintingEyesOpen = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                blinkIfNeeded()
            }
        }
    }
    
    private static let mouthCurvatures: [FacialExpression.Mouth : Double] = [
        .smile: 1.0,
        .grin: 0.5,
        .neutral: 0.0,
        .smirk: -0.5,
        .frown: -1.0,
    ]
    
    private enum HeadShake {
        static let angle: Angle = .degrees(30)
        static let segmentDuration: TimeInterval = 0.4
    }
    
    private func shakeHead() {
        withAnimation(
            .easeInOut(duration: HeadShake.segmentDuration)
        ) {
            headRotation = HeadShake.angle
        }
        withAnimation(
            .easeInOut(duration: HeadShake.segmentDuration)
            .delay(HeadShake.segmentDuration)
        ) {
            headRotation = -HeadShake.angle
        }
        withAnimation(
            .easeInOut(duration: HeadShake.segmentDuration)
            .delay(HeadShake.segmentDuration * 2)
        ) {
            headRotation = .zero
        }
    }
}

struct FaceView_Previews: PreviewProvider {
    static var previews: some View {
        FaceView(expression: .constant(FacialExpression(eyes: .open, mouth: .neutral)))
#if os(iOS)
        FaceView(expression: .constant(FacialExpression(eyes: .open, mouth: .neutral)))
            .previewInterfaceOrientation(.landscapeLeft)
#endif
    }
}

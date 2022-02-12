//
//  InteractiveFaceView.swift
//  FaceIt
//
//  Created by Apollo Zhu on 1/31/22.
//  Adapted from 2017 Stanford CS193p open course.
//

import SwiftUI

struct InteractiveFaceView: View {
    @State var expression: FacialExpression
    @State var scale: CGFloat = 1
    @GestureState private var magnifyBy: CGFloat = 1.0
    @State var headRotation: Angle = .zero
    private(set) var backgroundColor = Color(uiColor: UIColor.systemBackground)
    
    var body: some View {
        FaceView(expression: expression)
            .scaleEffect(finalScale)
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
                        withAnimation {
                            switch expression.eyes {
                            case .open, .closed:
                                expression = FacialExpression(eyes: .squinting,
                                                              mouth: expression.mouth)
                            case .squinting:
                                expression = FacialExpression(eyes: .open,
                                                              mouth: expression.mouth)
                            }
                        }
                    }
            )
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

struct InteractiveFaceView_Previews: PreviewProvider {
    static var previews: some View {
        InteractiveFaceView(expression: FacialExpression(eyes: .open, mouth: .neutral))
    }
}

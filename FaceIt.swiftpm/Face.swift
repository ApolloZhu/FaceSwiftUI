//
//  Face.swift
//  FaceIt
//
//  Created by Apollo Zhu on 1/30/22.
//  Adapted from 2017 Stanford CS193p open course.
//

import SwiftUI

struct Face: Shape {
    let eyesOpen: Bool
    /// -1.0 (frown) to 1.0 (smile)
    let mouthCurvature: Double
    
    public init(eyesOpen: Bool = false,
                mouthCurvature: Double = 0.0) {
        self.eyesOpen = eyesOpen
        self.mouthCurvature = max(-1, min(mouthCurvature, 1))
    }
    
    private struct Skull {
        let center: CGPoint
        let radius: CGFloat
    }
    
    func path(in rect: CGRect) -> Path {
        let skull = Skull(
            center: CGPoint(x: rect.midX, y: rect.midY),
            radius: min(rect.width, rect.height) / 2
        )
        return Path { path in
            path.addPath(pathForSkull(skull))
            path.addPath(pathForEye(.left, in: skull))
            path.addPath(pathForEye(.right, in: skull))
            path.addPath(pathForMouth(in: skull))
        }
    }
    
    private func pathForSkull(_ skull: Skull) -> Path {
        Path { path in
            path.addArc(center: skull.center, radius: skull.radius,
                        startAngle: .zero, endAngle: .degrees(360),
                        clockwise: true)
        }
    }
    
    private enum Eye {
        case left, right
    }
    
    private func pathForEye(_ eye: Eye, in skull: Skull) -> Path {
        var eyeCenter: CGPoint {
            let eyeOffset = skull.radius / Ratios.skullRadiusToEyeOffset
            var eyeCenter = skull.center
            eyeCenter.y -= eyeOffset
            switch eye {
            case .left:
                eyeCenter.x -= eyeOffset
            case .right:
                eyeCenter.x += eyeOffset
            }
            return eyeCenter
        }
        let eyeRadius = skull.radius / Ratios.skullRadiusToEyeRadius
        return Path { path in
            if eyesOpen {
                path.addArc(center: eyeCenter, radius: eyeRadius,
                            startAngle: .zero, endAngle: .degrees(360),
                            clockwise: true)
            } else {
                path.move(to: CGPoint(x: eyeCenter.x - eyeRadius,
                                      y: eyeCenter.y))
                path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius,
                                         y: eyeCenter.y))
            }
        }
    }
    
    private func pathForMouth(in skull: Skull) -> Path {
        let mouthWidth = skull.radius / Ratios.skullRadiusToMouthWidth
        let mouthHeight = skull.radius / Ratios.skullRadiusToMouthHeight
        let mouthOffset = skull.radius / Ratios.skullRadiusToMouthOffset
        let mouthRect = CGRect(x: skull.center.x - mouthWidth / 2,
                               y: skull.center.y + mouthOffset,
                               width: mouthWidth,
                               height: mouthHeight)
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        // Thanks to Swift, CGFloat and Double are convertible now :)
        let smileOffset = mouthCurvature * mouthRect.height
        return Path { path in
            path.move(to: start)
            path.addCurve(to: end,
                          control1: CGPoint(x: start.x + mouthRect.width / 3,
                                            y: start.y + smileOffset),
                          control2: CGPoint(x: end.x - mouthRect.width / 3,
                                            y: start.y + smileOffset))
        }
    }
    
    
    private enum Ratios {
        static let skullRadiusToEyeOffset: CGFloat = 3
        static let skullRadiusToEyeRadius: CGFloat = 10
        static let skullRadiusToMouthWidth: CGFloat = 1
        static let skullRadiusToMouthHeight: CGFloat = 3
        static let skullRadiusToMouthOffset: CGFloat = 3
    }
}

struct Face_Previews: PreviewProvider {
    static var previews: some View {
        Face()
            .stroke(lineWidth: 5)
            .scale(0.9)
    }
}

//
//  ShimmerView.swift
//  
//
//  Created by Ryan Lintott on 2021-05-25.
//

import SwiftUI

@available(iOS 14, *)
public struct ShimmerView: View {
    @EnvironmentObject var motionManager: MotionManager
    @Environment(\.colorScheme) var colorScheme
    
    let mode: ShimmerMode
    let color: Color
    let background: Color

    let startRadius: CGFloat = 5
    let endRadius: CGFloat = 125
    let scale: CGFloat = 5
    let aspectRatio: CGFloat = 0.5
    let distance: CGFloat = 4000
    let pitch: Angle = .degrees(45)
    let yaw: Angle = .degrees(0)
    let localRoll: Angle = .degrees(-30)
    
    public init(mode: ShimmerMode? = nil, color: Color, background: Color) {
        self.mode = mode ?? .on
        self.color = color
        self.background = background
    }
    
    public init(isOn: Bool, color: Color, background: Color) {
        self.init(mode: isOn ? .on : .off, color: color, background: background)
    }
    
    var isShimmering: Bool {
        motionManager.updateInterval > 0 && mode.isOn(colorScheme: colorScheme)
    }
    
    public var body: some View {
        background
            .overlay(
                Group {
                    if isShimmering {
                        LookingGlass(.reflection, distance: distance, perspective: 0, pitch: pitch, yaw: yaw, localRoll: localRoll, isShowingInFourDirections: true) {
                            RadialGradient(gradient: Gradient(colors: [color, background]), center: .center, startRadius: startRadius, endRadius: endRadius)
                                .frame(width: endRadius * 2, height: endRadius * 2)
                                .scaleEffect(x: scale * aspectRatio, y: scale / aspectRatio, anchor: .center)
                        }
                        .allowsHitTesting(false)
                    }
                }
            )
            .clipped()
    }
}

@available(iOS 14, *)
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ShimmerView(color: .red, background: .blue)
    }
}

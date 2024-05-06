//
//  ContentView.swift
//  SwiftUIMarathon03
//
//  Created by Mike Rudoy on 05/05/2024.
//

import SwiftUI

struct ContentView: View {
    private let fontSize: CGFloat
    private let rightOffset: CGSize
    private let halfRightOffset: CGSize
    private let stackSpacing: CGFloat
    @State var stackIncrease = false
    @State var isEnabled = true
    @State var animationState: AnimatedState = .start

    init(fontSize: CGFloat = 28) {
        self.fontSize = fontSize
        let rightOffsetWidth = fontSize * 0.75
        self.rightOffset = CGSize(width: rightOffsetWidth, height: 0)
        self.halfRightOffset = CGSize(width: rightOffsetWidth / 2.0, height: 0)
        self.stackSpacing = -0.125 * fontSize
    }

    var body: some View {
        Button(action: {
            isEnabled = false
            withAnimation(.easeInOut(duration: 0.3)) {
                animationState.switchToNext()
                stackIncrease = true
            } completion: {
                animationState = .start
                isEnabled = true
                withAnimation(.linear(duration: 0.15)) {
                    stackIncrease = false
                }
            }
        }, label: {
            HStack(spacing: stackSpacing) {
                AnimatableImage(
                    startAnimationProperties: .init(
                        scale: .zero,
                        offset: halfRightOffset,
                        opacity: 0
                    ),
                    endAnimationProperties: .init(
                        offset: rightOffset
                    ),
                    animationState: self.animationState,
                    imageName: "play.fill"
                )
                AnimatableImage(
                    startAnimationProperties: .init(),
                    endAnimationProperties: .init(offset: rightOffset),
                    animationState: self.animationState,
                    imageName: "play.fill"
                )
                AnimatableImage(
                    startAnimationProperties: .init(),
                    endAnimationProperties: .init(
                        scale: .zero,
                        offset: halfRightOffset,
                        opacity: 0
                    ),
                    animationState: self.animationState,
                    imageName: "play.fill"
                )
                AnimatableImage(
                    startAnimationProperties: .init(opacity: 0),
                    endAnimationProperties: .init(opacity: 0),
                    animationState: self.animationState,
                    imageName: "play.fill"
                )
            }
            .scaleEffect(stackIncrease ? CGSize(width: 1.05, height: 1.05) : .identity)
                .font(Font.system(size: fontSize))
        }
        )
        .disabled(!isEnabled)
        .buttonStyle(CustomButtonStyle(normalColor: .blue))
    }
}

#Preview {
    ContentView(fontSize: 28)
}

extension CGSize {
    static var identity = CGSize(width: 1.0, height: 1.0)
}

struct AnimatableImage: View {

    private let startAnimationProperties: AnimationProperties
    private let endAnimationProperties: AnimationProperties

    var animationState: AnimatedState
    private var imageName: String

    init(
        startAnimationProperties: AnimationProperties,
        endAnimationProperties: AnimationProperties,
        animationState: AnimatedState,
        imageName: String) {
        self.startAnimationProperties = startAnimationProperties
        self.endAnimationProperties = endAnimationProperties
        self.imageName = imageName
        self.animationState = animationState
    }

    var body: some View {
        switch animationState {
        case .start:
            return Image(systemName: imageName)
                .with(animationProperties: startAnimationProperties)
        case .end:
            return Image(systemName: imageName)
                .with(animationProperties: endAnimationProperties)
        }
    }
}

extension Image {
    func with(animationProperties: AnimationProperties) -> some View {
        self
            .scaleEffect(animationProperties.scale ?? .identity)
            .offset(animationProperties.offset ?? .zero)
            .opacity(animationProperties.opacity ?? 1)
    }
}

enum AnimatedState {
    case start
    case end

    mutating func switchToNext() {
        switch self {
        case .start:
            self = .end
        case .end:
            self = .start
        }
    }
}

struct AnimationProperties {
    var scale: CGSize?
    var offset: CGSize?
    var opacity: CGFloat?
}

struct CustomButtonStyle: ButtonStyle {
    var normalColor: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(normalColor)
    }
}

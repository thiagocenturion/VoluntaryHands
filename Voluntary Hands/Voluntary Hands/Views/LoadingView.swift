//
//  LoadingView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 07/06/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    
    // MARK: - Properties
    @State var animateTrimPath = false
    @State var rotaeInfinity = false
    
    // MARK: - View
    var body: some View {
        ZStack {
            Path { path in
                path.addLines(
                    [
                        .init(x: 2, y: 1),
                        .init(x: 1, y: 0),
                        .init(x: 0, y: 1),
                        .init(x: 1, y: 2),
                        .init(x: 3, y: 0),
                        .init(x: 4, y: 1),
                        .init(x: 3, y: 2),
                        .init(x: 2, y: 1)
                    ]
                )
            }
            .trim(from: animateTrimPath ? 1/0.99 : 0, to: animateTrimPath ? 1/0.99 : 1)
            .scale(50, anchor: .topLeading)
            .stroke(Color.Style.grayLight, lineWidth: 20)
            .offset(x: 110, y: 350)
            .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true))
            .onAppear() {
                self.animateTrimPath.toggle()
            }
            
            Path { path in
                path.addLines(
                    [
                        .init(x: 2, y: 1),
                        .init(x: 1, y: 0),
                        .init(x: 0, y: 1),
                        .init(x: 1, y: 2)
                    ]
                )
            }
            .trim(from: animateTrimPath ? 1/0.99 : 0, to: animateTrimPath ? 1/0.99 : 1)
            .scale(50, anchor: .topLeading)
            .stroke(Color.Style.blueLight, lineWidth: 20)
            .offset(x: 110, y: 350)
            .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true))
            
            Path { path in
                path.addLines(
                    [
                        .init(x: 3, y: 0),
                        .init(x: 4, y: 1),
                        .init(x: 3, y: 2),
                        .init(x: 2, y: 1)
                    ]
                )
            }
            .trim(from: animateTrimPath ? 1/0.99 : 0, to: animateTrimPath ? 1/0.99 : 1)
            .scale(50, anchor: .topLeading)
            .stroke(Color.Style.red, lineWidth: 20)
            .offset(x: 110, y: 350)
            .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true))
        }
        .rotationEffect(.degrees(rotaeInfinity ? 0 : -360))
        .scaleEffect(0.3, anchor: .center)
        .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: false))
        .onAppear {
            self.rotaeInfinity.toggle()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

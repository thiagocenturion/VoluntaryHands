//
//  SizePreferenceKey.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 11/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

// from: https://medium.com/better-programming/custom-ios-segmented-control-with-swiftui-473b386d0b51
// 1. PreferenceKey for a subview to notify superview of its size
struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize // Define that the PreferenceKey attribute is of type CGSize
    static var defaultValue: CGSize = .zero // Default to zero size
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

// 2. A view that will serve as the background of one of our text elements (the subview)
struct BackgroundGeometryReader: View {
    var body: some View {
        // Transparent background, wrapped in a GeometryReader so we can read the size
        GeometryReader { geometry in
            return Color
                .clear
                // Attach the PreferenceKey to the view, passing the size to the key
                .preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }
}

// 3. Define a helper ViewModifier to attach to the subview that encapsulates the PreferenceKey
struct SizeAwareViewModifier: ViewModifier {
    
    // Define a @Binding so we can read the size of the subivew
    @Binding private var viewSize: CGSize
    
    init(viewSize: Binding<CGSize>) {
        self._viewSize = viewSize
    }
    
    func body(content: Content) -> some View {
        content
            // Add the background - this will return the size of the view
            .background(BackgroundGeometryReader())
            // Watch for changes in SizePreferenceKey, then update the binding with the new value
            .onPreferenceChange(SizePreferenceKey.self, perform: { if self.viewSize != $0 { self.viewSize = $0 }})
    }
}

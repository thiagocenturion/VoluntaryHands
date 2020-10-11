//
//  SegmentedPicker.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 10/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct SegmentedPicker<Data, ID, Content> : View where Data: RandomAccessCollection, Data.Element: Hashable, Data.Element: CaseIterable, ID: Hashable, Content : View {
    
    /// The collection of underlying identified data that SwiftUI uses to create
    /// views dynamically.
    var data: Data
    var id: KeyPath<Data.Element, ID>
    @Binding var selection: Data.Element
    
    /// A function you can use to create content on demand using the underlying
    /// data.
    var content: (Data.Element) -> Content
    
    @State private var segmentSize: CGSize = .zero
    
    /// The content and behavior of the view.
    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .frame(height: 40)
                .foregroundColor(Color.Style.gray)
            
            Capsule()
                .foregroundColor(.clear)
                .background(LinearGradient.blue())
                .cornerRadius(22.5)
                .shadow(color: Color.black.opacity(0.5), radius: 10)
                .frame(width: segmentSize.width, height: 45)
                .offset(x: computeActiveSegmentHorizontalOffset())
                .animation(.easeOut)
            
            HStack {
                ForEach(data, id: id) { element in
                    content(element)
                        .lineLimit(1)
                        .padding(.vertical, 4)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .modifier(SizeAwareViewModifier(viewSize: self.$segmentSize))
                        .onTapGesture { self.selection = element }
                }
            }
        }
    }
}

extension SegmentedPicker {
    private func computeActiveSegmentHorizontalOffset() -> CGFloat {
        let index = (Data.Element.allCases.firstIndex { selection == $0 } as? Int).unsafelyUnwrapped
        
        return CGFloat(index) * (segmentSize.width + 7)
    }
}

extension SegmentedPicker: DynamicViewContent where Content: View {
    
    /// Creates an instance that uniquely identifies and creates views across
    /// updates based on the provided key path to the underlying data's
    /// identifier.
    ///
    /// It's important that the `id` of a data element doesn't change, unless
    /// SwiftUI considers the data element to have been replaced with a new data
    /// element that has a new identity. If the `id` of a data element changes,
    /// then the content view generated from that data element will lose any
    /// current state and animations.
    ///
    /// - Parameters:
    ///   - data: The data that the `ForEach` instance uses to create views
    ///     dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - content: The view builder that creates views dynamically.
    init(_ data: Data, id: KeyPath<Data.Element, ID>, selection: Binding<Data.Element>, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        
        self.data = data
        self.id = id
        self._selection = selection
        self.content = content
    }
}

struct SegmentedPicker_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SegmentedPicker(UserType.allCases, id: \.self, selection: .constant(UserType.institution)) { type in
                Text(type.rawValue)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
        }
        .padding(.vertical, 500)
        .background(Color.Style.grayDark)
    }
}

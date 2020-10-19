//
//  SocialCausesView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 19/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct SocialCausesView: View {
    var loading: SocialCausesState.LoadingType
    let causes: [Cause]
    let causesSelected: [Cause]
    let onSelectCause: (Cause) -> Void
    let onDeselectCause: (Cause) -> Void
    let onCommit: () -> Void
    
    var body: some View {
        ZStack {
            switch loading {
            case .none:
                content
            case .opaque:
                ActivityView()
                    .background(Color.Style.grayDark)
                    .ignoresSafeArea(.container, edges: .vertical)
            case .transparent:
                content.opacity(0.3)
                    .allowsHitTesting(false)
                ActivityView()
            }
        }
    }
    
    var content: some View {
        ScrollView(.vertical, showsIndicators: true) {
            Spacer(minLength: 64) // Navigation
            Spacer(minLength: 20)
            VStack(spacing: 40) {
                Text("ESCOLHA SUAS CAUSAS DE APOIO")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 20) {
                    ForEach(causes) { item in
                        let isSelected = causesSelected.contains(item)
                        Button(action: { withAnimation(.easeOut(duration: 0.15)) { isSelected ? onDeselectCause(item) : onSelectCause(item) } }) {
                            ZStack(alignment: .topTrailing) {
                                HStack {
                                    Spacer()
                                    VStack(spacing: 8) {
                                        Spacer()
                                        Image(systemName: "leaf.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 34)
                                            .accentColor(isSelected ? .white : Color.Style.grayLight)
                                        Text(item.cause)
                                            .multilineTextAlignment(.center)
                                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                                            .lineLimit(2)
                                            .foregroundColor(isSelected ? .white : Color.Style.grayLight)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .accentColor(isSelected ? .white : .clear)
                                    .frame(width: 15)
                                    .offset(x: -10, y: 10)
                            }
                        }
                        .frame(width: 150, height: 110)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                                    isSelected ? Color.Style.blue : Color.Style.grayMedium,
                                                    isSelected ? Color.Style.blueLight: Color.Style.grayMedium]),
                                startPoint: .bottomLeading,
                                endPoint: .topTrailing
                            )
                        )
                        .cornerRadius(10)
                        .scaleEffect(isSelected ? 0.9 : 1.0)
                        .shadow(radius: 10)
                    }
                }
                FullWidthButton(titleKey: "CONCLUIR", action: onCommit)
                    .buttonStyle(.primary(isDisabled: causesSelected.isEmpty))
                    .disabled(causesSelected.isEmpty)
                    .padding(.bottom, 10)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(27.5)
        .background(Color.Style.grayDark)
        .ignoresSafeArea(.container, edges: .vertical)
    }
}

struct SocialCausesView_Previews: PreviewProvider {
    static var previews: some View {
        let causesPreview = [
            Cause(id: 0, cause: "MEIO AMBIENTE", iconUrl: ""),
            Cause(id: 1, cause: "ANIMAIS", iconUrl: ""),
            Cause(id: 2, cause: "CRIANÇAS", iconUrl: ""),
            Cause(id: 3, cause: "IDOSOS", iconUrl: ""),
            Cause(id: 4, cause: "EDUCAÇÃO", iconUrl: ""),
            Cause(id: 5, cause: "SAÚDE", iconUrl: ""),
            Cause(id: 6, cause: "MORADIA", iconUrl: ""),
            Cause(id: 7, cause: "ASSISTÊNCIA SOCIAL", iconUrl: ""),
            Cause(id: 8, cause: "OUTROS", iconUrl: "")
        ]
        
        Group {
            NavigationView {
                SocialCausesView(
                    loading: .none,
                    causes: causesPreview,
                    causesSelected: [
                        Cause(id: 1, cause: "ANIMAIS", iconUrl: ""),
                        Cause(id: 4, cause: "EDUCAÇÃO", iconUrl: ""),
                        Cause(id: 7, cause: "ASSISTÊNCIA SOCIAL", iconUrl: ""),
                        Cause(id: 8, cause: "OUTROS", iconUrl: "")
                    ],
                    onSelectCause: { _ in },
                    onDeselectCause: { _ in },
                    onCommit: { }
                )
                .navigationBarTitle("CAUSAS", displayMode: .inline)
            }
            .previewDevice("iPhone 11")
            
            NavigationView {
                SocialCausesView(
                    loading: .none,
                    causes: causesPreview,
                    causesSelected: [
                        Cause(id: 1, cause: "ANIMAIS", iconUrl: ""),
                        Cause(id: 4, cause: "EDUCAÇÃO", iconUrl: ""),
                        Cause(id: 7, cause: "ASSISTÊNCIA SOCIAL", iconUrl: ""),
                        Cause(id: 8, cause: "OUTROS", iconUrl: "")
                    ],
                    onSelectCause: { _ in },
                    onDeselectCause: { _ in },
                    onCommit: { }
                )
                .navigationBarTitle("CAUSAS", displayMode: .inline)
            }
            .previewDevice("iPhone SE (2nd generation)")
        }
        .preferredColorScheme(.dark)
    }
}

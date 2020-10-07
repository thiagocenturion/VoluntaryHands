//
//  RegisterDataView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 06/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct RegisterDataView: View {
    let onUploadImage: () -> Void
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            Spacer(minLength: 64) // Navigation
            Spacer(minLength: 20)
            
            ProfileImage(image: $inputImage, isEditable: true, action: { showingImagePicker = true })
                .sheet(isPresented: $showingImagePicker) { ImagePicker(image: self.$inputImage) }
        }
        .frame(maxWidth: .infinity)
        .padding(27.5)
        .background(Color.Style.grayDark)
        .ignoresSafeArea(.container, edges: .vertical)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

struct RegisterDataView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RegisterDataView(onUploadImage: {  })
                .navigationBarTitle("DADOS PESSOAIS", displayMode: .inline)
        }
        .preferredColorScheme(.dark)
    }
}

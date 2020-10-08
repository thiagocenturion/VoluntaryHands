//
//  ProfileImage.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 07/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct ProfileImage: View {
    
    @Binding var image: UIImage?
    let isEditable: Bool
    var action: (() -> Void)?
    
    var body: some View {
        Group {
            if isEditable {
                Button(action: { action?() }) {
                    ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
                        imageView
                        Image("cameraIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(15)
                            .background(LinearGradient.blue())
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .padding(.trailing, 40)
                            .frame(height: 50)
                    }
                }
            } else {
                imageView
            }
        }
    }
    
    var imageView: some View {
        Image(uiImage: image ?? UIImage(named: "pictureIcon")!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .background(Color.Style.grayMedium)
            .clipShape(Circle())
            .shadow(radius: 10)
            .overlay(Circle().stroke(Color.Style.gray, lineWidth: 5))
            .frame(width: 250, height: 160)
    }
}

struct ProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ProfileImage(image: .constant(nil), isEditable: true)
            ProfileImage(image: .constant(nil), isEditable: false)
            ProfileImage(image: .constant(UIImage(named: "pictureExample")), isEditable: true)
            ProfileImage(image: .constant(UIImage(named: "pictureExample")), isEditable: false)
        }
        .padding(.vertical, 1000)
        .padding(.horizontal, 100)
        .background(Color.Style.grayDark)
    }
}

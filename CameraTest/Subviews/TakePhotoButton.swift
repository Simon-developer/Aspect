//
//  TakePhotoButton.swift
//  CameraTest
//
//  Created by Semyon on 21.07.2020.
//  Copyright © 2020 Semyon. All rights reserved.
//

import SwiftUI

struct TakePhotoButton: View {
    // Градиенты для кнопки затвора
    let customGradient = LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .bottomLeading, endPoint: .topTrailing)
    let customGradient2 = LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .topTrailing , endPoint: .bottomLeading)
    
    var body: some View {
        Circle()
            .fill(customGradient)
            .frame(width: 85, height: 85)
            .overlay(Circle()
            .fill(customGradient2)
            .frame(width: 80, height: 80))
            .padding(.top)
    }
}
struct TakePhotoButton_Previews: PreviewProvider {
    static var previews: some View {
        TakePhotoButton()
    }
}

//
//  CustomCaptureController.swift
//  CameraTest
//
//  Created by Semyon on 21.07.2020.
//  Copyright © 2020 Semyon. All rights reserved.
//

import SwiftUI

struct CustomCaptureControl: View {
    let imageName: String
    var body: some View {
        Image(systemName: imageName)
            .foregroundColor(.pink)
            .shadow(radius: 3)
            .frame(width: 30, height: 30)
            .padding(10)
            .background(Color.white.opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 9))
    }
}

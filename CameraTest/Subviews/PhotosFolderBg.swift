//
//  FolderBg.swift
//  CameraTest
//
//  Created by Semyon on 25.07.2020.
//  Copyright © 2020 Semyon. All rights reserved.
//

import SwiftUI

struct PhotosFolderBg: View {
    @State private var allPhotosFolderBg: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.6), Color.white.opacity(0.4)]), startPoint: .top, endPoint: .bottom)
    var body: some View {
        Color.white.opacity(0.65).background(self.allPhotosFolderBg.cornerRadius(CameraConstants.bigPhotoCornerRadius))
    }
}

struct PhotosFolderBg_Previews: PreviewProvider {
    static var previews: some View {
        PhotosFolderBg()
    }
}

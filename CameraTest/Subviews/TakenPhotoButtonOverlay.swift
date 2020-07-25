//
//  TakenPhotoButtonOverlay.swift
//  CameraTest
//
//  Created by Semyon on 21.07.2020.
//  Copyright © 2020 Semyon. All rights reserved.
//

import SwiftUI

struct TakenPhotoButtonOverlay: View {
    var image: String
    var body: some View {
        Image(systemName: image)
            .foregroundColor(.black)
            .padding(14)
            .background(Color.white.opacity(0.65))
            .clipShape(Circle())
            .shadow(radius: 4)
    }
}


struct TakenPhotoButtonOverlay_Previews: PreviewProvider {
    static var previews: some View {
        TakenPhotoButtonOverlay(image: "checkmark.circle.fill")
    }
}

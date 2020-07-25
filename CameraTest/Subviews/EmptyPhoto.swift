//
//  EmptyPhoto.swift
//  CameraTest
//
//  Created by Semyon on 21.07.2020.
//  Copyright © 2020 Semyon. All rights reserved.
//

import SwiftUI

struct EmptyPhoto: View {
    var body: some View {
        Image("emptyPhoto")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 60, height: 90)
            .padding(10)
            .background(Color.white.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: CameraConstants.smallPhotoCornerRadius))
            .shadow(radius: 7)
    }
}

struct EmptyPhoto_Previews: PreviewProvider {
    static var previews: some View {
        EmptyPhoto()
    }
}

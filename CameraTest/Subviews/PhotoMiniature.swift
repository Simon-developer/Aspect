//
//  PhotoMiniature.swift
//  CameraTest
//
//  Created by Semyon on 25.07.2020.
//  Copyright © 2020 Semyon. All rights reserved.
//

import SwiftUI

struct PhotoMiniature: View {
    @ObservedObject var setup: CameraSetup
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                if self.setup.takenPhotos.count >= 1 {
                    Image(uiImage: self.setup.takenPhotos.first!)
                } else {
                    EmptyPhoto()
                }
                Spacer()
            }
        }
    }
}

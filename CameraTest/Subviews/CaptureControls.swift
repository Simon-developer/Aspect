//
//  CaptureControls.swift
//  CameraTest
//
//  Created by Semyon on 25.07.2020.
//  Copyright © 2020 Semyon. All rights reserved.
//

import SwiftUI

struct CaptureControls: View {
    weak var parent: ViewController?
    
    @ObservedObject var setup: CameraSetup
    
    var body: some View {
        // Управление процессом съемки - кнопки затвора, вспышки и т.д.
        VStack {
            Spacer()
            ZStack {
                Color.pink.edgesIgnoringSafeArea(.all)
                TakePhotoButton().onTapGesture { if self.setup.takePhotoButtonIsEnabled { self.parent?.takePhoto() }  }
                VStack {
                    HStack {
                        CustomCaptureControl(imageName: "pencil.and.outline")
                        Spacer()
                        CustomCaptureControl(imageName: "camera.rotate").onTapGesture { if let parentView = self.parent { parentView.switchCameraInput() } }
                    }
                    Spacer()
                    HStack {
                        CustomCaptureControl(imageName: "wand.and.stars")
                        Spacer()
                        CustomCaptureControl(imageName: self.setup.flashlightIcon).onTapGesture { if let parentView = self.parent { parentView.switchFlash() }}
                    }
                }.padding(.all)
            }.frame(height: CameraConstants.controllBarHeight)
        }.edgesIgnoringSafeArea(.bottom)
    }
}

//
//  CaptureController.swift
//  CameraTest
//
//  Created by Semyon on 10.07.2020.
//  Copyright © 2020 Semyon. All rights reserved.
//

import SwiftUI
import AVFoundation

class CaptureControllerDelegate: ObservableObject {
//    @Published var showFolderBlur: Bool = false
    
}

struct CaptureController: View {
    let customGradient = LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .bottomLeading, endPoint: .topTrailing)
    let customGradient2 = LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .topTrailing , endPoint: .bottomLeading)
    
    @ObservedObject var delegate: CaptureControllerDelegate
    weak var parent: ViewController?
    
    var flashLightIcon: String = "bolt.fill"
    var takePhotoButtonIsEnabled: Bool = true
    
//    var showFolderBlur: Bool = false
    
    var body: some View {
        ZStack {
            Color.pink.edgesIgnoringSafeArea(.all)
            Circle()
                .fill(customGradient)
                .frame(width: 85, height: 85)
                .overlay(Circle()
                .fill(customGradient2)
                .frame(width: 80, height: 80))
                .padding(.top)
                .onTapGesture {
                    if self.takePhotoButtonIsEnabled {
                        if let parentView = self.parent {
                            parentView.takePhoto()
                        }
                    }
                }
            
            VStack {
                HStack {
                    CustomCaptureControl(imageName: "pencil.and.outline")
                    Spacer()
                    CustomCaptureControl(imageName: "camera.rotate")
                        .onTapGesture {
                            if let parentView = self.parent {
                                parentView.switchCameraInput()
                            }
                        }
                }
                Spacer()
                HStack {
                    CustomCaptureControl(imageName: "wand.and.stars")
                    Spacer()
                    CustomCaptureControl(imageName: self.flashLightIcon)
                        .onTapGesture {
                            if let parentView = self.parent {
                                parentView.switchFlash()
                            }
                        }
                }
            }
            .padding([.horizontal, .top])
//            .disabled(self.showFolderBlur)
            
//            // БЛЮР ПОВЕРХ
//            // появляется при тапе пользователя по папке фото
//            if self.showFolderBlur {
//                Color.green
//                    .opacity(0.4)
//                    .edgesIgnoringSafeArea(.all)
//                    .onTapGesture {
//                        print("tapped down blur")
//                        self.parent?.cameraHeader.rootView.toggleFolder()
//                }
//            }
        }
    }
    mutating func changeFlashLightIcon(toImage image: String) {
        self.flashLightIcon = image
    }
//    mutating func toggleTopFolderBlur() {
//        print("HellOOOOOOO")
//        self.showFolderBlur.toggle()
//    }
}

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

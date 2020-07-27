//
//  CameraSetup.swift
//  CameraTest
//
//  Created by Semyon on 23.07.2020.
//  Copyright © 2020 Semyon. All rights reserved.
//
import Foundation
import SwiftUI
import Combine

class CameraSetup: ObservableObject {
    @Published var takenPhotos: [UIImage] = []
    @Published var showAllPhotos: Bool = false
    @Published var photos: [UIImage] = []
    @Published var flashlightIcon: String = "bolt.fill"
    @Published var closeCamera: Bool = false
    @Published var takePhotoButtonIsEnabled: Bool = true
    @Published var currentlyDragging: Int = -1
    @Published var offsetY: CGFloat = 0
    
    func removePhoto(at index: Int) {
        self.takenPhotos.remove(at: index)
    }
}

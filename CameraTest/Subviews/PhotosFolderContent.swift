//
//  TakenPhotosHStack.swift
//  CameraTest
//
//  Created by Semyon on 21.07.2020.
//  Copyright © 2020 Semyon. All rights reserved.
//

import SwiftUI

struct PhotosFolderContent: View {
    @ObservedObject var setup: CameraSetup
    @State private var offsetY: CGFloat = 0
    
    @ViewBuilder
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<self.setup.takenPhotos.count, id: \.self) { index in
                    if index > 0 {
                        ZStack {
                            // Под основным фото, крест либо галочка
                            // показывается во время свайпа фото
                            UnderlyingXmark()
                            // Основная фотография
                            PhotoInFolderView(setup: self.setup, index: index)
                        }
                    }
                }
            }.padding(.trailing)
        }
    }
    func removePhoto(at index: Int) {
        self.setup.takenPhotos.remove(at: index)
    }
}

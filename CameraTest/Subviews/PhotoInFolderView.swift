//
//  PhotoInFolderView.swift
//  CameraTest
//
//  Created by Semyon on 27.07.2020.
//  Copyright © 2020 Semyon. All rights reserved.
//

import SwiftUI

struct PhotoInFolderView: View {
    @ObservedObject var setup: CameraSetup
    var index: Int
    @State private var offsetY: CGFloat = 0
    var body: some View {
        if self.setup.takenPhotos.indices.contains(index) {
            Image(uiImage: self.setup.takenPhotos[index])
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(CameraConstants.bigPhotoCornerRadius)
                .padding(.vertical, 10)
                .frame(maxHeight: CameraConstants.photosFolderHeight)
                .frame(maxWidth: CameraConstants.photosFolderWidth)
                .overlay(
                    VStack {
                        HStack (spacing: 3) {
                            Button(action: {
                            self.setup.currentlyDragging = index
                            withAnimation {
                                self.offsetY = -2000
                            }
                            self.setup.removePhoto(at: index)
                            self.setup.currentlyDragging = -1
                                self.offsetY = 0
                            }) {
                                TakenPhotoButtonOverlay(image: "xmark.circle")
                            }
                            Button(action: {}) {
                                TakenPhotoButtonOverlay(image: "square.and.arrow.down")
                            }
                            Button(action: {}) {
                                TakenPhotoButtonOverlay(image: "wand.and.stars")
                            }
                            Spacer()
                        }.padding(15)
                        Spacer()
                    })
                .offset(x: 0, y: self.setup.currentlyDragging == index ? self.offsetY : 0)
                .padding(.leading, 10)
                .gesture(DragGesture(minimumDistance: 15, coordinateSpace: .local)
                    .onChanged { value in
                        let distance = value.translation.height
                        self.setup.currentlyDragging = index
                        if distance < 0 {
                            self.offsetY = distance * 2
                        } else {
                            self.offsetY = distance / 3
                        }
                    }
                    .onEnded { value in
                        self.setup.currentlyDragging = -1
                        self.offsetY = 0
                        if value.translation.height < -150 {
                            self.setup.removePhoto(at: index)
                            if self.setup.takenPhotos.count == 0 {
                                withAnimation {
                                    self.setup.showAllPhotos.toggle()
                                }
                            }
                        } else {
                            withAnimation {
                                self.offsetY = 0
                            }
                        }
                    }
             )
        }
    }
}

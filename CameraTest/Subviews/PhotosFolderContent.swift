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
    @State private var picOpacity: Double = 1.0
    @State private var symbolOpacity: Double = 0.0
    @State private var allSwipedIndexes = Set<Int>()
    @State private var imageWhileDrag: String = "xmark.circle.fill"
    @State private var imageWhileDragColor: Color = .red
    @ViewBuilder
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<self.setup.takenPhotos.count, id: \.self) { index in
                    ZStack {
                        // Под основным фото, крест либо галочка
                        // показывается во время свайпа фото
                        Image(systemName: self.imageWhileDrag)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(self.imageWhileDragColor)
                            .opacity(self.allSwipedIndexes.contains(index) ? self.symbolOpacity : 0)
                            .shadow(radius: 5)
                        // Основная фотография
                        Image(uiImage: self.setup.takenPhotos[index])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: CameraConstants.photoInFolderMaxWidth)
                            .cornerRadius(CameraConstants.bigPhotoCornerRadius)
                            .overlay(
                                VStack {
                                    HStack (spacing: 3) {
                                        Button(action: {
                                            self.allSwipedIndexes.insert(index)
                                            self.offsetY = -150
                                            self.picOpacity = 0.0
                                            self.removePhoto(at: index)
                                            self.allSwipedIndexes.remove(index)
                                            self.offsetY = 0
                                            self.picOpacity = 1.0
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
                                    }.padding(5)
                                    Spacer()
                                })
                            .opacity(self.allSwipedIndexes.contains(index) ? self.picOpacity : 1.0)
                            .offset(x: 0, y: self.allSwipedIndexes.contains(index) ? self.offsetY : 0)
                            .padding(10)
                            .animation(.easeOut)
                            .gesture(DragGesture(minimumDistance: 15, coordinateSpace: .local)
                                .onChanged { value in
                                    let distance = value.translation.height
                                    self.imageWhileDrag = distance > 0 ? "checkmark.circle.fill" : "xmark.circle.fill"
                                    self.imageWhileDragColor = distance > 0 ? .green : .red
                                    self.allSwipedIndexes.insert(index)
                                    self.offsetY = distance * 2
                                    self.picOpacity = 30.123 / abs(Double(distance))
                                    self.symbolOpacity = abs(Double(distance)) / 300
                                }
                                .onEnded { value in
                                    self.allSwipedIndexes.remove(index)
                                    self.offsetY = 0
                                    self.picOpacity = 1.0
                                    self.symbolOpacity = 0.0
                                    if value.translation.height < -150 {
                                        self.removePhoto(at: index)
                                    }
                                }
                        )
                    }
                }
            }
        }
    }
    func removePhoto(at index: Int) {
        self.setup.takenPhotos.remove(at: index)
    }
}

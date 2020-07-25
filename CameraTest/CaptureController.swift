//
//  CaptureController.swift
//  CameraTest
//
//  Created by Semyon on 10.07.2020.
//  Copyright © 2020 Semyon. All rights reserved.
//

import SwiftUI

struct CaptureController: View {

    @ObservedObject var setup: CameraSetup
    
    weak var parent: ViewController?
    
    var takePhotoButtonIsEnabled: Bool = true
    
    var body: some View {
        ZStack {
            // Основные элементы управления
            
            
            if self.setup.showAllPhotos {
                // Слой - размытие задника
                BlurLayer()
                    .onTapGesture { self.setup.showAllPhotos.toggle() }
                // Слой - градиентный фон папки с фото
                PhotosFolderBg()
                    .frame(width: CameraConstants.photosFolderWidth, height: CameraConstants.photosFolderHeight)
                // Слой - фотографии
                PhotosFolderContent(setup: self.setup)
                // Слой - заголовок папки и общие кнопки
                PhotosFolderControls(setup: self.setup)
            }
        }
    }
//    mutating func setPhotoToShow(photo: UIImage) {
//        self.photoToShow = Image(uiImage: photo)
//    }
//    // Анимация новой фотографии
//    var photoToShow:                      Image?  = nil
//    @State var prevPhoto:                 Image?
//    @State private var takenPhotoOpacity: Double  = 0.0
//    @State private var takenPhotoOffsetX: CGFloat = 0
//    @State private var takenPhotoOffsetY: CGFloat = -CameraConstants.controllBarHeight / 2
//    @State private var takenPhotoWidth:   CGFloat = .infinity
//    @State private var takenPhotoHeight:  CGFloat = UIScreen.main.bounds.size.height - CameraConstants.controllBarHeight
//
//    // Анимация открытия папки фотографий
//    @State private var allPhotosFolderBg: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.6), Color.white.opacity(0.4)]), startPoint: .top, endPoint: .bottom)
//    @State private var allPhotosFolderWidth: CGFloat              = 80
//    @State private var allPhotosFolderHeight: CGFloat             = 110
//    @State private var allPhotosFolderTappableAreaWidth: CGFloat  = 80
//    @State private var allPhotosFolderTappableAreaHeight: CGFloat = 110
//
//    var flashLightIcon: String = "bolt.fill"
//    var takePhotoButtonIsEnabled: Bool = true
//
//    var body: some View {
//        ZStack {
//            // Кнопка возврата на предыдущую страницу
//            VStack {
//                HStack(alignment: .top) {
//                    BackButton().onTapGesture { self.parent?.dismiss(animated: true) }
//                    Spacer()
//                }.animation(.default).padding(.horizontal, 15)
//                Spacer()
//            }
//            // Управление процессом съемки - кнопки затвора, вспышки и т.д.
//            VStack {
//                Spacer()
//                ZStack {
//                    Color.pink.edgesIgnoringSafeArea(.all)
//                    TakePhotoButton().onTapGesture { if self.takePhotoButtonIsEnabled { self.parent?.takePhoto() }  }
//                    VStack {
//                        HStack {
//                            CustomCaptureControl(imageName: "pencil.and.outline")
//                            Spacer()
//                            CustomCaptureControl(imageName: "camera.rotate").onTapGesture { if let parentView = self.parent { parentView.switchCameraInput() } }
//                        }
//                        Spacer()
//                        HStack {
//                            CustomCaptureControl(imageName: "wand.and.stars")
//                            Spacer()
//                            CustomCaptureControl(imageName: self.flashLightIcon).onTapGesture { if let parentView = self.parent { parentView.switchFlash() }}
//                        }
//                    }.padding(.all)
//                }.frame(height: CameraConstants.controllBarHeight)
//            }.edgesIgnoringSafeArea(.bottom)
//            // ФОН С БЛЮРОМ ДЛЯ ПАПКИ ФОТО
//            // Если пользователь выбрал показывать все сделанные фотографии,
//            // показываю фон с блюром визора
//            // При тапе скрываю блюр сверху, блюр в captureController
//            if self.setup.showAllPhotos {
//                BlurLayer().opacity(self.setup.showAllPhotos ? 0.75 : 0.0).animation(.easeIn).onTapGesture { self.toggleFolder() }
//            }
//            // Миниатюры справа в верхнем углу
//            VStack {
//                HStack {
//                    Spacer()
//                    ZStack {
//                        EmptyPhoto().opacity(self.setup.showAllPhotos ? 0.0 : 1.0)
//                        if self.prevPhoto != nil && self.parent != nil {
//                            self.prevPhoto!
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 80, height: 110)
//                                .clipShape(RoundedRectangle(cornerRadius: CameraConstants.smallPhotoCornerRadius))
//                                .shadow(radius: 7)
//                                .animation(.default)
//                                .opacity(self.setup.showAllPhotos ? 0.0 : 1.0)
//                            // Контейнер всех фоток
//                            ZStack {
//                                // Фон папки полупрозрачный
//                                Color.green.opacity(0.0)
//                                    .background(self.allPhotosFolderBg.cornerRadius(self.setup.showAllPhotos
//                                        ? CameraConstants.bigPhotoCornerRadius
//                                        : CameraConstants.smallPhotoCornerRadius))
//                                    .opacity(self.setup.showAllPhotos ? 1 : 0.001)
//                                    .onTapGesture { self.toggleFolder() }
//                                // Показываем все фотки в папке
//                                TakenPhotosHStack(parent: self.parent!, prevPhoto: self.$prevPhoto, setup: self.setup)
//                                    .opacity(self.setup.showAllPhotos ? 1 : 0)
//                            }.frame(width: self.allPhotosFolderWidth, height: self.allPhotosFolderHeight)
//                        }
//                    }
//                }.animation(.default).padding(.trailing, 15)
//                Spacer()
//            }
//            // АНИМИРОВАННЫЙ ПЕРЕХОД НОВОГО СНИМКА
//            if self.photoToShow != nil && self.photoToShow != self.prevPhoto  {
//                self.showPhoto()
//            }
//        }.background(Color.clear)
//    }
//    func toggleFolder() {
//        self.setup.showAllPhotos.toggle()
//        if self.allPhotosFolderWidth == 80 {
//            self.allPhotosFolderWidth = UIScreen.main.bounds.size.width - 30
//            self.allPhotosFolderHeight = 500
//        } else {
//            self.allPhotosFolderWidth = 80
//            self.allPhotosFolderHeight = 110
//        }
//    }
//    func showPhoto() -> some View {
//        return photoToShow!
//            .resizable()
//            .frame(maxWidth: self.takenPhotoWidth, maxHeight: self.takenPhotoHeight)
//            .cornerRadius(CameraConstants.bigPhotoCornerRadius)
//            .opacity(self.takenPhotoOpacity)
//            .offset(x: self.takenPhotoOffsetX, y: self.takenPhotoOffsetY)
//            .onAppear {
//                withAnimation(Animation.easeIn(duration: 0.5)) {
//                    // Начало анимации перехода вверх
//                    self.takenPhotoOffsetX = (UIScreen.main.bounds.size.width / 2) - 40 - 15
//                    self.takenPhotoOffsetY = -((UIScreen.main.bounds.size.height) / 2) + (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + 40
//                    self.takenPhotoWidth = 80
//                    self.takenPhotoHeight = 110
//                    self.takenPhotoOpacity = 0.0
//                }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
//                    // Присваиваем только что показанное фото как иконку перехода
//                    // В сделанные снимки
//                    self.prevPhoto = self.photoToShow
//                    self.takenPhotoOffsetX = 0
//                    self.takenPhotoOffsetY = -CameraConstants.controllBarHeight
//                    self.takenPhotoWidth = .infinity
//                    self.takenPhotoHeight = UIScreen.main.bounds.size.height - CameraConstants.controllBarHeight
//                    self.takenPhotoOpacity = 1.0
//                }
//            }
//    }
//    mutating func setPhotoToShow(photo: UIImage) {
//        self.photoToShow = Image(uiImage: photo)
//    }
//    mutating func changeFlashLightIcon(toImage image: String) {
//        self.flashLightIcon = image
//    }
}

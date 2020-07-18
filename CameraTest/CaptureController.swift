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
    
    @ObservedObject var delegate: CaptureControllerDelegate
    
    weak var parent: ViewController?
    
    // Кнопка навигации
    let image:       String
    let text:        String
    
    // Анимация новой фотографии
    var photoToShow:                      Image?  = nil
    @State var prevPhoto:                 Image?
    @State private var takenPhotoOpacity: Double  = 0.0
    @State private var takenPhotoOffsetX: CGFloat = 0
    @State private var takenPhotoOffsetY: CGFloat = 0
    @State private var takenPhotoWidth:   CGFloat = .infinity
    @State private var takenPhotoHeight:  CGFloat = .infinity
    
    // Анимация открытия папки фотографий
    @State private var opaqueGradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color.white, Color.white.opacity(0.4)]), startPoint: .top, endPoint: .bottom)
    @State private var showAllPhotos: Bool                        = false
    @State private var allPhotosFolderWidth: CGFloat              = 80
    @State private var allPhotosFolderHeight: CGFloat             = 110
    @State private var allPhotosFolderTappableAreaWidth: CGFloat  = 80
    @State private var allPhotosFolderTappableAreaHeight: CGFloat = 110
    
    var flashLightIcon: String = "bolt.fill"
    var takePhotoButtonIsEnabled: Bool = true
    
    var body: some View {
        ZStack {
            // Кнопка возврата на предыдущую страницу
            VStack {
                HStack(alignment: .top) {
                    BackButton(image: self.image, text: self.text) .onTapGesture { self.parent?.dismiss(animated: true) }
                    Spacer()
                }.animation(.default).padding(.horizontal, 15)
                Spacer()
            }
            // Миниатюры справа в верхнем углу
            VStack {
                HStack {
                    Spacer()
                    ZStack {
                        EmptyPhoto().opacity(self.showAllPhotos ? 0.0 : 1.0)
                        if self.prevPhoto != nil {
                            self.prevPhoto!
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 110)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(radius: 7)
                                .animation(.default)
                                .opacity(self.showAllPhotos ? 0.0 : 1.0)
                            // Контейнер всех фоток
                            Color.green
                                .background(self.opaqueGradient.cornerRadius(self.showAllPhotos ? 24 : 12))
                                .frame(width: self.allPhotosFolderWidth, height: self.allPhotosFolderHeight)
                                .opacity(self.showAllPhotos ? 1 : 0.001)
                                .onTapGesture { self.toggleFolder() }
                        }
                    }
                }.animation(.default).padding(.trailing, 15)
                Spacer()
            }

            // ФОН С БЛЮРОМ ДЛЯ ПАПКИ ФОТО
            // Если пользователь выбрал показывать все сделанные фотографии,
            // показываю фон с блюром визора
            // При тапе скрываю блюр сверху, блюр в captureController
            if self.showAllPhotos {
                BlurLayer().opacity(self.showAllPhotos ? 0.4 : 0.0).onTapGesture { self.toggleFolder() }
            }
            // АНИМИРОВАННЫЙ ПЕРЕХОД НОВОГО СНИМКА
            if self.photoToShow != nil && self.photoToShow != self.prevPhoto  {
                self.showPhoto()
            }
            // Управление процессом съемки - кнопки затвора, вспышки и т.д.
            VStack {
                Spacer()
                ZStack {
                    Color.pink.edgesIgnoringSafeArea(.all)
                    TakePhotoButton().onTapGesture { if self.takePhotoButtonIsEnabled { if let parentView = self.parent { parentView.takePhoto() } }  }
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
                            CustomCaptureControl(imageName: self.flashLightIcon).onTapGesture { if let parentView = self.parent { parentView.switchFlash() }}
                        }
                    }.padding(.all)
                }.frame(height: CameraConstants.controllBarHeight)
                }.edgesIgnoringSafeArea(.bottom).zIndex(999)
        }.background(Color.clear)
    }
    func toggleFolder() {
//        if let myParent = self.parent {
//            myParent.captureController.rootView.toggleTopFolderBlur()
//        }
        self.showAllPhotos.toggle()
        if self.allPhotosFolderWidth == 80 {
            self.allPhotosFolderWidth = UIScreen.main.bounds.size.width - 30
            self.allPhotosFolderHeight = 500
        } else {
            self.allPhotosFolderWidth = 80
            self.allPhotosFolderHeight = 110
        }
    }
    func showPhoto() -> some View {
        return photoToShow!
            .resizable()
            .frame(maxWidth: self.takenPhotoWidth, maxHeight: self.takenPhotoHeight)
            .cornerRadius(25)
            .opacity(self.takenPhotoOpacity)
            .offset(x: self.takenPhotoOffsetX, y: self.takenPhotoOffsetY)
            .onAppear {
                withAnimation(Animation.easeIn(duration: 0.5)) {
                    // Начало анимации перехода вверх
                    self.takenPhotoOffsetX = (UIScreen.main.bounds.size.width / 2) - 40 - 15
                    self.takenPhotoOffsetY = -((UIScreen.main.bounds.size.height - CameraConstants.controllBarHeight) / 2) + (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + 30
                    self.takenPhotoWidth = 80
                    self.takenPhotoHeight = 110
                    self.takenPhotoOpacity = 0.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                    // Присваиваем только что показанное фото как иконку перехода
                    // В сделанные снимки
                    self.prevPhoto = self.photoToShow
                    self.takenPhotoOffsetX = 0
                    self.takenPhotoOffsetY = 0
                    self.takenPhotoWidth = .infinity
                    self.takenPhotoHeight = .infinity
                    self.takenPhotoOpacity = 1.0
                }
            }
    }
    mutating func setPhotoToShow(photo: UIImage) {
        self.photoToShow = Image(uiImage: photo)
    }
    mutating func changeFlashLightIcon(toImage image: String) {
        self.flashLightIcon = image
    }
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
struct BlurLayer: View {
    var body: some View {
        Color.green
        .edgesIgnoringSafeArea(.all)
    }
}
struct BackButton: View {
    let image: String
    let text: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: image)
                .foregroundColor(.white)
                .font(.headline)
            Text(text)
                .foregroundColor(.white)
                .font(.headline)
        }
        .padding(10)
        .background(Color.pink.opacity(0.6))
        .clipShape(Capsule())
        .shadow(radius: 5)
    }
}
struct EmptyPhoto: View {
    var body: some View {
        Image("emptyPhoto")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 60, height: 90)
            .padding(10)
            .background(Color.white.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 7)
    }
}
struct TakePhotoButton: View {
    // Градиенты для кнопки затвора
    let customGradient = LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .bottomLeading, endPoint: .topTrailing)
    let customGradient2 = LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .topTrailing , endPoint: .bottomLeading)
    
    var body: some View {
        Circle()
            .fill(customGradient)
            .frame(width: 85, height: 85)
            .overlay(Circle()
            .fill(customGradient2)
            .frame(width: 80, height: 80))
            .padding(.top)
    }
}

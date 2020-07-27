//
//  PhotosFolderControls.swift
//  CameraTest
//
//  Created by Semyon on 25.07.2020.
//  Copyright © 2020 Semyon. All rights reserved.
//

import SwiftUI

struct PhotosFolderControls: View {
    /*
    Заголовок и кнопки управления
    в папке только что снятых фото
    */
    
    @ObservedObject var setup: CameraSetup
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                CapsuleTitle(text: "Сделанные фото")
                    .offset(y: -100)
                Spacer()
                HStack (spacing: 10) {
                    Button(action: {}) {
                        BigActionButton(image: "xmark.circle.fill", text: "Удалить все")
                            .onTapGesture {
                                self.setup.takenPhotos.removeAll()
                                withAnimation  {
                                    self.setup.showAllPhotos = false
                                }
                            }
                    }
                    Button(action: {}) {
                    BigActionButton(image: "checkmark.circle.fill", text: "Сохранить все")
                        .onTapGesture {
                            /*
                                Сохраняем все фото в библиотеку пользователя
                                ЗАКРЫВАЕМ ПАПКУ С АЛЕРТОМ, ЧТО ВСЕСОХРАНЕНО
                                */
                        }
                    }
                }.offset(y: 100).padding()
            }
            Spacer()
        }
    }
}

struct PhotosFolderControls_Previews: PreviewProvider {
    static var previews: some View {
        PhotosFolderControls(setup: CameraSetup())
    }
}

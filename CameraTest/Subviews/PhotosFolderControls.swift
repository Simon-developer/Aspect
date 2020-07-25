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
             VStack(alignment: .leading) {
                 CapsuleTitle(text: "Сделанные фото")
                 Spacer()
                 HStack (spacing: 10) {
                     Button(action: {}) {
                         BigActionButton(image: "xmark.circle.fill", text: "Удалить все")
                             .onTapGesture {
                                 /*
                                 Удаляем все фото из массива в setup
                                 ЗАКРЫВАЕМ ПАПКУ
                                 */
                                 self.setup.showAllPhotos = false
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
                 }.padding([.leading, .bottom])
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

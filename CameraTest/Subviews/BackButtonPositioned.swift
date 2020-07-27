//
//  BackButtonPositioned.swift
//  CameraTest
//
//  Created by Semyon on 25.07.2020.
//  Copyright © 2020 Semyon. All rights reserved.
//

import SwiftUI

struct BackButtonPositioned: View {
    weak var parent: ViewController?
    
    var body: some View {
        //Кнопка возврата на предыдущую страницу
        VStack {
            HStack(alignment: .top) {
                BackButton()
                    .onTapGesture {
                        self.parent?.dismiss(animated: true)
                    }
                Spacer()
            }.padding(.horizontal, 15)
            Spacer()
        }
    }
}

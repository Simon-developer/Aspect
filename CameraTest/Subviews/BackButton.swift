//
//  BackButton.swift
//  CameraTest
//
//  Created by Semyon on 21.07.2020.
//  Copyright © 2020 Semyon. All rights reserved.
//

import SwiftUI

struct BackButton: View {
    let image: String = "chevron.left"
    let text: String  = "Назад"
    
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

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton()
    }
}

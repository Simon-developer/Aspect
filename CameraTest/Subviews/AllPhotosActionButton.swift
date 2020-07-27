//
//  AllPhotosActionButton.swift
//  CameraTest
//
//  Created by Semyon on 21.07.2020.
//  Copyright © 2020 Semyon. All rights reserved.
//

import SwiftUI

struct BigActionButton: View {
    let image: String
    let text: String
    var picColor: Color {
        if image.contains("xmark") {
            return .red
        } else {
            return .green
        }
    }
    
    var body: some View {
        HStack (spacing: 10) {
            Image(systemName: image)
                .foregroundColor(picColor)
                .shadow(radius: 0)
            Text(text)
                .font(.caption)
                .foregroundColor(Color.white.opacity(0.7))
                .shadow(radius: 0)
        }
        .padding()
        .background(Color.black)
        .clipShape(Capsule())
    }
}

struct BigActionButton_Previews: PreviewProvider {
    static var previews: some View {
        BigActionButton(image: "checkmark.circle", text: "Сохранить")
    }
}

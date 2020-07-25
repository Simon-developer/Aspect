//
//  CapsuleTitle.swift
//  CameraTest
//
//  Created by Semyon on 21.07.2020.
//  Copyright © 2020 Semyon. All rights reserved.
//

import SwiftUI

struct CapsuleTitle: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundColor(Color.black.opacity(0.7))
            .padding()
            .background(Color.white.opacity(0.5))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black.opacity(0.3), lineWidth: 1))
            .padding()
    }
}

struct CapsuleTitle_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleTitle(text: "текст текст")
    }
}

//
//  UnderlyingXmark.swift
//  CameraTest
//
//  Created by Semyon on 27.07.2020.
//  Copyright © 2020 Semyon. All rights reserved.
//

import SwiftUI

struct UnderlyingXmark: View {
    var body: some View {
        Image(systemName: "xmark.circle.fill")
            .resizable()
            .frame(width: 100, height: 100)
            .foregroundColor(.red)
            .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 0)
    }
}

struct UnderlyingXmark_Previews: PreviewProvider {
    static var previews: some View {
        UnderlyingXmark()
    }
}

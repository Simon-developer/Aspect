//
//  BlurLayer.swift
//  CameraTest
//
//  Created by Semyon on 21.07.2020.
//  Copyright © 2020 Semyon. All rights reserved.
//

import SwiftUI

struct BlurLayer: View {
    var body: some View {
        Color.black.opacity(0.75)
        .edgesIgnoringSafeArea(.all)
    }
}
struct BlurLayer_Previews: PreviewProvider {
    static var previews: some View {
        BlurLayer()
    }
}

//
//  MapARViewRepresentable.swift
//  BearBurp
//
//  Created by Haoran Song on 11/2/22.
//

import SwiftUI

struct MapARViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> MapARView {
        return MapARView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}

//
//  MapViewController.swift
//  BearBurp
//
//  Created by Haoran Song on 11/2/22.
//

import SwiftUI

class MapViewController: UIHostingController<MapView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: MapView())
    }
}

struct MapView: View {
    var body: some View {
//        Color.white.edgesIgnoringSafeArea(.all)
//        Text("Hello world!")
//            .padding()
        MapARViewRepresentable()
            .ignoresSafeArea()
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

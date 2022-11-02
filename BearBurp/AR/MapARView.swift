//
//  ARView.swift
//  BearBurp
//
//  Created by Haoran Song on 11/2/22.
//

import ARKit
import RealityKit
import SwiftUI

class MapARView: ARView {
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
    
    dynamic required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        placeBlueBlock()
    }
    
    func placeBlueBlock(){
        let block = MeshResource.generateBox(size: 0.5)
        let material = SimpleMaterial(color: .blue, isMetallic: false)
        let entity = ModelEntity(mesh: block, materials: [material])
        
//        let anchor = AnchorEntity(plane: .horizontal)
        let anchor = AnchorEntity()
        anchor.addChild(entity)
        
        scene.addAnchor(anchor)
        
    }
    
}

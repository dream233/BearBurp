//
//  MapViewController.swift
//  BearBurp
//
//  Created by Haoran Song on 11/3/22.
//

import UIKit
import CoreLocation
import MapKit
import HDAugmentedReality
import GoogleMaps

class MapViewController: UIViewController{
    fileprivate var arViewController: ARViewController!

    @IBAction func arClicked(_ sender: Any) {
//        arViewController = ARViewController()
//        //1
//        arViewController.dataSource = self
        //2
//        arViewController.maxVisibleAnnotations = 30
//        arViewController.headingSmoothingFactor = 0.05
        //3
//        let loc = CLLocation(latitude: 38.64983848424796, longitude: -90.3108174606938)
//        let place = Place(location: loc, rate: "", name: "Knight Hall", address: "")
//        arViewController.setAnnotations([place])
//
//        self.present(arViewController, animated: true, completion: nil)

    }
    
//    fileprivate let locationManager = CLLocationManager()
//
//    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//        locationManager.startUpdatingLocation()
//        locationManager.requestWhenInUseAuthorization()
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView

    }

    
    

}

//extension MapViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//      //1
//      if locations.count > 0 {
//        let location = locations.last!
////        print("Accuracy: \(location.horizontalAccuracy)")
//
//        //2 精度小于100米就停止更新
//        if location.horizontalAccuracy < 100 {
//          //3
//          manager.stopUpdatingLocation()
//        // 经纬度跨度
//          let span = MKCoordinateSpan(latitudeDelta: 0.014, longitudeDelta: 0.014)
//          let region = MKCoordinateRegion(center: location.coordinate, span: span)
//          mapView.region = region
//          // More code later...
//        }
//      }
//    }
//
//}

//extension MapViewController: ARDataSource {
//  func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
//      let annotationView = AnnotationView()
//      annotationView.annotation = viewForAnnotation
//      annotationView.delegate = self
//      annotationView.backgroundColor = .white
//      annotationView.layer.cornerRadius = 10
//      annotationView.layer.borderWidth = 1
//      annotationView.layer.borderColor = UIColor(named: "black")?.cgColor
//      annotationView.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
//      return annotationView
//  }
//}
//extension MapViewController: AnnotationViewDelegate {
//    func didTouch(annotationView: AnnotationView) {
//
//    }
//}


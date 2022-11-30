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

class MapViewController: UIViewController, CLLocationManagerDelegate{
    fileprivate var arViewController: ARViewController!
    @IBOutlet weak var mapViewContainer: UIView!
    var googleMapsView:GMSMapView!
    var theData : restaurantAPIData?
    var list: [Place]? = []
    var locationManager = CLLocationManager()
    
    
    func getDataFromMysql(){
        var url:URL?
        url = URL(string: "http://3.86.178.119/~Charles/CSE438-final/fetchdata.php?&query=")
        let data = try! Data(contentsOf: url!)
        theData = try! JSONDecoder().decode(restaurantAPIData.self,from:data)
    }
    
    @IBAction func arBtnClicked(_ sender: Any) {
        arViewController = ARViewController()
        arViewController.dataSource = self
        getDataFromMysql()
        for s in theData?.message ?? []{
            let lat = CLLocationDegrees(s.latitude)
            let lon = CLLocationDegrees(s.longitude)
            let name = s.name
            let loc = CLLocation(latitude: lat, longitude: lon)
            let id = s.id
            let place = Place(location: loc, rate: s.rating, name: name, address: "",id: id)
            list?.append(place)
        }
        arViewController.setAnnotations(list ?? [])
        self.present(arViewController, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        googleMapsView = GMSMapView (frame: self.mapViewContainer.frame)
        googleMapsView.isMyLocationEnabled = true
        googleMapsView.settings.compassButton = true
        googleMapsView.settings.myLocationButton = true
        googleMapsView.mapType = .normal
        self.view.addSubview(googleMapsView)
//        self.view.addSubview(mapView)
        
        
//        gmsFetcher = GMSAutocompleteFetcher()
//        gmsFetcher.delegate = self
              

        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)

        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 15);
        self.googleMapsView.camera = camera
        self.googleMapsView.isMyLocationEnabled = true

        let marker = GMSMarker(position: center)

        print("Latitude :- \(userLocation!.coordinate.latitude)")
        print("Longitude :-\(userLocation!.coordinate.longitude)")
        marker.map = self.googleMapsView

        marker.title = "Current Location"
        locationManager.stopUpdatingLocation()
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

extension MapViewController: ARDataSource {
  func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
      let annotationView = AnnotationView()
      annotationView.annotation = viewForAnnotation
      annotationView.delegate = self
      annotationView.backgroundColor = .white
      annotationView.layer.cornerRadius = 10
      annotationView.layer.borderWidth = 1
      annotationView.layer.borderColor = UIColor(named: "black")?.cgColor
      annotationView.frame = CGRect(x: 0, y: 0, width: 200, height: 55)
//      annotationView.restaurant = restaurant
      annotationView.loadUI()
      return annotationView
  }
}
extension MapViewController: AnnotationViewDelegate {
    func didTouch(annotationView: AnnotationView) {
        
    }
}


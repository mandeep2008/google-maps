//
//  ViewController.swift
//  GoogleMap
//
//  Created by Geetika on 06/11/23.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController {
    let locationManager = CLLocationManager()
    var allLocations: [CLLocation] = []
    var path = GMSMutablePath()
    var polyline = GMSPolyline()
//    let sourceLocation = "\(30.7105),\(76.7033)"
//    let destinationLocation = "\(30.7421),\(76.8188)"
    @IBOutlet weak var mapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.mapView?.isMyLocationEnabled = true
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        
        polyline.strokeColor = .systemBlue
        polyline.strokeWidth = 5
        polyline.map = self.mapView


    }


}

extension ViewController: CLLocationManagerDelegate{
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            switch manager.authorizationStatus {
            case .notDetermined:
                print("When user did not yet determined")
            case .restricted:
                print("Restricted by parental control")
            case .denied:
                print("When user select option Dont't Allow")
            case .authorizedAlways:
                print("Geofencing feature has user permission")
            case .authorizedWhenInUse:
                // Request Always Allow permission
                // after we obtain When In Use permission
                locationManager.requestAlwaysAuthorization()
            default:
                print("default")
            }
        }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         if let location = locations.last {
             let currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

             path.add(currentLocation)
             polyline.path = path
             let camera = GMSCameraPosition.camera(withLatitude: currentLocation.latitude, longitude: currentLocation.longitude, zoom: 20)
             mapView.animate(to: camera)
         }
     }
    

}






//MARK: draw polyline between 2 points

//        ApiManager.shared.drawPathApi(sourceLocation: sourceLocation, destinationLocation: destinationLocation){ response in
//                       for route in response {
//                            let overviewPolyline: NSDictionary = (route as? NSDictionary)?.value(forKey: "overview_polyline") as! NSDictionary
//                           let points = overviewPolyline.object(forKey: "points")
//                           let path = GMSPath.init(fromEncodedPath: points as! String)
//                           let polyline = GMSPolyline.init(path: path)
//                           polyline.strokeColor = .systemBlue
//                           polyline.strokeWidth = 5
//                           let bounds = GMSCoordinateBounds(path: path!)
//                           self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
//                           polyline.map = self.mapView
//                       }
//
//        }



//MARK: show current location

//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations.last
//
//        print(locations)
//        guard let coordinate = location?.coordinate else {
//            return
//        }
//        let camera = GMSCameraPosition.camera(withLatitude:(coordinate.latitude),longitude: (coordinate.longitude),zoom: 15.0)
//
//        print("lat....\(coordinate.latitude)")
//        print("long....\(coordinate.longitude)")
//        self.mapView?.animate(to: camera)
//        self.mapView.settings.myLocationButton = true
//
//        self.locationManager.stopUpdatingLocation()
//
//    }

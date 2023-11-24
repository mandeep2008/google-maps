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
    var coveredCoordinates: [CLLocationCoordinate2D] = []
    var previousEndPoint: CLLocationCoordinate2D?
    var totalDistance: CLLocationDistance = 0.0
    var polyline = GMSPolyline()
//    let sourceLocation = "\(30.7105),\(76.7033)"
//    let destinationLocation = "\(30.7421),\(76.8188)"
    @IBOutlet weak var mapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.mapView?.isMyLocationEnabled = true
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
      

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
                locationManager.requestAlwaysAuthorization()
            default:
                print("default")
            }
        }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         if let location = locations.last {
             let currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
           //  gradientPolyline(currentLocation: currentLocation)
             
             let camera = GMSCameraPosition.camera(withLatitude: currentLocation.latitude, longitude: currentLocation.longitude, zoom:18)
            
               mapView.animate(to: camera)
             coveredCoordinates.append(location.coordinate)
            multiColorPolyline()
            
             
             
           
             
          
         }
    
     }
    

    
   
    
   
    
   
}


//MARK: different styles of polyline 
extension ViewController{
  
    
    func multiColorPolyline() {
        guard coveredCoordinates.count >= 2 else {
            return
        }
        let startCoordinate = coveredCoordinates[coveredCoordinates.count - 2]
        let endCoordinate = coveredCoordinates[coveredCoordinates.count - 1]
        
        //draw polyline
        let path = GMSMutablePath()
        path.add(startCoordinate)
        path.add(endCoordinate)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5.0
        polyline.strokeColor = randomColor()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            polyline.map = self.mapView
        }

    }
    
    func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    
    
    func customStylePolyline(currentLocation: CLLocationCoordinate2D){
        path.add(currentLocation)
        polyline.path = path
        polyline.strokeWidth = 20
        let redWithStamp = GMSStrokeStyle.solidColor(.clear)
        let image = UIImage(systemName: "circle.fill")! // Image could be from anywhere
        redWithStamp.stampStyle = GMSTextureStyle(image: image)
        let span = GMSStyleSpan(style: redWithStamp)
        polyline.spans = [span]
        polyline.map = mapView
    }
    
    func gradientPolyline(currentLocation: CLLocationCoordinate2D){
        path.add(currentLocation)
        polyline.path = path
//        let strokeStyles = [GMSStrokeStyle.solidColor(.black), GMSStrokeStyle.solidColor(.clear)]
//        let strokeLengths = [NSNumber(value: 10), NSNumber(value: 10)]
//        if let path = polyline.path {
//          polyline.spans = GMSStyleSpans(path, strokeStyles, strokeLengths, .rhumb)
//        }
//        polyline.map = mapView
        let gColor = GMSStrokeStyle.gradient(from: .red, to: .green)
        polyline.spans = [GMSStyleSpan(style: gColor, segments: 1)]
        polyline.strokeWidth = 5
        polyline.map = mapView
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
//        let camera = GMSCameraPosition.camera(withLatitude:(coordinate.latitude),longitude: (coordinate.longitude),zoom: 15.0)/
//
//        print("lat....\(coordinate.latitude)")
//        print("long....\(coordinate.longitude)")
//        self.mapView?.animate(to: camera)
//        self.mapView.settings.myLocationButton = true
//
//        self.locationManager.stopUpdatingLocation()
//
//    }

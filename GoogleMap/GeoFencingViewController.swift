//
//  GeoFencingViewController.swift
//  GoogleMap
//
//  Created by Geetika on 08/11/23.
//

import UIKit
import GoogleMaps
import CoreLocation
import UserNotifications

class GeoFencingViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    
    let geofenceRegionCenter = CLLocationCoordinate2DMake(37.33233141, -122.00910)
    
    let circle = GMSCircle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                locationManager.delegate = self
                self.mapView?.isMyLocationEnabled = true
                locationManager.requestAlwaysAuthorization()

                addCircle(latitude:37.33233141, longitude: -122.00910)
                let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter,radius: 100,identifier: "ABC")
                geofenceRegion.notifyOnExit = true
                geofenceRegion.notifyOnEntry = true
                locationManager.startMonitoring(for: geofenceRegion)
        
                locationManager.startUpdatingLocation()
        
    }
    
    
    
    func addNotification(region: CLRegion, title: String, body: String){
        
        let identifier = UUID().uuidString
        let content: UNMutableNotificationContent = UNMutableNotificationContent()
            content.title = title
            content.body = body
            let trigger: UNLocationNotificationTrigger = UNLocationNotificationTrigger(region: region, repeats: false)
 
            let request: UNNotificationRequest = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
    
    func addCircle(latitude: Double, longitude: Double){
        let camera = GMSCameraPosition.camera(withLatitude:CLLocationDegrees(latitude),longitude:CLLocationDegrees(longitude),zoom: 15.0)
       mapView.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        marker.map = mapView
        
        
        let circleCenter = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
        circle.position = circleCenter
        circle.fillColor = .gray
        circle.strokeColor = .black
        circle.strokeWidth = 3
        circle.radius = 100
        
        circle.map = mapView
    }



}

extension GeoFencingViewController: CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       let location = locations.last

        guard (location?.coordinate) != nil else {
                return
            }
            self.mapView.settings.myLocationButton = true

        }
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
                print("The monitored regions are: \(manager.monitoredRegions)")
            }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            print("exit")
            self.addNotification(region: region,title: "Abc",body: "User exit")
        }
    }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Enter")
        self.addNotification(region: region,title: "abc", body: "user enter")

    }


}

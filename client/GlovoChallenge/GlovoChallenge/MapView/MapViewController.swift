//
//  ViewController.swift
//  GlovoChallenge
//
//  Created by Ben Smith on 18/06/2018.
//  Copyright © 2018 Ben Smith. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import ISHPullUp

struct CityPolygon {
    var polyLines: [GMSPolygon] = []
    var city: Cities?
}

class MapViewController: UIViewController, ISHPullUpContentDelegate {
    @IBOutlet fileprivate weak var mapView: GMSMapView!
    @IBOutlet private weak var rootView: UIView!

    var delegate: controllerViewCallBack?
    var zoomLevel: Float = 0.0
    var switchZoomLevel: Float = 11.0
    let initialZoomLevel: Float = 12.0
    var polygonLoaded = true
    var firstLoad = true

    var cityPolygons: [CityPolygon] = []
    var cities: [Cities] = [] {
        didSet {
            loadCityPolygonOnMap()

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getUserLocation()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getUserLocation() {
         LocationService.sharedInstance.delegate = self
    }

    func loadCityPolygonOnMap(){
        for city in cities {
            self.addPolyLineWithEncodedStringInMap(city: city, encodedStrings: city.working_area ?? [])
        }
    }
    
    func loadCityPinsOnMap(){
        for cityPoly in cityPolygons {
            if let pointAt = cityPoly.polyLines[0].path?.coordinate(at: 0),
                let name = cityPoly.city?.name,
                let countryCode = cityPoly.city?.country_code{
                let lat = pointAt.latitude
                let lng = pointAt.longitude
                self.createMapMarker(at: CLLocation.init(latitude: lat, longitude: lng),
                                     title: name,
                                     subtitle: countryCode)
            }
        }
    }
    
    func pullUpViewController(_ vc: ISHPullUpViewController,
                              update edgeInsets: UIEdgeInsets,
                              forContentViewController _: UIViewController) {
        if #available(iOS 11.0, *) {
            additionalSafeAreaInsets = edgeInsets
            rootView.layoutMargins = .zero
        } else {
            // update edgeInsets
            rootView.layoutMargins = edgeInsets
        }
        
        // call layoutIfNeeded right away to participate in animations
        // this method may be called from within animation blocks
        rootView.layoutIfNeeded()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gotoLocation(location: CLLocationCoordinate2D) {
        self.mapView?.camera = GMSCameraPosition(target: location,
            zoom: initialZoomLevel,
            bearing: 0,
            viewingAngle: 0)
    }
    

    func addPolyLineWithEncodedStringInMap(city: Cities, encodedStrings: [String]) {
        var cityPoly = CityPolygon.init(polyLines: [], city: city)

        for encodedString in encodedStrings {
            let path = GMSMutablePath(fromEncodedPath: encodedString)
            let polyLine = GMSPolygon(path: path)
            cityPoly.polyLines.append(polyLine)
            polyLine.strokeWidth = 4
            polyLine.fillColor = Color.glovoGreen
            polyLine.map = self.mapView
        }
        self.cityPolygons.append(cityPoly)
    }
    
    
    func createMapMarker(at location: CLLocation, title: String, subtitle: String) {
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                 longitude: location.coordinate.longitude)
        marker.title = title
        marker.icon = #imageLiteral(resourceName: "yellowPindrop")
        marker.snippet = subtitle
        marker.map = mapView
    }
    
}



//Location Service
extension MapViewController: LocationServiceDelegate {
    func trackingLocation(for currentLocation: CLLocation) {
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude,
                                              longitude: currentLocation.coordinate.longitude,
                                              zoom: initialZoomLevel)
        self.mapView.camera = camera
        self.mapView?.settings.myLocationButton = true
        self.mapView?.delegate = self
        
        //if we got there location
        if let location = LocationService.sharedInstance.currentLocation {
            //And they are out of the working area
            if checkIfCoordinateIsInWorkingArea(coordinate: location.coordinate) == false {
                //Show them out of bounds message
                delegate?.showMessage(message: NSLocalizedString("outofBoundsMessage", comment: ""))
            }
        }
    }
    
    func trackingLocationDidFail(with error: Error) {
        print("Failed to get location")
        //go to madrid coords
        let coord = CLLocationCoordinate2D.init(latitude: 40.416775, longitude: -3.70379)
        let camera = GMSCameraPosition.camera(withLatitude: coord.latitude,
                                              longitude: coord.longitude,
                                              zoom: 4)
        self.mapView.camera = camera
        self.mapView?.settings.myLocationButton = true
        self.mapView?.delegate = self
        loadCityPolygonOnMap()
        loadCityPinsOnMap()
        delegate?.showMessage(message: NSLocalizedString("refusedLocationMessage", comment: ""))
    }
    
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        zoomLevel = mapView.camera.zoom
        if zoomLevel <= 9.0 {
            clearPolygon()
        }else {
            clearPins() 
        }
    }
    
    func clearPolygon() {
        if polygonLoaded == false {
            self.mapView.clear()
            loadCityPinsOnMap()
        }
        polygonLoaded = true
    }
    
    func clearPins() {
        if polygonLoaded {
            self.mapView.clear()
            loadCityPolygonOnMap()
        }
        polygonLoaded = false
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        if let location = LocationService.sharedInstance.currentLocation?.coordinate {
            gotoLocation(location: location)
            return true
        } else {
            delegate?.showMessage(message: NSLocalizedString("refusedLocationMessage", comment: ""))
            return false
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        //if after searching everywhere this coordinate is not found in the cities we are out of bounds
        let coordinate = mapView.projection.coordinate(for: mapView.center)
        if checkIfCoordinateIsInWorkingArea(coordinate: coordinate) == false {
            self.delegate?.updateDetails(city: "Not Found") //send back not found string to show no city found
        }

    }

    func checkIfCoordinateIsInWorkingArea(coordinate: CLLocationCoordinate2D) -> Bool {
        var found = false
        for cityPoly in self.cityPolygons {
            for polyline in cityPoly.polyLines {
                if let polyLinePath = polyline.path, let cityCode = cityPoly.city?.code,
                    GMSGeometryContainsLocation(coordinate,polyLinePath,true) {
                    found = true
                    self.delegate?.updateDetails(city: cityCode)
                }
            }
        }
        return found
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        gotoLocation(location: marker.position)
        return true
    }
    
}


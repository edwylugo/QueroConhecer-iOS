//
//  PlaceAnnotation.swift
//  QueroConhecer
//
//  Created by EPR Exatron on 09/08/2018.
//  Copyright © 2018 Exatron. All rights reserved.
//

import Foundation
import MapKit

class PlaceAnnotation: NSObject,  MKAnnotation {
    
    enum PlaceType {
        case place
        case poi
    }
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var type: PlaceType
    var address: String?
    
    init(coordinate: CLLocationCoordinate2D, type: PlaceType) {
        self.coordinate = coordinate
        self.type = type
    }
    
}

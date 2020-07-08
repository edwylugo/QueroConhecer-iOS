//
//  Place.swift
//  QueroConhecer
//
//  Created by EPR Exatron on 08/08/2018.
//  Copyright © 2018 Exatron. All rights reserved.
//

import Foundation
import MapKit

struct Place: Codable {
    
    let name: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let address: String
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func getFormattedAddress(with placemark: CLPlacemark) -> String {
        
        var address = ""
        if let street = placemark.thoroughfare {
            address += street //Rua
        }
        if let number = placemark.subThoroughfare {
            address += " \(number)" //Número
        }
        if let subLocality = placemark.subLocality {
            address += ", \(subLocality)" //Bairro
        }
        if let city = placemark.locality {
            address += "\n\(city)" //Cidade
        }
        if let state = placemark.administrativeArea {
            address += " - \(state)" //Estado
        }
        if let postalCode = placemark.postalCode {
            address += "\nCEP: \(postalCode)" //CEP
        }
        if let country = placemark.country {
            address += "\n\(country)" //País
        }
        return address
    }
}


extension Place : Equatable {
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
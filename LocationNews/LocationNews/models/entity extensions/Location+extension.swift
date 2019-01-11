//
//  Location+extension.swift
//  LocationNews
//
//  Created by Kiko Santos on 09/01/19.
//  Copyright © 2019 Kiko Santos. All rights reserved.
//

import Foundation
import MapKit

extension Location: MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D {
        
        guard let latitude = latitude, let longitude = longitude else {
            return kCLLocationCoordinate2DInvalid
        }
        
        let latDegrees = CLLocationDegrees(latitude.doubleValue)
        let longDegrees = CLLocationDegrees(longitude.doubleValue)
        return CLLocationCoordinate2D(latitude: latDegrees, longitude: longDegrees)
        
    }
    
    public var title: String? {
        guard let name = name else {
            return "No Title"
        }
        return name
    }
    
    public var subtitle: String? {
        guard let locality = locality else {
            return "No Title"
        }
        return locality
    }

}

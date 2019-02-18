//
//  GCSportsDictionary.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2019/2/10.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import UIKit
import MapKit

let SPORTS_TEAM_ICON: Dictionary<String, String> = [
    "The Governor's Academy": "governor_logo_test.jpg",
    "Milton Academy": "milton_logo_test.jpg",
    "Tabor Academy": "tabor_logo_test.jpg",
    "Pingree School": "pingree_logo_test.jpg"
]

let SPORTS_TYPE_COLOR: Dictionary<GCSportType, UIColor> = [
    .tennis: UIColorFromRGB(rgbValue: 0x5CC7AE, alpha: 0.8),
    .baseballSoftball: UIColorFromRGB(rgbValue: 0xE46A70, alpha: 0.8),
    .hockey: UIColorFromRGB(rgbValue: 0xEEC569, alpha: 0.8),
    .default: APP_BACKGROUND_LIGHT_GREY
]

let SPORTS_TYPE_BACKGROUND_IMAGE: Dictionary<GCSportType, String> = [
    .tennis: "tennis_test.png",
    .baseballSoftball: "baseball_test.png",
    .hockey: "hockey_test.png"
]

let SPORTS_LOCATION: Dictionary<String, CLLocation> = [
    "The Governor's Academy": CLLocation(latitude: 42.750087300000004, longitude: -70.9022764416293),
    "Tabor Academy": CLLocation(latitude: 41.709031949999996, longitude: -70.76794261784177),
    "Milton Academy": CLLocation(latitude: 42.2559824, longitude: -71.0704744),
    "Pingree Academy": CLLocation(latitude: 42.64004545, longitude: -70.8823536437509)
]

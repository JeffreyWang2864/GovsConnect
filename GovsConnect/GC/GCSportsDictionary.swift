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
    "Worcester Academy": "worcester-academy.png",
    "Winsor School": "winsor-school.png",
    "Wilbraham Monson Academy": "wilbraham-monson-academy.png",
    "Triton High School": "triton-high-school.png",
    "Traip Academy": "traip-academy.png",
    "Tilton School": "tilton-school.png",
    "The Rivers School": "the-rivers-school.png",
    "The Hill Academy": "the-hill-academy.png",
    "The Gunnery School": "the-gunnery-school.png",
    "The Governor's Academy": "the-governors-academy.png",
    "Thayer Academy": "thayer-academy.png",
    "Tabor Academy": "tabor-academy.png",
    "St. Sebastian's School": "st-sebastians-school.png",
    "St. Paul's School": "st-pauls-school.png",
    "St. Marks School": "st-marks-school.png",
    "St. George's School": "st-georges-school.png",
    "Shore Country Day School": "shore-country-day-school.png",
    "Roxbury Latin School": "roxbury-latin-school.png",
    "Rivers": "rivers.png",
    "Portsmouth High School": "portsmouth-high-school.png",
    "Portsmouth Abbey School": "portsmouth-abbey-school.png",
    "Pomfret School": "pomfret-school.png",
    "Pingree School": "pingree-school.png",
    "Phillips Exeter Academy": "phillips-exeter-academy.png",
    "Phillips Academy Andover": "phillips-academy-andover.png",
    "Northfield Mt. Herman": "northfield-mt-herman.png",
    "North Yarmouth Academy": "north-yarmouth-academy.png",
    "North Andover Middle School": "north-andover-middle-school.png",
    "Noble & Greenough School": "noble-greenough-school.png",
    "Newton Country Day School": "newton-country-day-school.png",
    "Newburyport High School": "newburyport-high-school.png",
    "New Hampton School": "new-hampton-school.png",
    "Milton Academy": "milton-academy.png",
    "Millbrook": "millbrook.png",
    "Middlesex School": "middlesex-school.png",
    "Methuen High School": "methuen-high-school.png",
    "Marianapolis Preparatory School": "marianapolis-preparatory-school.png",
    "Lawrence Academy": "lawrence-academy.png",
    "Landmark School": "landmark-school.png",
    "Kimball Union Academy": "kimball-union-academy.png",
    "Kents Hill School": "kents-hill-school.png",
    "Holderness School": "holderness-school.png",
    "Hebron Academy": "hebron-academy.png",
    "Groton School": "groton-school.png",
    "Esperanza Academy": "esperanza-academy.png",
    "Eagle Hill School": "eagle-hill-school.png",
    "Dover High School": "dover-high-school.png",
    "Dexter Southfield School": "dexter-southfield-school.png",
    "Dana Hall School": "dana-hall-school.png",
    "Cushing Academy": "cushing-academy.png",
    "Concord Academy": "concord-academy.png",
    "Chapel Hill-Chauncy Hall": "chapel-hill-chauncy-hall.png",
    "Canterbury School": "canterbury-school.png",
    "Brookwood School": "brookwood-school.png",
    "Brooks School": "brooks-school.png",
    "Belmont Hill School": "belmont-hill-school.png",
    "Beaver Country Day School": "beaver-country-day-school.png",
    "Bancroft School": "bancroft-school.png",
    "BB&N": "bbn.png",
    "Avon Old Farms": "avon-old-farms.png",
]

let SPORTS_TYPE_COLOR: Dictionary<GCSportType, UIColor> = [
    .football: UIColorFromRGB(rgbValue: 0x5CC7AE, alpha: 0.8),
    .soccer: UIColorFromRGB(rgbValue: 0xE46A70, alpha: 0.8),
    .volleyball: UIColorFromRGB(rgbValue: 0xEEC558, alpha: 0.8),
    .basketball: UIColorFromRGB(rgbValue: 0xE46A70, alpha: 0.8),
    .hockey: UIColorFromRGB(rgbValue: 0x5CC7AE, alpha: 0.8),
    .lacrosse: UIColorFromRGB(rgbValue: 0x5CC7AE, alpha: 0.8),
    .tennis: UIColorFromRGB(rgbValue: 0xEEC558, alpha: 0.8),
    .baseballSoftball: UIColorFromRGB(rgbValue: 0xE46A70, alpha: 0.8),
    .wrestling: UIColorFromRGB(rgbValue: 0xEEC558, alpha: 0.8),
    .indoorWinterTrack: UIColorFromRGB(rgbValue: 0x6FB4FF, alpha: 0.8),
    .indoorOutdoorTrack: UIColorFromRGB(rgbValue: 0x6FB4FF, alpha: 0.8),
    .golf: UIColorFromRGB(rgbValue: 0xFF9663, alpha: 0.8),
    .fieldHockey: UIColorFromRGB(rgbValue: 0x6FB4FF, alpha: 0.8),
    .crossCountry: UIColorFromRGB(rgbValue: 0xFF9663, alpha: 0.8),
    .default: UIColor.darkGray
]

let SPORTS_TYPE_BACKGROUND_IMAGE: Dictionary<GCSportType, String> = [
    .football: "football_test.png",
    .soccer: "soccer_test.png",
    .volleyball: "volleyball_test.png",
    .basketball: "basketball_test.png",
    .hockey: "hockey_test.png",
    .lacrosse: "lacrosse_test.png",
    .tennis: "tennis_test.png",
    .baseballSoftball: "baseball_test.png",
    .wrestling: "wrestling_test.png",
    .indoorWinterTrack: "trackfield_test.png",
    .indoorOutdoorTrack: "trackfield_test.png",
    .golf: "golf_test.png",
    .fieldHockey: "fieldhockey_test.png",
    .crossCountry: "crosscountry_test.png",
    .default: "default-opponent.png",
]

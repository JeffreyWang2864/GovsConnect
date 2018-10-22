//
//  defines.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/8.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

let LOREM_IPSUM_1 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

let LOREM_IPSUM_2 = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"

let LOREM_IPSUM_3 = "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat."

let APP_THEME_COLOR = UIColor(red: 0.757, green: 0.243, blue: 0.314, alpha: 1.0)
let APP_BACKGROUND_GREY = UIColor(red: 0.937, green: 0.937, blue: 0.957, alpha: 1.0)

let APP_BACKGROUND_ULTRA_GREY = UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 1.0)

let APP_SERVER_URL_STR = "https://govs.app"

let PREDICATE_NAME_CONTAIN = "name contains[c] %@"

let PHONE_TYPE: GCPhoneType = {
    assert(UIDevice().userInterfaceIdiom == .phone)
    NSLog("\(UIScreen.main.nativeBounds.height)")
    switch UIScreen.main.nativeBounds.height {
    case 1136:
        return .iphone5
    case 1334:
        return .iphone6
    case 1920, 2208:
        return .iphone6plus
    case 1792:
        return .iphonexr
    case 2436:
        return .iphonex
    case 2688:
        return .iphonexsmax
    default:
        fatalError()
    }
}()

var secondsFromGMT: Int {
    return TimeZone.current.secondsFromGMT()
}

let APP_ID = "1436465026"

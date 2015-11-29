//
//  Flags.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/23/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation

struct Flag  {
    //MARK : Properties
    var FLAG_ID : Int
    var DESCRIPTION : String
    
    private static let NON_EXISTING_DESCRIPTION = "Non existing"
    private static let HARD_TO_FIND_DESCRIPTION = "Hard to find"
    private static let PAID_DESCRIPTION = "Paid"
    private static let PUBLIC_DESCRIPTION = "Public"
    //MARK : Static Structs
    static let NON_EXISTING = Flag(FLAG_ID: 1, DESCRIPTION: NON_EXISTING_DESCRIPTION)
    static let HARD_TO_FIND = Flag(FLAG_ID: 2, DESCRIPTION: HARD_TO_FIND_DESCRIPTION)
    static let PAID = Flag(FLAG_ID: 3, DESCRIPTION: PAID_DESCRIPTION)
    static let PUBLIC = Flag(FLAG_ID: 4, DESCRIPTION: PAID_DESCRIPTION)
    
    //MARK : Flag resolver
    static func flagFromId(id : Int) -> Flag  {
        switch id {
            case 1:
                return NON_EXISTING
            case 2:
                return HARD_TO_FIND
            case 3:
                return PAID
            case 4:
                return PUBLIC
            default:
                return Flag(FLAG_ID: id, DESCRIPTION: "No such flag")
        }
    }
    
    static func flagFromDescription(descr : String) -> Flag {
        switch descr {
        case NON_EXISTING_DESCRIPTION:
            return NON_EXISTING
        case HARD_TO_FIND_DESCRIPTION:
            return HARD_TO_FIND
        case PAID_DESCRIPTION:
            return PAID
        case PUBLIC_DESCRIPTION:
            return PUBLIC
        default:
            return Flag(FLAG_ID: 0, DESCRIPTION: "No such flag")
        }
    }
}
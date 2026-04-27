//
//  UIColor+Extension.swift
//  Napify
//
//  Created by Mikiyas Asmamaw on 4/26/26.
//

import UIKit

extension UIColor {

    static let napify = Napify()

    struct Napify {
        let black = UIColor.black
        let offWhite = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        let white = UIColor.white
        let amber = UIColor(red: 245/255, green: 190/255, blue: 50/255, alpha: 1)
        let silver = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
        let darkGray = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)
        let lightGray = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }

}

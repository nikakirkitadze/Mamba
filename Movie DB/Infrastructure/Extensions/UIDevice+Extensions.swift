//
//  UIDevice+Extensions.swift
//  @cash
//
//  Created by Nika Kirkitadze on 8/17/20.
//  Copyright © 2020 ACMG. All rights reserved.
//

import UIKit

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}

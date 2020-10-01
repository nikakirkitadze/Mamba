//
//  DeviceHelper.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 10/2/20.
//

import UIKit

enum DeviceTypeAndOrientation {
    static var isIpad: Bool {
        return UIView().traitCollection.horizontalSizeClass == .regular && UIView().traitCollection.verticalSizeClass == .regular
    }

    static var isLandscape: Bool {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? false
        } else {
            // Fallback on earlier versions
            
        }
        
        return false
    }
}

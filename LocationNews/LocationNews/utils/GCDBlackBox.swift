//
//  GCDBlackBox.swift
//  LocationNews
//
//  Created by Kiko Santos on 09/01/19.
//  Copyright © 2019 Kiko Santos. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

//
//  UIImageView+extension.swift
//  LocationNews
//
//  Created by Kiko Santos on 10/01/19.
//  Copyright © 2019 Kiko Santos. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func download(from url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    performUIUpdatesOnMain {
                        self?.image = image
                    }
                }
            }
        }
    }
}

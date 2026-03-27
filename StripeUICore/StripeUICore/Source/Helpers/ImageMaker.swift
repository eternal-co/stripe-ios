//
//  ImageMaker.swift
//  StripeUICore
//
//  Created by Mel Ludowise on 9/10/21.
//  Copyright © 2021 Stripe, Inc. All rights reserved.
//

import Foundation
import UIKit

@_spi(STP) import StripeCore

@_spi(STP) public protocol ImageMaker {
    associatedtype BundleLocator: BundleLocatorProtocol
}

@_spi(STP) public extension ImageMaker {
    private static func imageNamed(
      _ imageName: String,
      templateIfAvailable: Bool,
      compatibleWith traitCollection: UITraitCollection? = nil
    ) -> UIImage? {

      // 1. Try the designated resources bundle
      var image = UIImage(
        named: imageName, in: BundleLocator.resourcesBundle, compatibleWith: traitCollection)

      // 2. Try the main bundle
      if image == nil {
          image = UIImage(named: imageName, in: nil, compatibleWith: traitCollection)
      }

      // 3. Search all loaded bundles as a fallback (workaround for SPM resource bundle issues)
      if image == nil {
          for bundle in Bundle.allBundles {
              if let found = UIImage(named: imageName, in: bundle, compatibleWith: traitCollection) {
                  image = found
                  break
              }
          }
      }

      if templateIfAvailable {
        image = image?.withRenderingMode(.alwaysTemplate)
      }

      return image
    }

    static func safeImageNamed(
        _ imageName: String,
        templateIfAvailable: Bool = false,
        overrideUserInterfaceStyle: UIUserInterfaceStyle? = nil
    ) -> UIImage {
        let image: UIImage
        if let overrideUserInterfaceStyle = overrideUserInterfaceStyle {
            let appearanceTrait = UITraitCollection(userInterfaceStyle: overrideUserInterfaceStyle)
            image = imageNamed(imageName, templateIfAvailable: templateIfAvailable, compatibleWith: appearanceTrait) ?? UIImage()
        } else {
            image = imageNamed(imageName, templateIfAvailable: templateIfAvailable) ?? UIImage()
        }
        assert(image.size != .zero, "Failed to find an image named \(imageName)")
        return image
    }
}

@_spi(STP) public extension ImageMaker where Self: RawRepresentable, RawValue == String {
    func makeImage(template: Bool = false, overrideUserInterfaceStyle: UIUserInterfaceStyle? = nil) -> UIImage {
        return Self.safeImageNamed(
            self.rawValue,
            templateIfAvailable: template,
            overrideUserInterfaceStyle: overrideUserInterfaceStyle
        )
    }
}

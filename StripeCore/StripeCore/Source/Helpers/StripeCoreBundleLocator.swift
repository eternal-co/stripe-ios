//
//  StripeCoreBundleLocator.swift
//  StripeCore
//
//  Created by Mel Ludowise on 7/6/21.
//  Copyright © 2021 Stripe, Inc. All rights reserved.
//

import Foundation

#if SWIFT_PACKAGE
private class BundleFinder {}

extension Foundation.Bundle {
    static let stripeCoreBundle: Bundle = {
        let bundleName = "StripeCore_StripeCore"

        let candidates = [
            Bundle.main.resourceURL,
            Bundle(for: BundleFinder.self).resourceURL,
            Bundle.main.bundleURL,
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }

        for bundle in Bundle.allBundles {
            if let path = bundle.path(forResource: bundleName, ofType: "bundle"),
               let resourceBundle = Bundle(path: path) {
                return resourceBundle
            }
        }

        return Bundle.module
    }()
}
#endif

final class StripeCoreBundleLocator: BundleLocatorProtocol {
    static let internalClass: AnyClass = StripeCoreBundleLocator.self
    static let bundleName = "StripeCoreBundle"
    #if SWIFT_PACKAGE
    static let spmResourcesBundle = Bundle.stripeCoreBundle
    #endif
    static let resourcesBundle = StripeCoreBundleLocator.computeResourcesBundle()
}

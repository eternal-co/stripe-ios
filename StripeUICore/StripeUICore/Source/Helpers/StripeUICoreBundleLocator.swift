//
//  StripeUICoreBundleLocator.swift
//  StripeUICore
//
//  Created by Mel Ludowise on 9/8/21.
//  Copyright © 2021 Stripe, Inc. All rights reserved.
//

import Foundation
@_spi(STP) import StripeCore

#if SWIFT_PACKAGE
private class BundleFinder {}

extension Foundation.Bundle {
    /// Manually locates the SPM resource bundle when Bundle.module fails
    /// in nested package configurations.
    static let stripeUICoreBundle: Bundle = {
        let bundleName = "StripeUICore_StripeUICore"

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

@_spi(STP) public final class StripeUICoreBundleLocator: BundleLocatorProtocol {
    public static let internalClass: AnyClass = StripeUICoreBundleLocator.self
    public static let bundleName = "StripeUICoreBundle"
    #if SWIFT_PACKAGE
    public static let spmResourcesBundle = Bundle.stripeUICoreBundle
    #endif
    public static let resourcesBundle = StripeUICoreBundleLocator.computeResourcesBundle()
}

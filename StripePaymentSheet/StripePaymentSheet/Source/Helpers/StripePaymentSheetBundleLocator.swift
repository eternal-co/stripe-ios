//
//  StripePaymentSheetBundleLocator.swift
//  StripePaymentSheet
//
//  Copyright © 2022 Stripe, Inc. All rights reserved.
//

import Foundation
@_spi(STP) import StripeCore

#if SWIFT_PACKAGE
private class BundleFinder {}

extension Foundation.Bundle {
    /// Manually locates the SPM resource bundle when Bundle.module fails
    /// in nested package configurations.
    static let stripePaymentSheetBundle: Bundle = {
        let bundleName = "StripePaymentSheet_StripePaymentSheet"

        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,
            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: BundleFinder.self).resourceURL,
            // For command-line tools.
            Bundle.main.bundleURL,
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }

        // Fall back to searching all bundles
        for bundle in Bundle.allBundles {
            if let path = bundle.path(forResource: bundleName, ofType: "bundle"),
               let resourceBundle = Bundle(path: path) {
                return resourceBundle
            }
        }

        // Last resort: try Bundle.module (may fatalError if SPM-generated code can't find it)
        return Bundle.module
    }()
}
#endif

/// :nodoc:
@_spi(STP) public final class StripePaymentSheetBundleLocator: BundleLocatorProtocol {
    public static let internalClass: AnyClass = StripePaymentSheetBundleLocator.self
    public static let bundleName = "StripePaymentSheetBundle"
    #if SWIFT_PACKAGE
    public static let spmResourcesBundle = Bundle.stripePaymentSheetBundle
    #endif
    public static let resourcesBundle = StripePaymentSheetBundleLocator.computeResourcesBundle()
}

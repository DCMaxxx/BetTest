//
//  FixedColumnsLayout.swift
//  BetTest
//
//  Created by Maxime de Chalendar on 01/10/2017.
//  Copyright © 2017 Maxime de Chalendar. All rights reserved.
//

import Foundation
import UIKit

/// A collection view layout that always displays a fixed number of columns,
/// It calculates the item's width using the using the collectionView's width and insets, spacings,
/// And uses it for both its itemSize's width and height.
/// Therefore, setting itemSize will have no effect.
final class FixedColumnsSquareItemsLayout: UICollectionViewFlowLayout {

    @IBInspectable var columnsCount: Int = 2

    override var itemSize: CGSize {
        get {
            return calculateItemSize()
        }
        set {
            // See the classe's documentation
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
        guard let flowLayoutContext = context as? UICollectionViewFlowLayoutInvalidationContext else {
            return context
        }
        let hasChangedBounds = newBounds != collectionView?.bounds
        flowLayoutContext.invalidateFlowLayoutDelegateMetrics = hasChangedBounds
        return context
    }

    private func calculateItemSize() -> CGSize {
        guard let currentWidth = collectionView?.bounds.width else {
            return .zero
        }

        let decimalColumnsCount = CGFloat(columnsCount)
        let edgesSpacing = sectionInset.left + sectionInset.right
        let interitemSpacing = minimumInteritemSpacing * (decimalColumnsCount - 1)
        let itemsTotalWidth = currentWidth - (edgesSpacing + interitemSpacing)
        let itemWidth = (itemsTotalWidth / decimalColumnsCount).rounded(.down)
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        return itemSize
    }
}

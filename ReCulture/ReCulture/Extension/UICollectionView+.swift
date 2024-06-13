//
//  UICollectionView+.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/1/24.
//

import UIKit

extension UICollectionView {
    /// collectionView에서 선택된 아이템 선택 해제
    func deselectAllItems(animated: Bool) {
        guard let selectedItems = indexPathsForSelectedItems else { return }
        for indexPath in selectedItems {
            deselectItem(at: indexPath, animated: animated)
        }
    }
}

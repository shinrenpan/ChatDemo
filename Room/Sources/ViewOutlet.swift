//
//  ViewOutlet.swift
//  Room
//
//  Created by Joe Pan on 2025/3/9.
//

import UIKit

@MainActor final class ViewOutlet {
    let mainView = UIView()
    let list = UICollectionView(frame: .zero, collectionViewLayout: makeListLayout())
    let keyIn = KeyInView()
    
    init() {
        setupSelf()
        addViews()
    }
}

// MARK: - Internal

extension ViewOutlet {
    func reloadUI(connected: Bool) {
        list.isHidden = !connected
        keyIn.isHidden = !connected
    }
    
    func reloadKeyIn() {
        keyIn.input.isScrollEnabled = false
        keyIn.input.text = ""
        keyIn.sendButton.isEnabled = false
    }
    
    func reloadListToLast(count: Int) {
        guard list.numberOfSections > 0 else {
            return
        }
        
        let lastSection = list.numberOfSections - 1
        
        guard list.numberOfItems(inSection: lastSection) > 0 else {
            return
        }
        
        let lastItemIndexPath = IndexPath(
            item: list.numberOfItems(inSection: lastSection) - 1,
            section: lastSection
        )
        
        list.scrollToItem(at: lastItemIndexPath, at: .bottom, animated: true)
    }
}

// MARK: - Private

private extension ViewOutlet {
    func setupSelf() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        list.translatesAutoresizingMaskIntoConstraints = false
        keyIn.translatesAutoresizingMaskIntoConstraints = false
        mainView.backgroundColor = .white
        list.isHidden = true
        keyIn.isHidden = true
    }
    
    func addViews() {
        mainView.addSubview(keyIn)
        
        NSLayoutConstraint.activate([
            keyIn.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            keyIn.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            keyIn.bottomAnchor.constraint(equalTo: mainView.keyboardLayoutGuide.topAnchor),
            keyIn.heightAnchor.constraint(lessThanOrEqualToConstant: 132),
        ])
        
        mainView.addSubview(list)
        
        NSLayoutConstraint.activate([
            list.topAnchor.constraint(equalTo: mainView.topAnchor),
            list.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            list.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            list.bottomAnchor.constraint(equalTo: keyIn.topAnchor),
        ])
    }
    
    static func makeListLayout() -> UICollectionViewCompositionalLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

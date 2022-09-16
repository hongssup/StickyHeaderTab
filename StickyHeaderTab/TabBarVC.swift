//
//  TabBarVC.swift
//  StickyHeaderTab
//
//  Created by SeoYeon Hong on 2022/09/16.
//

import UIKit
import SnapKit

class TabBarVC: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
    }
    
    private func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(TabHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "tabHeader")
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension TabBarVC: UICollectionViewDelegate {
    
}

extension TabBarVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 3
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        switch indexPath.item {
        case 0:
            cell.backgroundColor = .white
        case 1:
            cell.backgroundColor = .yellow
        default:
            cell.backgroundColor = .green
        }
        return cell
    }
    
    //header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "tabHeader", for: indexPath) as? TabHeader else { return UICollectionReusableView() }
            header.callBack = { index in
                self.moveToScroll(index)
            }
            return header
        }
        return UICollectionReusableView()
    }
}

extension TabBarVC: UICollectionViewDelegateFlowLayout {
    // header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return (section == 0) ? CGSize.zero : CGSize(width: collectionView.frame.width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        if indexPath.section == 0 {
            return CGSize(width: width, height: width)
        } else {
            return CGSize(width: width, height: 800)
        }
    }
}

extension TabBarVC {
    @objc func moveToScroll(_ index: Int) {
        self.collectionView.scrollToItem(at: IndexPath(item: index, section: 1), at: .top, animated: true)
    }
}

// MARK: - TabHeader
class TabHeader: UICollectionReusableView {
    let tabBarView = TabBarView()
    var callBack: ((_ index: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(tabBarView)
        tabBarView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tabBarView.delegate = self
    }
}

extension TabHeader: TabBarViewDelegate {
    func tabControl(didChange index: Int) {
        debugPrint("didChange index: \(index)")
        self.callBack?(index)
    }
}

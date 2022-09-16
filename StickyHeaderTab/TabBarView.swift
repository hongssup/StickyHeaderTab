//
//  TabBarView.swift
//  StickyHeaderTab
//
//  Created by SeoYeon Hong on 2022/09/16.
//

import UIKit

protocol TabBarViewDelegate: AnyObject {
    func tabControl(didChange index: Int)
}

class TabBarView: UIView {
    lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var tabStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    var tabStacks: [UIStackView] = []
    var lineViews: [UIView] = []
    var titleLabels: [UILabel] = []
    var selectedIndex: Int = 0
    
    var titles = ["First", "Second", "Third"]
    let selectedFont = UIFont.systemFont(ofSize: 16)
    let unselectedFont = UIFont.systemFont(ofSize: 16)
    let selectedColor = UIColor.black
    let unselectedColor = UIColor.lightGray
    
    var delegate: TabBarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(dividerView)
        self.addSubview(tabStack)
        
        dividerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        tabStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        layoutElements(tabStack)
        lineViews[selectedIndex].backgroundColor = selectedColor
        titleLabels[selectedIndex].textColor = selectedColor
        titleLabels[selectedIndex].font = selectedFont
        tabStack.layoutIfNeeded()
    }
    
    private func createVStack() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onSelectTab))
        stackView.addGestureRecognizer(tap)
        return stackView
    }
    
    private func createLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = unselectedFont
        label.textAlignment = .center
        label.textColor = unselectedColor
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    private func createLineView() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    private func layoutElements(_ stackView: UIStackView) {
        self.titles.forEach { title in
            let vStack = createVStack()
            let label = createLabel(title)
            stackView.addArrangedSubview(vStack)
            
            let lineView = createLineView()
            vStack.addArrangedSubview(label)
            vStack.addArrangedSubview(lineView)
            
            lineViews.append(lineView)
            titleLabels.append(label)
            tabStacks.append(vStack)
            
            lineView.snp.makeConstraints {
                $0.height.equalTo(2.4)
            }
        }
    }
    
    func changeTabSelection(_ index: Int) {
        debugPrint("들어옴: \(selectedIndex) -> \(index)")
        lineViews[selectedIndex].backgroundColor = .white
        titleLabels[selectedIndex].textColor = unselectedColor
        titleLabels[selectedIndex].font = unselectedFont
        lineViews[index].backgroundColor = selectedColor
        titleLabels[index].textColor = selectedColor
        titleLabels[index].font = selectedFont
        selectedIndex = index
    }
    
    // MARK: - Events
    @objc private func onSelectTab(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? UIStackView else { return }
        
        if let index = tabStacks.firstIndex(of: view) {
            self.changeTabSelection(index)
            delegate?.tabControl(didChange: selectedIndex)
        }
    }
}

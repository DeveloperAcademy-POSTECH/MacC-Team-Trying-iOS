//
//  CoursePlanetSegmentedControlView.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/17.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import SnapKit

class CoursePlanetSegmentedControlView: UIView {
    
    var segmentChanged: ((CoursePlanet) -> Void)?
    private lazy var buttons: [UIButton] = {
        var buttons: [UIButton] = []
        for title in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitleColor(textColor, for: .normal)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            var configuration = UIButton.Configuration.plain()
            configuration.contentInsets = .init(top: 16, leading: 0, bottom: 20, trailing: 0)
            
            var titleAttribute = AttributedString(title)
            titleAttribute.font = .designSystem(weight: .bold, size: ._15)
            titleAttribute.foregroundColor = .designSystem(.white)
            configuration.attributedTitle = titleAttribute
            
            button.configuration = configuration
            buttons.append(button)
        }
        
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
        return buttons
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    private var staticLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.gray818181)
        return view
    }()
    
    private lazy var selectorView: UIView = {
        let view = UIView()
        view.backgroundColor = selectorViewColor
        return view
    }()
    
    private var buttonTitles: [String] = []
    var textColor: UIColor?
    var selectorViewColor: UIColor?
    var selectorTextColor: UIColor?
    
    private(set) var selectedCategory: CoursePlanet = .course
    
    convenience init(
        buttonTitles: [String],
        textColor: UIColor? = .designSystem(.gray818181),
        selectorViewColor: UIColor? = .designSystem(.white),
        selectorTextColor: UIColor? = .designSystem(.white)
    ) {
        self.init(frame: .zero)
        self.textColor = textColor
        self.selectorTextColor = selectorTextColor
        self.selectorViewColor = selectorViewColor
        self.buttonTitles = buttonTitles
        setUI()
    }

    private func setUI() {
        setAttributes()
        setLayout()
    }
    
    @objc
    func buttonAction(sender: UIButton) {
        for (index, button) in buttons.enumerated() {
            button.setTitleColor(textColor, for: .normal)
            if button == sender {
                button.setTitleColor(selectorTextColor, for: .normal)
                let selectorPosition = frame.width / CGFloat(buttonTitles.count) * CGFloat(index)
                selectedCategory = CoursePlanet.allCases[index]
                segmentChanged?(selectedCategory)
                UIView.animate(withDuration: 0.1) { [weak self] in
                    self?.selectorView.frame.origin.x = selectorPosition
                }
            }
        }
    }
}

extension CoursePlanetSegmentedControlView {

    private func setAttributes() {
        addSubview(staticLineView)
        addSubview(buttonStackView)
        addSubview(selectorView)
    }
    
    private func setLayout() {
        
        buttonStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        selectorView.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(3)
            make.leading.equalToSuperview()
            make.bottom.equalTo(staticLineView.snp.top)
        }
        
        staticLineView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1)
            make.leading.equalToSuperview()
            make.top.equalTo(self.snp.bottom)
        }
    }
}

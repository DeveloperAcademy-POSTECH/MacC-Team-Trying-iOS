//
//  CoursePlanetSegmentedControlView.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/17.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

protocol CoursePlanetSegmentSwitchable: AnyObject {
    func change(to coursePlanet: CoursePlanet)
}

class CoursePlanetSegmentedControlView: UIView {
    
    private lazy var buttons: [UIButton] = {
        var buttons: [UIButton] = []
        for title in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitleColor(textColor, for: .normal)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            var configuration = UIButton.Configuration.plain()
            configuration.contentInsets = .init(top: 16, leading: 0, bottom: 20, trailing: 0)
            
            var titleAttribute = AttributedString(title)
            titleAttribute.font = .systemFont(ofSize: 15.0, weight: .bold)
            titleAttribute.foregroundColor = UIColor.white
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
        view.backgroundColor = .gray
        return view
    }()
    
    private lazy var selectorView: UIView = {
        let view = UIView()
        view.backgroundColor = selectorViewColor
        return view
    }()
    
    private var buttonTitles: [String] = []
    var textColor: UIColor = .gray
    var selectorViewColor: UIColor = .white
    var selectorTextColor: UIColor = .white
    
    weak var delegate: CoursePlanetSegmentSwitchable?
    
    private(set) var selectedIndex: Int = 0
    
    convenience init(
        buttonTitle: [String],
        textColor: UIColor = .gray,
        selectorViewColor: UIColor = .white,
        selectorTextColor: UIColor = .white
    ) {
        self.init(frame: .zero)
        self.textColor = textColor
        self.selectorTextColor = selectorTextColor
        self.selectorViewColor = selectorViewColor
        self.buttonTitles = buttonTitle
        
        setUI()
    }

    private func setUI() {
        setAttributes()
        setLayout()
    }
    
    @objc
    func buttonAction(sender: UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                let selectorPosition = frame.width / CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
                selectedIndex = buttonIndex
                delegate?.change(to: CoursePlanet.init(rawValue: selectedIndex) ?? .course)
                UIView.animate(withDuration: 0.1) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
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

enum CoursePlanet: Int {
    case course
    case planet
    
}

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
    func change(to indexAt: Int)
}

class CoursePlanetSegmentedControlView: UIView {
    
    private lazy var buttons: [UIButton] = {
        var buttons: [UIButton] = []
        for title in buttonTitles {
            let button = UIButton(type: .system)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            if #available(iOS 15.0, *) {
                var configuration = UIButton.Configuration.plain()
                configuration.contentInsets = .init(top: 6, leading: 0, bottom: 6, trailing: 0)
                var titleAttribute = AttributedString(title)
                titleAttribute.font = .systemFont(ofSize: 15.0, weight: .bold)
                titleAttribute.foregroundColor = UIColor.white
                configuration.attributedTitle = titleAttribute
                button.configuration = configuration
            }
            
            button.setTitleColor(textColor, for: .normal)
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
                delegate?.change(to: selectedIndex)
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
            make.top.equalTo(self.snp.bottom)
        }
    }
}

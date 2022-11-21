//
//  ReviewButton.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/21.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit

import SnapKit

final class ReviewButton: UIButton {
    var height: CGFloat = 34
    
    private let ticketImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.Image.ticketIcon)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let title = NSAttributedString(string: "별자리 후기", attributes: [.font: UIFont.designSystem(weight: .bold, size: ._13)])
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        self.setAttributedTitle(title, for: .normal)
        self.layer.cornerRadius = 17
        self.setTitleColor(.designSystem(.mainYellow), for: .normal)
        self.backgroundColor = .designSystem(.black)
        self.layer.borderColor = .designSystem(.mainYellow)
        self.layer.borderWidth = 1
        self.sizeToFit()
        self.addTarget(self, action: #selector(executeHaptic(_:)), for: .touchUpInside)
        
        self.addSubview(ticketImageView)
        
        ticketImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func executeHaptic(_ sender: UIButton) {
        HapticManager.instance.selection()
    }
}

// MARK: - BottomHidable
extension ReviewButton: BottomHidable {
    func present() {
        self.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(45)
        }
      
    }
    
    func hide() {
        self.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(-height)
        }
    }
}

//
//  CourseFeedViewController.swift
//  MatStar
//
//  Created by YeongJin Jeong on 2022/10/12.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class CourseFeedViewController: BaseViewController {
    var viewModel: CourseFeedViewModel?

    private var topImage = UIView()
    private var bottomView = UIView()

    private var mapButton = UIButton()
    private var listButton = UIButton()

    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()

        self.view.addSubview(topImage)
        self.view.addSubview(mapButton)
        self.view.addSubview(listButton)
        self.view.addSubview(bottomView)

        //Top Image
        topImage.backgroundColor = .black
        topImage.layer.opacity = 0.5
        topImage.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(self.view).multipliedBy(0.75)
            make.top.left.right.equalToSuperview()
        }

        //Bottom View
        bottomView.backgroundColor = .black
        bottomView.layer.opacity = 0.8
        bottomView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
            make.bottom.equalToSuperview()

        }

        //map button
        mapButton.backgroundColor = .black
        mapButton.tintColor = .white
        mapButton.layer.cornerRadius = 25
        mapButton.layer.opacity = 0.5
        mapButton.layer.masksToBounds = true
        mapButton.setImage(UIImage(systemName: "map.fill"), for: .normal)

        mapButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.top.equalToSuperview().offset(60)
            make.right.equalToSuperview().inset(20)

        }

        listButton.tintColor = .white
        listButton.backgroundColor = .black
        listButton.layer.cornerRadius = 25
        listButton.layer.opacity = 0.5
        listButton.layer.masksToBounds = true
        listButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)

        listButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.top.equalTo(self.mapButton.snp.bottom).offset(20)
            make.leading.equalTo(self.mapButton)
        }
    }
}

// MARK: - UI
extension CourseFeedViewController {
    private func setUI() {
        setAttributes()
        setConstraints()
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setConstraints() {
        
    }
}

//#if DEBUG
//
//import SwiftUI
//struct ViewControllerReperesentable: UIViewControllerRepresentable {
//
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        // empty
//    }
//
//    @available(iOS 13.0.0, *)
//    func makeUIViewController(context: Context) -> UIViewController {
//        CourseFeedViewController()
//    }
//}
//
//@available(iOS 13.0.0, *)
//struct ViewControllerRepresentablePreviewProvider: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ViewControllerReperesentable()
//                .ignoresSafeArea()
//                .previewDisplayName("Preview")
//                .previewDevice(PreviewDevice(rawValue: "iPhone 13"))
//        }
//    }
//}
//#endif

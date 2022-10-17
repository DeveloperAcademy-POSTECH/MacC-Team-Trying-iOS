//
//  HomeViewController.swift
//  MatStar
//
//  Created by uiskim on 2022/10/12.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit
import Lottie

final class HomeViewController: BaseViewController {
    
    var homeDetailView = HomeDetailView()
    var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = homeDetailView
    }
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setAttributes()
    }
    
    @objc
    func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        let screenHeight = UIScreen.main.bounds.height
        if gesture.state == .changed {
            UIView.animate(withDuration: 0.7) {
                self.homeDetailView.constellationCollectionView.alpha = 0
                let scale = CGAffineTransform(scaleX: 0.5, y: 0.5).translatedBy(x: 0, y: -screenHeight)
                self.homeDetailView.myPlanetImage.transform = scale
            }
        } else if gesture.state == .ended {
            if translation.y > -screenHeight / 5 {
                UIView.animate(withDuration: 0.5) {
                    self.homeDetailView.myPlanetImage.transform = .identity
                    self.homeDetailView.constellationCollectionView.alpha = 1
                }
            } else {
                self.homeDetailView.constellationCollectionView.isHidden = true
                self.homeDetailView.myPlanetImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(myPlanetImageTapped)))
            }
        }
    }
    
    @objc
    func myPlanetImageTapped() {
        UIView.animate(withDuration: 0.5) {
            self.homeDetailView.constellationCollectionView.isHidden = false
            self.homeDetailView.constellationCollectionView.alpha = 1
            self.homeDetailView.myPlanetImage.transform = .identity
            self.homeDetailView.homeLottie.play()
        }
    }
    
    @objc
    func courseRegistrationButtonTapped() {
        print("코스등록하기 버튼이 눌림")

    }
    
    @objc
    func alarmButtonTapped() {
        print("알림 버튼이 눌림")
        viewModel.pushToAlarmView()
    }
}

// MARK: - UI
extension HomeViewController {
    func setAttributes() {
        let layout = CustomLayout(numberOfColumns: viewModel.numberOfColum)
        homeDetailView.constellationCollectionView.collectionViewLayout = layout
        layout.delegate = self
        homeDetailView.constellationCollectionView.dataSource = self
        homeDetailView.constellationCollectionView.dragInteractionEnabled = true
        
        homeDetailView.courseRegistrationButton.addTarget(self, action: #selector(courseRegistrationButtonTapped), for: .touchUpInside)
        homeDetailView.myPlanetImage.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture)))
        homeDetailView.alarmButton.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = viewModel.constellations.count
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstellationCollectionViewCell.identifier, for: indexPath) as? ConstellationCollectionViewCell else { return UICollectionViewCell() }
        cell.constellation = viewModel.constellations[indexPath.row]
        return cell
    }
}

extension HomeViewController: CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellDynamicHeight = CGFloat((viewModel.constellations[indexPath.row].image?.size.height ?? 0)) / 4
        return cellDynamicHeight
    }
}

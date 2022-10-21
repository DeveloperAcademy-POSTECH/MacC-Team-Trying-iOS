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
    var changeMyPlanetScale: Double = 0.5
    
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
        let velocity = gesture.velocity(in: homeDetailView.myPlanetImage)
        let screenHeight = UIScreen.main.bounds.height - 20
        let translation = gesture.translation(in: self.homeDetailView.myPlanetImage)
        gesture.setTranslation(.zero, in: self.homeDetailView.myPlanetImage)
        if gesture.state == .changed {
            if abs(velocity.y) > abs(velocity.x) {
                // center변화, alpha변화, scale변화
                self.homeDetailView.myPlanetImage.center = CGPoint(x: self.homeDetailView.myPlanetImage.center.x,
                                                                   y: min(max(self.homeDetailView.myPlanetImage.center.y + translation.y, screenHeight/2), screenHeight))
                self.homeDetailView.constellationCollectionView.alpha = changeAlpht(xPoint: homeDetailView.myPlanetImage.center.y)
                let scaleImage = changeScale(xPoint: homeDetailView.myPlanetImage.center.y)
                self.homeDetailView.myPlanetImage.transform = CGAffineTransform(scaleX: scaleImage, y: scaleImage)
            }
        } else if gesture.state == .ended {
            if self.homeDetailView.myPlanetImage.center.y > screenHeight*6/7 {
                UIView.animate(withDuration: 0.5) {
                    // center변화, alpha변화, scale변화(transform)
                    self.homeDetailView.constellationCollectionView.alpha = 1
                    self.homeDetailView.myPlanetImage.transform = .identity
                    self.homeDetailView.myPlanetImage.center = CGPoint(x: self.homeDetailView.myPlanetImage.center.x, y: screenHeight)
                }
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                    let scale = CGAffineTransform(scaleX: self.changeMyPlanetScale, y: self.changeMyPlanetScale)
                    self.homeDetailView.myPlanetImage.transform = scale
                    self.homeDetailView.myPlanetImage.center = CGPoint(x: self.homeDetailView.myPlanetImage.center.x, y: screenHeight/2)
                    self.homeDetailView.constellationCollectionView.alpha = 0
                } completion: { _ in
                    self.homeDetailView.constellationCollectionView.isHidden = true
                    self.homeDetailView.myPlanetImage.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGestureAfter)))
                }
            }
        }
    }
    
    @objc
    func handlePanGestureAfter(gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: homeDetailView.myPlanetImage)
        let screenHeight = UIScreen.main.bounds.height - 20
        let translation = gesture.translation(in: self.homeDetailView.myPlanetImage)
        if gesture.state == .changed {
            if abs(velocity.y) > abs(velocity.x) {
                homeDetailView.myPlanetImage.center = CGPoint(x: self.homeDetailView.myPlanetImage.center.x,
                                                              y: min(max(self.homeDetailView.myPlanetImage.center.y + translation.y, screenHeight/2), screenHeight))
                self.homeDetailView.constellationCollectionView.isHidden = false
                homeDetailView.constellationCollectionView.alpha = changeAlpht(xPoint: homeDetailView.myPlanetImage.center.y)
                gesture.setTranslation(.zero, in: self.homeDetailView.myPlanetImage)
                let scaleImage = changeScale(xPoint: homeDetailView.myPlanetImage.center.y)
                let scale = CGAffineTransform(scaleX: scaleImage, y: scaleImage)
                self.homeDetailView.myPlanetImage.transform = scale
            }
        } else if gesture.state == .ended {
            if self.homeDetailView.myPlanetImage.center.y < (screenHeight/2)*7/6 {
                UIView.animate(withDuration: 0.3) {
                    self.homeDetailView.constellationCollectionView.alpha = 0
                    self.homeDetailView.constellationCollectionView.isHidden = true
                    self.homeDetailView.myPlanetImage.transform = CGAffineTransform(scaleX: self.changeMyPlanetScale, y: self.changeMyPlanetScale)
                    self.homeDetailView.myPlanetImage.center = CGPoint(x: self.homeDetailView.myPlanetImage.center.x, y: screenHeight/2)
                }
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                    let scale = CGAffineTransform(scaleX: 1, y: 1)
                    self.homeDetailView.myPlanetImage.transform = scale
                    self.homeDetailView.myPlanetImage.center = CGPoint(x: self.homeDetailView.myPlanetImage.center.x, y: screenHeight)
                    self.homeDetailView.constellationCollectionView.alpha = 1
                } completion: { _ in
                    self.homeDetailView.myPlanetImage.removeGestureRecognizer(gesture)
                }
            }
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
    
    func changeScale(xPoint: Double) -> CGFloat {
        return CGFloat(((xPoint * 0.5)/425)+0.0287)
    }
    
    func changeAlpht(xPoint: Double) -> CGFloat {
        return CGFloat((xPoint/400)-1.1125)
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

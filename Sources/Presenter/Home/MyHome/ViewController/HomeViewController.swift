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

final class HomeViewController: BaseViewController{

    private var carouselView: CarouselView?
    let homeDetailView = HomeDetailView()
    let viewModel: HomeViewModel
    let changeMyPlanetScale: Double = 0.5
    let screenHeight = DeviceInfo.screenHeight - 20
    
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
        carouselView = CarouselView(pages: viewModel.constellations.count, delegate: self)
        bind()
        setAttributes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        carouselView?.configureView(with: viewModel.constellations)
    }
    
    
    /// pangesture에 따라서 요소들을 변화시키는 함수
    /// - Parameters:
    ///   - center: 이미지의 center좌표
    ///   - myPlanetTransform: 어떻게 변할지, 주로 scale에 관한 값
    ///   - constellationAlpha: 제스처에따라 alpha값이 변하는 요소는 어떻값으로 변할지
    private func changeMyPlanet(center: CGPoint, myPlanetTransform: CGAffineTransform, constellationAlpha: CGFloat) {
        self.homeDetailView.myPlanetImage.center = center
        self.homeDetailView.myPlanetImage.transform = myPlanetTransform
//        self.homeDetailView.constellationCollectionView.alpha = constellationAlpha
    }
    
    @objc
    func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let myPlanet = self.homeDetailView.myPlanetImage
        let imageCenterY = myPlanet.center.y
        let imageCenterX = myPlanet.center.x
        let translation = gesture.translation(in: myPlanet)
        gesture.setTranslation(.zero, in: myPlanet)
        if gesture.state == .changed {
            if abs(gesture.velocity(in: myPlanet).y) > abs(gesture.velocity(in: myPlanet).x) {
                changeMyPlanet(center: CGPoint(x: imageCenterX, y: min(max(imageCenterY + translation.y, screenHeight/2), screenHeight)),
                               myPlanetTransform: CGAffineTransform(scaleX: changeScale(yPoint: imageCenterY), y: changeScale(yPoint: imageCenterY)),
                               constellationAlpha: changeAlpha(yPoint: imageCenterY))
            }
        } else if gesture.state == .ended {
            if imageCenterY > screenHeight * 6/7 {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5) {
                        self.changeMyPlanet(center: CGPoint(x: imageCenterX, y: self.screenHeight), myPlanetTransform: .identity, constellationAlpha: 1)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                        self.changeMyPlanet(center: CGPoint(x: imageCenterX, y: self.screenHeight/2),
                                            myPlanetTransform: CGAffineTransform(scaleX: self.changeMyPlanetScale, y: self.changeMyPlanetScale),
                                            constellationAlpha: 0)
                    } completion: { _ in
                        myPlanet.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGestureAfter)))
                    }
                }

            }
        }
    }
    
    @objc
    func handlePanGestureAfter(gesture: UIPanGestureRecognizer) {
        let myPlanet = self.homeDetailView.myPlanetImage
        let imageCenterX = myPlanet.center.x
        let imageCenterY = myPlanet.center.y
        let translation = gesture.translation(in: myPlanet)
        gesture.setTranslation(.zero, in: myPlanet)
        if gesture.state == .changed {
            if abs(gesture.velocity(in: myPlanet).y) > abs(gesture.velocity(in: myPlanet).x) {
                changeMyPlanet(center: CGPoint(x: imageCenterX, y: min(max(imageCenterY + translation.y, screenHeight/2), screenHeight)),
                               myPlanetTransform: CGAffineTransform(scaleX: changeScale(yPoint: imageCenterY), y: changeScale(yPoint: imageCenterY)),
                               constellationAlpha: changeAlpha(yPoint: imageCenterY))
            }
        } else if gesture.state == .ended {
            if self.homeDetailView.myPlanetImage.center.y < (screenHeight/2) * 7/6 {
                UIView.animate(withDuration: 0.3) {
                    self.changeMyPlanet(center: CGPoint(x: imageCenterX, y: self.screenHeight/2),
                                   myPlanetTransform: CGAffineTransform(scaleX: self.changeMyPlanetScale, y: self.changeMyPlanetScale),
                                   constellationAlpha: 0)
                }
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                    self.changeMyPlanet(center: CGPoint(x: imageCenterX, y: self.screenHeight), myPlanetTransform: CGAffineTransform(scaleX: 1, y: 1), constellationAlpha: 1)
                } completion: { _ in
                    myPlanet.removeGestureRecognizer(gesture)
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
    
    @objc
    func beforeImageButtonTapped() {
        carouselView?.currentPage -= 1
        carouselView?.carouselCollectionView.scrollToItem(at: NSIndexPath(item: carouselView!.currentPage, section: 0) as IndexPath, at: .left, animated: true)
    }
    
    @objc
    func afterImageButtonTapped() {
        carouselView?.currentPage += 1
        carouselView?.carouselCollectionView.scrollToItem(at: NSIndexPath(item: carouselView!.currentPage, section: 0) as IndexPath, at: .right, animated: true)
    }
    
    /// 이미지의 center위치(y)값에 따라 곱해줄 scale값을 return해주는 함수
    /// - Parameter yPoint: 이미지center의 yPoint
    /// - Returns: 이미지에 곱해줄 scale값
    private func changeScale(yPoint: Double) -> CGFloat {
        // 기울기(기기의 크기별로 대응되도록 계산)
        let gradient = (2*(1 - changeMyPlanetScale))/screenHeight
        // 그래프의 y절편(1차함수기때문에 필요)
        let interceptionY = (2 * changeMyPlanetScale) - 1
        return CGFloat((gradient * yPoint) + interceptionY)
    }
    
    
    /// 이미지의 center(y)값에 따라 곱해줄 alpha값을 return해주는 함수
    /// - Parameter yPoint: 이미지center의 yPoint
    /// - Returns: 이미지에 곱해줄 alpha값
    private func changeAlpha(yPoint: Double) -> CGFloat {
        let gredient = 2/screenHeight
        let interceptionY = -1.0
        return CGFloat((gredient * yPoint) + interceptionY)
    }
}

// MARK: - UI
extension HomeViewController {
    func setAttributes() {
        
        homeDetailView.textButton.setTitle(viewModel.constellations.first?.name, for: .normal)
        homeDetailView.dateLabel.text = viewModel.constellations.first?.data

        self.homeDetailView.textButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(160)
            make.height.equalTo(44)
            guard let text = self.homeDetailView.textButton.currentTitle else {return}
            make.width.equalTo((text as NSString).size().width + 90)
        }

        homeDetailView.currentImage.image = viewModel.constellations.first?.image
        homeDetailView.courseRegistrationButton.addTarget(self, action: #selector(courseRegistrationButtonTapped), for: .touchUpInside)
        homeDetailView.myPlanetImage.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture)))
        homeDetailView.alarmButton.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)
        
        guard let carouselView = carouselView else { return }
        view.addSubview(carouselView)
        carouselView.snp.makeConstraints { make in
            make.top.equalTo(homeDetailView.textButton.snp.bottom).offset(40)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(homeDetailView.myPlanetImage.snp.top).offset(-120)
        }
        
        if viewModel.constellations.count > 1 {
            homeDetailView.afterImageButton.isHidden = false
            homeDetailView.afterImageButton.setImage(self.viewModel.constellations[1].image, for: .normal)
        }
        
        homeDetailView.beforeImageButton.addTarget(self, action: #selector(beforeImageButtonTapped), for: .touchUpInside)
        homeDetailView.afterImageButton.addTarget(self, action: #selector(afterImageButtonTapped), for: .touchUpInside)
        
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

extension HomeViewController: CarouselViewDelegate {
    func currentPageDidChange(to page: Int) {
        self.homeDetailView.textButton.setTitle(self.viewModel.constellations[page].name, for: .normal)
        self.homeDetailView.textButton.snp.updateConstraints { make in
            guard let text = self.homeDetailView.textButton.currentTitle else {return}
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(160)
            make.height.equalTo(44)
            make.width.equalTo((text as NSString).size().width + 90)
        }
        self.homeDetailView.dateLabel.text = self.viewModel.constellations[page].data
        
        self.homeDetailView.currentImage.image = self.viewModel.constellations[page].image
        if page == 0 {
            self.homeDetailView.beforeImageButton.isHidden = true
        } else {
            self.homeDetailView.beforeImageButton.isHidden = false
            self.homeDetailView.beforeImageButton.setImage(self.viewModel.constellations[page-1].image, for: .normal)
        }
        if page == viewModel.constellations.count - 1 {
            self.homeDetailView.afterImageButton.isHidden = true
        } else {
            self.homeDetailView.afterImageButton.isHidden = false
            self.homeDetailView.afterImageButton.setImage(self.viewModel.constellations[page+1].image, for: .normal)
        }
    }
}

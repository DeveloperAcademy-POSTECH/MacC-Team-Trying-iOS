//
//  ToastFactory.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/18.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

final class ToastFactory {

    enum ToastType {
        case error
        case success
        case information

        var color: UIColor? {
            switch self {
            case .error:
                return .systemRed
            case .success:
                return .designSystem(.mainYellow)
            case .information:
                return .designSystem(.mainYellow)
            }
        }
        var messageColor: UIColor? {
            switch self {
            case .error:
                return .designSystem(.white)
            case .success:
                return .designSystem(.black)
            case .information:
                return .designSystem(.black)
            }

        }
        var subTitleMessageColor: UIColor? {
            switch self {
            case .error:
                return .designSystem(.white)
            case .success:
                return .designSystem(.black)
            case .information:
                return .designSystem(.black)
            }
        }
    }

    static func show (
        message: String,
        subMessage: String? = nil,
        type: ToastType = .error,
        duration: TimeInterval = 1.0,
        completion: (() -> Void)? = nil
    ) {

        var toastArea = 50
        if !UIDevice.current.hasNotch {
            toastArea = 20
        }

        guard let window = UIWindow.current else { return }

        window.subviews
            .filter { $0 is ToastView }
            .forEach { $0.removeFromSuperview() }

        let toastView = ToastView(message: message, backgroundColor: type.color, messageColor: type.messageColor)
        window.addSubview(toastView)

        toastView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }

        toastView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9).translatedBy(x: 0, y: CGFloat(-toastArea * 2))

        window.layoutSubviews()
        self.feedbackGenerator.notificationOccurred(.success)

        slideUp(completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                slideDown(completion: {
                    completion?()
                })
            }
        })

        func slideUp(completion: (() -> Void)? = nil) {
            toastView.alpha = 0
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    toastView.alpha = 1
                    toastView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).translatedBy(x: 0, y: CGFloat(toastArea))
                },
                completion: { _ in completion?() }
            )
        }

        func slideDown(completion: (() -> Void)? = nil) {
            toastView.alpha = 1
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    toastView.alpha = 0
                    toastView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9).translatedBy(x: 0, y: CGFloat(-toastArea * 2))
                },
                completion: { _ in
                    toastView.removeFromSuperview()
                    completion?()
                }
            )
        }

    }

    private static let feedbackGenerator = UINotificationFeedbackGenerator()
}

extension UIWindow {
    public static var current: UIWindow? {
        UIApplication.shared.windows.first(where: \.isKeyWindow)
    }
}

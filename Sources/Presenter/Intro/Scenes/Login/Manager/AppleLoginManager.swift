//
//  AppleLoginManager.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/08.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import AuthenticationServices

protocol AppleLoginManagerDelegate: AnyObject {
    func appleLoginFail(_ error: LoginError)
    func appleLoginSuccess(_ user: AppleLoginManager.AppleUser)
}

final class AppleLoginManager: NSObject {
    weak var viewController: UIViewController?
    weak var delegate: AppleLoginManagerDelegate?
}

extension AppleLoginManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        viewController!.view.window!
    }
}

extension AppleLoginManager: ASAuthorizationControllerDelegate {

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let userIdentifier = appleIDCredential.user
            delegate?.appleLoginSuccess(
                AppleUser(userIdentifier: userIdentifier)
            )
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        delegate?.appleLoginFail(.appleLoginError)
    }
}

extension AppleLoginManager {
    struct AppleUser {
        let userIdentifier: String
    }
}

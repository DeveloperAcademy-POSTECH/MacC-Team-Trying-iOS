//
//  KakaoLoginManager.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/08.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import KakaoSDKUser

protocol KakaoLoginManager {
    func kakaoLogin() async throws -> String?
}

class KakaoLoginManagerImpl: KakaoLoginManager {

    func kakaoLogin() async throws -> String? {
        try await withCheckedThrowingContinuation { continuation in
            do {
                if UserApi.isKakaoTalkLoginAvailable() {
                    UserApi.shared.loginWithKakaoTalk { _, error in
                        if let error = error {
                            continuation.resume(with: .failure(error))
                            return
                        }

                        UserApi.shared.me { user, error in
                            if let error = error {
                                continuation.resume(with: .failure(error))
                                return
                            }

                            guard let userID = user?.id as? Int64 else {
                                continuation.resume(with: .failure(LoginError.kakaoLoginError))
                                return
                            }
                            continuation.resume(with: .success(String(userID)))
                        }

                    }
                } else {
                    UserApi.shared.loginWithKakaoAccount { _, error in
                        if let error = error {
                            continuation.resume(with: .failure(error))
                            return
                        }

                        UserApi.shared.me { user, error in
                            if let error = error {
                                continuation.resume(with: .failure(error))
                                return
                            }

                            guard let userID = user?.id as? Int64 else {
                                continuation.resume(with: .failure(LoginError.kakaoLoginError))
                                return
                            }
                            continuation.resume(with: .success(String(userID)))
                        }
                    }
                }
            }
        }
    }
}

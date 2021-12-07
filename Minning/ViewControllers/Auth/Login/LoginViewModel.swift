//
//  LoginViewModel.swift
//  Minning
//
//  Copyright © 2021 Minning. All rights reserved.
//

import CommonSystem
import Foundation
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

final class LoginViewModel: ObservableObject {
    public var emailValue: DataBinding<String?> = DataBinding(nil)
    
    private let coordinator: AuthCoordinator
    
    public init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
        let _ = TokenManager.shared.deleteAllTokenData()
    }
    
    public func processEmailCheck() {
        if let email = emailValue.value {
            AuthAPIRequest.checkEmailExist(email: email, completion: { result in
                switch result {
                case .success(let response):
                    self.goToPassword(email: email, isLogin: response.data.exist)
                case .failure(let error):
                    ErrorLog(error.defaultError.localizedDescription)
                }
            })
        } else {
            ErrorLog("Email을 입력해주세요.")
        }
    }
    
    private func goToPassword(email: String, isLogin: Bool) {
        coordinator.goToPassword(animated: true, isLogin: isLogin, email: email)
    }
    
    public func goToNicknameBySocial(socialType: SocialType, socialToken: String, email: String) {
        coordinator.goToNickname(email: email, password: nil,
                                 socialToken: socialToken, isSocial: true, socialType: socialType)
    }
    
    public func goToMain() {
        coordinator.goToMain()
    }
    
    public func processSocialCheck(socialType: SocialType, token: String) {
        let socialRequest = SocialRequest(socialType: socialType, token: token)
        DebugLog("Social Check API Start")
        AuthAPIRequest.socialCheck(request: socialRequest, completion: { result in
            switch result {
            case .success(let response):
                if response.data.processes == .signUp {
                    // 회원이 아닌 경우
                    DebugLog("Message : \(response.message.msg)")
                    DebugLog("Email Generated By Server: \(response.data.userData?.email ?? "nil" )")
                    if let userData = response.data.userData {
                        self.goToNicknameBySocial(socialType: socialType,
                                                  socialToken: token,
                                                  email: userData.email)
                    }
                } else {
                    // 회원인 경우
                    if let tokenData = response.data.tokenData {
                        let epochTime = TimeInterval(tokenData.expiresIn) / 1000
                        DebugLog("SocialCheck AccessToken : \(tokenData.accessToken), EpochTime: \(epochTime)")
                        
                        let setAccessTokenResult = TokenManager.shared.setAccessToken(token: tokenData.accessToken)
                        let setRefreshTokenResult = TokenManager.shared.setRefreshToken(token: tokenData.refreshToken)
                        let setExpiredInResult = TokenManager.shared.setAccessTokenExpiredDate(expiredAt: Date(timeIntervalSince1970: epochTime))
                        
                        if setAccessTokenResult && setRefreshTokenResult && setExpiredInResult {
                            self.goToMain()
                        }
                    }
                }
            case .failure(let error):
                ErrorLog("ERROR: \(error.defaultError.localizedDescription)")
            }
        })
    }
    
    public func requestKakaoTalkLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    ErrorLog(error.localizedDescription)
                } else {
                    // Kakao Login Success
                    if let accessToken = oauthToken?.accessToken {
                        self.getKakaoUserInfo(token: accessToken)
                    }
                }
            }
        } else {
            requestKakaoAccountLogin()
        }
    }
    
    private func requestKakaoAccountLogin() {
        UserApi.shared.loginWithKakaoAccount { oauthToken, error in
            if let error = error {
                ErrorLog(error.localizedDescription)
            } else {
                DebugLog("loginWithKakaoAccount() success ===> \(String(describing: oauthToken))")
                if let accessToken = oauthToken?.accessToken {
                    self.getKakaoUserInfo(token: accessToken)
                }
            }
        }
    }
    
    private func getKakaoUserInfo(token: String) {
        UserApi.shared.me(completion: { user, error in
            if let error = error {
                ErrorLog(error.localizedDescription)
            } else {
                DebugLog("me() success.")
                
                if let kakaoUser = user {
                    DebugLog("nickname: \(kakaoUser.kakaoAccount?.profile?.nickname ?? "nil")")
                    DebugLog("userId: \(String(describing: kakaoUser.id))")
                    DebugLog("Email: \(kakaoUser.kakaoAccount?.email ?? "nil")")
                    self.processSocialCheck(socialType: .kakao, token: token)
                }
            }
        })
    }
}

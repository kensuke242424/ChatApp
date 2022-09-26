//
//  FirebaseUIView.swift
//  ChatApp
//
//  Created by 中川賢亮 on 2022/08/19.
//

import SwiftUI
import FirebaseAuthUI
import FirebaseGoogleAuthUI

struct FirebaseUIView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UINavigationController {

        let authUI = FUIAuth.defaultAuthUI()!

        // 必要なログインパターンの種類を入れる 今回はGoogleアカウントログインのみ
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(authUI: authUI)
        ]
        authUI.providers = providers

        // FirebaseUIを表示するために必要
        let authViewController = authUI.authViewController()

        return authViewController
    } // makeUIViewController ここまで

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // 処理なし
    } // updateUIViewController ここまで
}

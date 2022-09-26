//
//  ChatAppApp.swift
//  ChatApp
//
//  Created by 中川賢亮 on 2022/08/17.
//

import SwiftUI
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        return true

    } // func

    // GoogleおよびFacebookのログインのフローの結果を処理するハンドラー
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {

        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?

        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {

            return true

        } // if

            return false

    } // func
} // class

// @mainはSwift5.3の新属性で、あるタイプをエントリーポイントとしてプログラムを実行する
// 通常Swiftプログラムの実行にはmain.swiftファイルが必要ですが、
// @mainによりその責任を抽象的に委任することが可能
@main
struct ChatAppApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    // Scene ⇨ iOS14で、SwiftUIに導入された新しいアプリケーションライフサイクルの一環です。
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}

//
//  ChatViewModel.swift
//  ChatApp
//
//  Created by 中川賢亮 on 2022/08/28.
//

import FirebaseAuth
import FirebaseFirestore

class UserSignManeger: ObservableObject {

    @Published var signInState: Bool = false

    // typealias AuthStateDidChangeListenerHandle = NSObjectProtocol
    // NSObjectProtocol ⇨ Objective-Cのすべてのオブジェクトの基本となるメソッド群
    private var handle: AuthStateDidChangeListenerHandle!

    init() {
        print("Sign Check...")
        // ログインしているユーザーに関する情報を必要とするアプリの各ビューに対して、FIRAuth オブジェクトにリスナーをアタッチします。このリスナーは、ユーザーのログイン状態が変わるたびに呼び出されます。
        // (auth, user)のauthを使用しないため、"_"で省略
        handle = Auth.auth().addStateDidChangeListener { (_, user) in

            // マネージャ呼び出し時にログアウト状態だった場合 ⇨ <サインイン>
            if user != nil {

                print("<<<<<< Sign-in >>>>>>")
                self.signInState = true

            // マネージャ呼び出し時にログイン状態だった場合   ⇨ <サインアウト>
            } else {

                print("<<<<<< Sign-out >>>>>>")
                self.signInState = false

            } // if (マネージャ呼び出し時のログイン状態分岐)
        }
    } // init

    // deinit ⇨ デイニシャライザ
    // クラスのインスタンスが破棄されるときに自動的に呼ばれる特殊なメソッド(構造体にでイニシャライザはない)
    // メモリに確保されたインスタンスやプロパティはARC（Automatic reference counting）によって自動的に破棄されるので通常はデイニシャライザを記述する必要はないが、
    // 例えばファイルを扱うクラスで、開いたファイルをインスタンスの破棄時に確実に閉じるためにデイニシャライザを利用することができる。
    deinit {
        Auth.auth().removeStateDidChangeListener(handle)
    }

    // ✅ ログアウト処理を実行する関数
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign-out Error")
        }
    }

} // class

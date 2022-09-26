//
//  UserListViewModel.swift
//  ChatApp
//
//  Created by 中川賢亮 on 2022/09/01.
//

import Firebase

class UserListViewModel: ObservableObject {

    init() {
        print("<<<<<<<<< UserListViewModel.init >>>>>>>>>>")
    }

    @Published var userDataList = [UserData]()

    let db = Firestore.firestore() // swiftlint:disable:this identifier_name
    let logInUserData = Auth.auth().currentUser!
    var listener: ListenerRegistration?

    // ✅ リストに表示するユーザデータを取得するメソッド
    func fetchUserList() {
        print("<fetchUserListメソッド実行>")

        // Firestoreの"users"というコレクションからデータ(オブジェクト)を取得
        // 処理後、errorに値があった場合エラー通知 snapに値があった場合、データ保存処理を実行
        listener = db.collection("users").addSnapshotListener { (snap, _) in

            guard let documents = snap?.documents else {
                print(" No Documents")
                return
            } // guard

            self.userDataList = documents.compactMap { (snap) -> UserData? in

                // doc内のすべてのフィールドを取得し、呼び出し元が指定した型のインスタンスに変換します。
                return try? snap.data(as: UserData.self)
            }

            // 取得したユーザリストの中にログインユーザ情報が存在するか確認
            // nilだった場合新規ログイン ⇨ ユーザ情報保存処理実行
            let result = self.userDataList.filter { $0.userID.contains(self.logInUserData.uid) }

            if result.isEmpty {
                self.addUserData()
            } else {
                print("　⇨ログインしたユーザは既にデータ登録済")
            }

            // ユーザリストからログインユーザのuidが含まれたデータを除外(自身はリストに表示しないため)
            self.userDataList.removeAll(where: {
                $0.userID.contains(self.logInUserData.uid) })

        } // addSnapshotListener
    } // func fetchUserData

    // ✅Firestoreに新規ユーザ情報を保存するメソッド
    private func addUserData() {
        print("<addUserDataメソッド実行>")

        // photoURLはデータ保存時にabsoluteStringを使用しないと、アプリ起動時にクラッシュする
        let userID = logInUserData.uid
        let name = logInUserData.displayName ?? "No Name"
        let photoURL = logInUserData.photoURL?.absoluteString ?? ""

        let userData = UserData(name: name, userID: userID, photoURL: photoURL)

        // addDocument(from:) → Codable準拠の構造体をエンコードし保存
        do {
            _ = try db.collection("users").addDocument(from: userData)
            print(" New_addDocument")
        } catch {
            print(" ⇨New_addDocument_error")
        }
    } // func addUserData ここまで

    deinit {
        print("<<<<<<<<< UserListViewModel.deinit >>>>>>>>>>")
        listener?.remove()

    } // deinit
} // class

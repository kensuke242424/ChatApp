//
//  MessageViewModel.swift
//  ChatApp
//
//  Created by 中川賢亮 on 2022/09/10.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class MessageViewModel: ObservableObject {

    @Published var messageDataList: [MessageData] = []

    // リスナー表す変数
    // remove を呼び出すことで削除できるリスナーを表す。(Documentより)
    var listener: ListenerRegistration?
    var db: Firestore? = Firestore.firestore() // swiftlint:disable:this identifier_name

    init() {
        print("<<<<<<<<<  MessageViewModel_init  \(ObjectIdentifier(self).hashValue) >>>>>>>>>")
    }
    // ✅ Firestoreからメッセージデータ取得
    func fetchMessageData(fromUID: String, toUID: String) {
        print("<fetchMessageDataメソッド実行>")

        let roomID = [fromUID, toUID].sorted().joined(separator: "/")

        // roomIDを用いてフィルタリングされたmessageコレクションデータからオブジェクトを取得
        // snapに値が存在した場合データ取得処理を実行 なければguardで処理終了
        listener = db!.collection("message/\(roomID)").addSnapshotListener { (snap, _) in

            guard let documents = snap?.documents else {
                print("collection_message/\(roomID)_No Documents")
                return
            } // guard

            // compactMap -> map後の値からnilを除去して渡す
            self.messageDataList = documents.compactMap { (snap) -> MessageData? in

                // doc内のすべてのフィールドを取得し、呼び出し元が指定した型のインスタンスに変換します。
                // data: ⇨ 取り出したデータを格納するオブジェクトを指定
                // with: ⇨ ServerTimestampを扱う際のオプションを指定
                return try? snap.data(as: MessageData.self, with: .estimate)
            }
            // TimestampをDate型に直して、メッセージを並び替えソート
            self.messageDataList.sort { before, after in
                return before.createAt!.dateValue() < after.createAt!.dateValue() ? true : false
            }

        } // addSnapshotListener
        
    } // func fetchMessageData

    func addMessage(messageData: MessageData, fromUID: String, toUID: String) {

        let roomID = [fromUID, toUID].sorted().joined(separator: "/")

        // Encodableのインスタンスをエンコードし、エンコードされたデータで新しいドキュメントを
        // このコレクションに追加し、ドキュメントIDを自動的に割り当てる
        do {
            _ = try db!.collection("message/\(roomID)").addDocument(from: messageData)

        } catch {
            print("addMessage_error")
        }

    } // addMessage

    deinit {

        print("<<<<<<<<<  MessageViewModel_deinit   \(ObjectIdentifier(self).hashValue)  >>>>>>>>>")
        listener?.remove()
    }

} // class
// SsjY0hoaEbS21shOOjkQgukl7KJ2/C37tfqY9BJg1jdVTiRBTppZehXC3

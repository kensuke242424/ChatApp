//
//  MessageView.swift
//  ChatApp
//
//  Created by 中川賢亮 on 2022/09/10.
//

import SwiftUI
import FirebaseAuth

struct MessageView: View {

    @StateObject private var messageVM = MessageViewModel()

    @State private var inputMessageText = ""
    let fromUID: String
    let toUID: String

    var body: some View {

        // チャットデータ読み込みによるメモリ圧迫ののリスク観点から、処理が軽いLazyVGlidを使用(遅延読み込み) iOS14~
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 1)) {

                ForEach(messageVM.messageDataList) { message in

                    MessageRow(message: message.message,

                               isMyMessage: fromUID == message.userID ? true : false)

                } // ForEach
            } // LazyVGrid
        } // ScrollView (ルーム表示メッセージデザインここまで)

        Spacer()

        // メッセージ入力ボックス
        HStack {

            TextField("Message", text: $inputMessageText)
                .textFieldStyle(.roundedBorder)
                .cornerRadius(5)

                // エンターキー実行後の処理

                .onSubmit {
                    // テキストボックスに値が存在しなかった場合、処理を終了
                    guard inputMessageText.count != 0 else { return }

                    let data = MessageData(userID: fromUID,
                                           message: inputMessageText)

                    messageVM.addMessage(messageData: data, fromUID: fromUID, toUID: toUID)


                    inputMessageText = ""
                } // onSubmit

            Button {
                // テキストボックスに値が存在しなかった場合、処理を終了
                guard inputMessageText.count != 0 else { return }

                let data = MessageData(userID: fromUID,
                                       message: inputMessageText)

                messageVM.addMessage(messageData: data, fromUID: fromUID, toUID: toUID)

                inputMessageText = ""

            } label: {

                Image(systemName: "arrow.up.circle.fill")

            } // Button(保存メソッド)
        } // HStack (入力ボックスデザインここまで)
        .padding([.leading, .bottom, .trailing])

        // ⬇︎のModifierはiOS14から使えるようになっており、
        // これまでの.navigationBarTitle()はDeprecated（非推奨）
        .navigationTitle("Chats")
        .navigationBarTitleDisplayMode(.inline)

        // MessageView生成時のタイミングで、自身と相手のuidを引き渡して、ルーム内に表示するメッセージデータを取得
        .onAppear {

            messageVM.fetchMessageData(fromUID: fromUID, toUID: toUID)

        } // onAppear
    } // body
} // View

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(fromUID: "", toUID: "")
    }
}

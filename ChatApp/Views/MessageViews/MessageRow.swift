//
//  MessageRow.swift
//  ChatApp
//
//  Created by 中川賢亮 on 2022/09/10.
//

import SwiftUI

struct MessageRow: View {

    let message: String
    let isMyMessage: Bool

    var body: some View {

        // 👨メッセージが自身の発信だったら(右寄せ)
        if isMyMessage {

            HStack {
                Spacer()

                Text(message)

                    .padding(8)
                    .background(.green)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
            .padding()

        // 👩メッセージが相手の発信だったら(左寄せ)
        } else {

            HStack {

                Text(message)
                    .padding(8)
                    .background(Color.toMessageColor)
                    .cornerRadius(8)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding()

        } // if(メッセージ発信者の分岐)
    } // body
} // View

struct MessageRow_Previews: PreviewProvider {
    static var previews: some View {
        MessageRow(message: "ありがとう", isMyMessage: true)
    }
}

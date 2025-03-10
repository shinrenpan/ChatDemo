//
//  MyCell.swift
//  Room
//
//  Created by Joe Pan on 2025/3/9.
//

import SwiftUI

struct MyCell: View {
    @SwiftUI.State private var message: DisplayMessage
    
    init(message: DisplayMessage) {
        self.message = message
    }
    
    var body: some View {
        HStack {
            Spacer(minLength: 80)
            VStack(alignment: .trailing, spacing: 8) {
                Text(message.name)
                Text(message.content)
                    .foregroundStyle(.white)
                    .padding()
                    .background(.blue)
                    .clipShape(.rect(cornerRadius: 10))
            }
        }
    }
}

struct TargetCell: View {
    @SwiftUI.State private var message: DisplayMessage
    
    init(message: DisplayMessage) {
        self.message = message
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(message.name)
                Text(message.content)
                    .foregroundStyle(.white)
                    .padding()
                    .background(.gray)
                    .clipShape(.rect(cornerRadius: 10))
            }
            Spacer(minLength: 80)
        }
    }
}

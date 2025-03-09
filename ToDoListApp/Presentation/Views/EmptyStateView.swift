//
//  EmptyStateView.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/7/25.
//

import SwiftUI

struct EmptyStateView: View {
    let preferredSize: CGFloat = 20

    var body: some View {
        ZStack {
//            Color.myBackground.ignoresSafeArea()

            VStack(spacing: 10) {
                Image(systemName: "tray.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.myDestructive)

                Spacer().frame(height: 4)

                Text("추가한 할 일이 없습니다.")
                    .font(.system(size: preferredSize, weight: .bold))
                    .foregroundColor(Color.myTextPrimary)
                    .multilineTextAlignment(.center)

                Text("새로운 할 일을 추가해보세요!")
                    .font(.system(size: preferredSize * 0.85))
                    .foregroundColor(Color.myTextSecondary)
            }
            .frame(minWidth: 200, maxWidth: 350, minHeight: 150, maxHeight: 250)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.myContainer)
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
            )
            .padding(.horizontal)
        }
    }
}

#Preview {
    EmptyStateView()
}

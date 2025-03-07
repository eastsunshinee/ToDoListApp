//
//  EmptyStateView.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/7/25.
//

import SwiftUI

struct EmptyStateView: View {
    let message: String // ✅ 외부에서 메시지 설정 가능

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "list.bullet.rectangle")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.primaryColor.opacity(0.7)) // ✅ 브랜드 컬러 반영

            Text(message)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.textColor.opacity(0.8)) // ✅ 가독성 개선
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            Text("할 일을 추가해보세요!")
                .font(.subheadline)
                .foregroundColor(.textColor.opacity(0.6))
        }
        .padding(.top, 60)
    }
}

// ✅ Preview
#Preview {
    EmptyStateView(message: "등록된 할 일이 없습니다.")
        .previewLayout(.sizeThatFits)
        .padding()
}

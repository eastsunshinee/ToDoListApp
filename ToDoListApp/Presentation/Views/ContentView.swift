//
//  ContentView.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/2/25.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        Text("Select an item")
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView()
}

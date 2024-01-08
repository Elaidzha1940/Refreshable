//  /*
//
//  Project: Refreshable
//  File: Refreshable.swift
//  Created by: Elaidzha Shchukin
//  Date: 08.01.2024
//
//  */

import SwiftUI

final class RefreshableDataService {
    
    func getData() async throws -> [String] {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        return ["Banana", "Melon", "Apple"].shuffled()
    }
}

@MainActor
final class RefreshableViewModel: ObservableObject {
    @Published private(set) var items: [String] = []
    let manager = RefreshableDataService()
    
    func loadData() async {
        do {
            items = try await manager.getData()
        } catch {
            print(error)
        }
    }
}

struct Refreshable: View {
    @StateObject private var viewModel = RefreshableViewModel()
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(viewModel.items, id: \.self) { item in
                        Text(item)
                            .font(.headline)
                    }
                }
            }
            .refreshable {
                await viewModel.loadData()
            }
            .navigationTitle("Refreshable")
            .task {
                await viewModel.loadData()
                
            }
        }
    }
}

#Preview {
    Refreshable()
}

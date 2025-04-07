//
//  AppSidebar.swift
//  MagicDesign
//
//  Created by USOV Vasily on 17.02.2025.
//

import SwiftUI

/// Side (right) panel with additional functions
public struct AppSidebar<Content: View>: View {
    
    @ViewBuilder var content: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        Form {
            content()
        }
        .frame(width: 350)
        .scrollContentBackground(.hidden)
        .formStyle(.grouped)
    }
    
}

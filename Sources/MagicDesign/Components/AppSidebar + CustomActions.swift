//
//  Sidebar.swift
//  RaifMagic
//
//  Created by USOV Vasily on 06.03.2025.
//

import SwiftUI
import RaifMagicCore

// TODO: Move to MagicOperation. This requires MagicDesign dependency on MagicIntegration
public struct SidebarCustomSections: View {
    
    private let sections: [CustomActionSection]
    
    public init(sections: [CustomActionSection]) {
        self.sections = sections
    }
    
    public var body: some View {
        ForEach(sections) { section in
            SidebarSectionView(section: section)
        }
    }
}

public struct SidebarSectionView: View {
    
    private let section: CustomActionSection
    
    public init(section: CustomActionSection) {
        self.section = section
    }
    
    public var body: some View {
        Section(section.title) {
            ForEach(section.items, id: \.id) { item in
                if let operation = item as? CustomOperation {
                    SidebarCustomOperationView(operation: operation)
                } else if let webLink = item as? CustomWebLink {
                    SidebarCustomWebLinkView(webLink: webLink)
                }
            }
        }
    }
}

public struct SidebarCustomWebLinkView: View {
    
    let webLink: CustomWebLink
    @State private var showAlertMessage: String? = nil
    @Environment(\.openURL) private var openURL
    
    public var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(webLink.title)
                if let description = webLink.description {
                    Text(description)
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            }
            Spacer()
            Button {
                if let confirmationMessage = webLink.confirmationDescription {
                    showAlertMessage = confirmationMessage
                } else {
                    openURL(webLink.url)
                }
            } label: {
                Image(systemName: "network")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 10)
            }
        }
        .frame(minHeight: 40)
        .alert("Внимание", isPresented: Binding(get: {
            showAlertMessage != nil
        }, set: { _ in
            showAlertMessage = nil
        }), presenting: showAlertMessage, actions: { _ in
            Button("Открывай", action: {
                openURL(webLink.url)
            })
            Button("Отмена", role: .cancel, action: {})
        }, message: { Text($0) })
    }
}

public struct SidebarCustomOperationView: View {
    
    let operation: CustomOperation
    @State private var showAlertMessage: String? = nil
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    public init(operation: CustomOperation) {
        self.operation = operation
    }
    
    public var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(operation.title)
                if let description = operation.description {
                    Text(description)
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            }
            Spacer()
            Button {
                if let confirmationMessage = operation.confirmationDescription {
                    showAlertMessage = confirmationMessage
                } else {
                    Task {
                        await operation.closure()
                    }
                }
            } label: {
                Image(systemName: operation.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 10)
            }
            .opacity(isEnabled == false ? 0.3 : 1)
            .disabled(isEnabled == false)
        }
        .frame(minHeight: 40)
        .alert("Внимание", isPresented: Binding(get: {
            showAlertMessage != nil
        }, set: { _ in
            showAlertMessage = nil
        }), presenting: showAlertMessage, actions: { _ in
            Button("Поехали!", action: {
                Task {
                    await operation.closure()
                }
            })
            Button("Отмена", role: .cancel, action: {})
        }, message: { Text($0) })
    }
}

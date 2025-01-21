//
//  Avatar.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 23/12/24.
//
import SwiftUI

struct AvatarView: View {
    
    let avatar: UIImage?
    let pending: UIImage?
    
    var body: some View {
        
        if let image = pending {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 90)
                .avatarStyle
        } else if let avatar = avatar {
            Image(uiImage: avatar)
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 90)
                .avatarStyle
        } else {
            Image(systemName: "person")
                .resizable()
                .scaledToFit()
                .symbolVariant(.fill)
                .padding()
                .frame(width: 90, height: 90)
                .foregroundColor(Color("FirstGreen"))
                .avatarStyle
        }
    }
}

#Preview {
    AvatarView(avatar: nil, pending: nil)
}


// MARK: - Avatar Style

fileprivate struct AvatarStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                Color(white: 0.9)
            }
            .clipShape(Circle())
            .shadow(color: .primary.opacity(0.4), radius: 5, x: 0, y: 5)
    }
}

extension View {
    var avatarStyle: some View {
        modifier(AvatarStyle())
    }
}

//
//  CampaignCell.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 17/11/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct Sender {
    let iconName: String
    let username: String
}

struct CampaignCell: View {
    
    let imageNamed: String
    let badgeCount: Int?
    let title: String
    let sender: Sender?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            if let sender = sender {
                HStack() {
                    Image(sender.iconName)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    Text(sender.username)
                }
            }
            
            ZStack(alignment: .topTrailing) {
                Image(imageNamed)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 165)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                
                if let badgeCount = badgeCount {
                    ZStack {
                        Circle()
                            .foregroundColor(.red)
                            .frame(width: 30, height: 30)
                            .shadow(radius: 10)
                        
                            Text("\(badgeCount)")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                    }
                    .offset(y: -10)
                }
            }
            
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
            
            HStack(spacing: 40) {
                HStack {
                    Image(systemName: "calendar")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.Style.grayLight)
                        .frame(width: 24)
                    Text("21 SET 2020")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(Color.Style.grayLight)
                }
                
                HStack {
                    Image(systemName: "clock")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.Style.grayLight)
                        .frame(width: 24)
                    Text("15h30")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(Color.Style.grayLight)
                }
            }
            
            HStack {
                Image(systemName: "person.3.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: 24)
                Text("ASSISTÊNCIA SOCIAL")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.white)
            }
            
            HStack {
                Image(systemName: "wifi")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.Style.blueFade)
                    .frame(width: 24)
                Text("EVENTO ONLINE")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(Color.Style.blueFade)
            }
            
            HStack(spacing: 10) {
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.green)
                        .frame(width: 24)
                    Text("DOAÇÃO FINANCEIRA")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(.green)
                }
                
                HStack {
                    Image(systemName: "gift.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.Style.red)
                        .frame(width: 24)
                    Text("DOAÇÃO DE ITEM")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(Color.Style.red)
                }
            }
            
            HStack {
                Image(systemName: "hand.wave")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: 24)
                Text("+4 VOLUNTÁRIO")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.white)
            }
            
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.Style.blueLight)
                    .frame(width: 24)
                Text("+6 VOLUNTÁRIO PROFISSIONAL")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(Color.Style.blueLight)
            }
        }
    }
}

struct CampaignCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CampaignCell(imageNamed: "campaignExample1", badgeCount: 2, title: "DOAÇÃO DE SANGUE UNIDADE PARAÍSO", sender: nil)
            CampaignCell(imageNamed: "campaignExample1", badgeCount: 2, title: "DOAÇÃO DE SANGUE UNIDADE PARAÍSO", sender: Sender(iconName: "unip", username: "INST. CARENTE UNIVERSIDADE PAULISTA"))
        }
    }
}

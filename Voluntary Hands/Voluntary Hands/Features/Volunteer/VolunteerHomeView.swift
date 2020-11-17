//
//  VolunteerHomeView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 17/11/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct VolunteerHomeView: View {
    @State private var filteredText = ""
    @State private var selectedTab = "house.fill"
    var tabs = ["house.fill", "heart", "person.fill"]
    
    var body: some View {
        VStack(spacing: 0) {
            
            content
            
            HStack(spacing: 0) {
                ForEach(tabs, id: \.self) { image in
                    TabButton(image: image, selectedTab: $selectedTab)

                    if image != tabs.last {
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 5)
            .padding(.bottom, 10)
            .background(Color.Style.grayMedium)
            .shadow(radius: 10)
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    var content: some View {
        ScrollView(.vertical, showsIndicators: true) {
            Spacer(minLength: 20)
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("BEM-VINDO,")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("THIAGO CENTURION")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                }
                
                HStack(spacing: 10) {
                    HStack(spacing: 15) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.Style.grayLight)
                        TextField("BUSCAR CAMPANHA", text: $filteredText)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .keyboardType(.webSearch)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .background(Color.Style.grayMedium)
                    .clipShape(Capsule())
                    
                    Button(action: { }) {
                        Image(systemName: "slider.horizontal.3")
                            .resizable()
                            .foregroundColor(Color.Style.grayLight)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                    }
                    .frame(width: 23, height: 23)
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .background(Color.Style.grayMedium)
                    .clipShape(Circle())
                }
                
                Text("CAMPANHAS").font(.system(size: 24, weight: .bold, design: .rounded))
                
                LazyVStack(alignment: .leading, spacing: 40, content: {
                    CampaignCell(imageNamed: "campaignExample1", badgeCount: nil, title: "DOAÇÃO DE SANGUE UNIDADE PARAÍSO", sender: Sender(iconName: "unip", username: "INST. CARENTE UNIVERSIDADE PAULISTA"))
                    CampaignCell(imageNamed: "campaignExample2", badgeCount: nil, title: "CAMPANHA DE NATAL PARA CRIANÇAS CARENTES", sender: Sender(iconName: "unip", username: "INST. CARENTE UNIVERSIDADE PAULISTA"))
                    CampaignCell(imageNamed: "campaignExample3", badgeCount: nil, title: "CAMPANHA INVERNO SOLIDÁRIO", sender: Sender(iconName: "unip", username: "INST. CARENTE UNIVERSIDADE PAULISTA"))
                    CampaignCell(imageNamed: "campaignExample4", badgeCount: nil, title: "CAMPANHA CONTRA ABANDONO DE ANIMAIS", sender: Sender(iconName: "unip", username: "INST. CARENTE UNIVERSIDADE PAULISTA"))
                    CampaignCell(imageNamed: "campaignExample5", badgeCount: nil, title: "AJUDA HUMANITÁRIA NO SERTÃO NORDESTINO", sender: Sender(iconName: "unip", username: "INST. CARENTE UNIVERSIDADE PAULISTA"))
                })
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 27.5)
        .background(Color.Style.grayDark)
        .ignoresSafeArea(.container, edges: .vertical)
    }
}

struct VolunteerHomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                VolunteerHomeView()
            }
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
    }
}

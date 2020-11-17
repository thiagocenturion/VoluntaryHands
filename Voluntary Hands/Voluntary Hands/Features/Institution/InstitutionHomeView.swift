//
//  InstitutionHome.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 20/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct InstitutionHomeView: View {
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
            .background(Color.Style.grayMedium)
            .shadow(radius: 10)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    var content: some View {
        ScrollView(.vertical, showsIndicators: true) {
            Spacer(minLength: 20)
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("BEM-VINDO,")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("INST. CARENTE UNIVERSIDADE PAULISTA")
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
                
                VStack(alignment: .leading) {
                    Text("MINHAS")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("CAMPANHAS")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                }
                
                LazyVStack(alignment: .leading, spacing: 40, content: {
                    CampaignCell(imageNamed: "campaignExample1", badgeCount: 2, title: "DOAÇÃO DE SANGUE UNIDADE PARAÍSO", sender: nil)
                    CampaignCell(imageNamed: "campaignExample2", badgeCount: 5, title: "CAMPANHA DE NATAL PARA CRIANÇAS CARENTES", sender: nil)
                    CampaignCell(imageNamed: "campaignExample3", badgeCount: 1, title: "CAMPANHA INVERNO SOLIDÁRIO", sender: nil)
                    CampaignCell(imageNamed: "campaignExample4", badgeCount: 1, title: "CAMPANHA CONTRA ABANDONO DE ANIMAIS", sender: nil)
                    CampaignCell(imageNamed: "campaignExample5", badgeCount: 2, title: "AJUDA HUMANITÁRIA NO SERTÃO NORDESTINO", sender: nil)
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

struct TabButton: View {
    var image: String
    @Binding var selectedTab: String
    
    var body: some View {
        Button(action: { }) {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(selectedTab == image ? Color.Style.blueFade : Color.white)
                .frame(height: 24)
                .padding()
        }
    }
}

struct InstitutionHome_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                InstitutionHomeView()
            }
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
    }
}

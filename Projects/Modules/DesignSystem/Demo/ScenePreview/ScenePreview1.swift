//
//  ScenePreview1.swift
//  DesignSystemDemoApp
//
//  Created by minsone on 2021/07/21.
//  Copyright © 2021 minsone. All rights reserved.
//

import Foundation
import SwiftUI
import DesignSystem
import ResourcePackage

#if  DEBUG
/// 입출금통장 개설 완료
struct ScenePreview1_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 0) {
                Image(uiImage: R.Image.imgConfirm_Normal)
                
                Spacer()
                    .frame(height: 16)
                
                Text("입출금통장 개설완료")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                    .frame(height: 16)
                
                Text("입출금 통장이 개설되었습니다.\n아래의 내용을 확인해주세요.")
                    .lineSpacing(8)
                    .multilineTextAlignment(.center)
                    .font(.headline)
                
                Spacer()
                    .frame(height: 30)
                
                VStack(spacing: 8) {
                    SeperateLine.Gray()
                    
                    BothSideText(title: "계좌종류", detail: "입출금(한도계좌)")
                    
                    SeperateLine.Gray()
                    
                    BothSideText(title: "1일 이체한도", detail: "1일 최대 200만원")
                    
                    SeperateLine.Gray()
                    
                    BothSideText(title: "1회 이체한도", detail: "1회 최대 200만원")
                    
                    SeperateLine.Gray()
                }
                
                Spacer()
                    .frame(height: 24)
                
                Button(action: {
                    
                }, label: {
                    Text("입출금 알림 설정하기")
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                })
                .buttonStyle(BorderButtonStyle())
            }
            .padding(24)
            
            Spacer()
            
            Button(action: {
                
            }, label: {
                Text("입출금 알림 설정하기")
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .foregroundColor(.black)
            })
            .background(Color(#colorLiteral(red: 0.9932666421, green: 0.8696673512, blue: 0.1387533247, alpha: 1)))
        }
    }
}

struct BorderButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? .gray : .black)
            .border(Color.gray, width: 1)
    }
}

#endif
//https://swiftuirecipes.com/blog/custom-swiftui-button-with-disabled-and-pressed-state

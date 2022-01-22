//
//  ModalView.swift
//  Bloom
//
//  Created by Gerardo on 10/16/21.
//

import SwiftUI

struct PickerView: View {
    @State private var curHeight: CGFloat = 400
    @State private var isSlide = false
    
    
    @State private var bright: Double = 1.0
    
    @Binding var value: CGFloat
    
    @State private var hue: Double = 0.0
    @State private var sat: Double = 0.0
    
    
    let minHeight: CGFloat = 400
    let maxHeight: CGFloat = 600
    @Binding var isShowing: Bool
    var body: some View {
        ZStack(alignment:.bottom){
            if isShowing{
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing = false
                    }
                
                mainView
                    .transition(.move(edge:.bottom))
                
            }
            

        }
        .frame(maxWidth: .infinity,maxHeight:.infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut)
        //.gesture(slideGest)
    }
    
    var mainView: some View{
        VStack{
            ZStack{
                Capsule()
                    .frame(width:40,height:6)
            }
            .frame(height:20)
            .frame(maxWidth:.infinity)
            .background(Color.white.opacity(0.00001))
            .gesture(slideGest)
            Spacer()
            ZStack{
                VStack{
                    Spacer()
                    Spacer()
                    COLOR(radius: 250, bright: $bright, sat: $sat, hue: $hue)
                    Slider(value: $value, bright: $bright,hue:$hue, sat:$sat)
                    //Text("Brightness")
                }
            }
            .padding(.horizontal,30)
           Spacer()
        }
        .frame(height:curHeight)
        .frame(maxWidth: .infinity)
        .background( LinearGradient(gradient: Gradient(colors: [Color(red: 92/255, green: 211/255, blue: 216/255), Color(red: 137/255, green: 156/255, blue: 225/255),Color(red: 137/255, green: 156/255, blue: 225/255)]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .opacity(0.9)
        .cornerRadius(30)
        .animation(isSlide ? nil : .easeInOut(duration:0.45))
        
    }
    
    @State private var prevSlide = CGSize.zero
    var slideGest:some Gesture{
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged{val in
                if !isSlide{
                    isSlide = true
                }
                let slideAmnt = val.translation.height - prevSlide.height
                
                if curHeight>maxHeight || curHeight<minHeight{
                    curHeight -= slideAmnt/1.5
                } else{
                    curHeight -= slideAmnt
                }
                
                prevSlide = val.translation
            }
            .onEnded{val in
                prevSlide = .zero
                
                isSlide = false
                if curHeight > maxHeight{
                    curHeight = maxHeight
                }
                else if curHeight < minHeight{
                    curHeight = minHeight
                }
            }
    }
}



struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
       //ModalView(isShowing: .constant(true))
        ContentView()
    }
}

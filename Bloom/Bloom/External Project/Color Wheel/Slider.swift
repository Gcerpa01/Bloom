//
//  CustomSlider.swift
//  SLIDETEST
//
//  Created by Gerardo on 10/30/21.
//

import SwiftUI

struct Slider: View {
    @State var lastOffset: CGFloat = 0.0
    @Binding var value: CGFloat
    @Binding var bright:Double
    @Binding var hue:Double
    @Binding var sat:Double

    let trackGradient = LinearGradient(gradient: Gradient(colors: [.pink, .yellow]), startPoint: .leading, endPoint: .trailing)

    
    var body: some View {
        GeometryReader{
            geo in
            VStack(spacing:0){
                Spacer()
                Text("Brightness")
                    .bold()
                    .font(.title3)
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    //.frame(height: 30)
                    .frame(width:275,height: 30)
                    //.position(x: geo.size.width/2)
                    //.fill(.black)
                    .foreground(LinearGradient(gradient: Gradient(colors: [ Color(hue:hue, saturation: sat,brightness: 0.0), Color(hue: hue,saturation: sat,brightness: 1.0)]), startPoint: .leading, endPoint: .trailing))
                
                    .shadow(radius: 10)
                    
                   /*
                    .fill(
                        LinearGradient(gradient: Gradient(colors: [ Color(hue:hue, saturation: sat,brightness: 1.0), Color(hue: hue,saturation: sat,brightness: 1.0)]), startPoint: .leading, endPoint: .trailing)
                    )
                    */
                HStack{
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color(hue: hue, saturation: sat, brightness: bright))
                        //.position(x: geo.size.width/2)
                    
                        .offset(
                            x:self.$value.wrappedValue.map(from: 1...100, to: 30...(geo.size.width - 50 - 22))
                        )
                        .shadow(color: .white, radius: 2.0)
                        .shadow(color: .black, radius: 2)
                    //self.$value.wrappedValue.map(from: 1...100, to: 6...(geometry.size.width - 6 - 22))

                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged{val in
                                    if abs(val.translation.width) < 0.1 {

                                        self.lastOffset = self.$value.wrappedValue.map(from: 1...100, to: 30...(geo.size.width - 50 - 22))
                                        

                                    }
                                                              
                             

                                    let sliderPos = max(30, min(self.lastOffset + val.translation.width, geo.size.width - 50 - 22))
                                                                   
                                    
                                    let sliderVal = sliderPos.map(from: 30...(geo.size.width - 50 - 22), to: 0...100)
                                    
                                    self.value = sliderVal
                                    
                                    
                                    //compute brighness value by mappint from 0 to 1
                                    bright = sliderVal.map(from: 0...100, to: 0...1)
                                    let y = print("brightness \(bright)")

                            }
                        )

                    Spacer()
                }
            }
                Spacer()
        }
        }


    }
}

struct Slider_Previews: PreviewProvider {
    static var previews: some View {
        Slider(value:.constant(0.9),bright: .constant(0.9),hue:.constant(0.9),sat: .constant(0.9))
    }
}

/*Map function utilized to change the values of position from 1 to 100*/
extension CGFloat {
    func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> CGFloat {
        let result = ((self - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
        return result
    }
}

/*Extension utilized to overlay gradients over view*/
extension View {
    public func foreground<Overlay: View>(_ overlay: Overlay) -> some View {
      self.overlay(overlay).mask(self)
    }
}

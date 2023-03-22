//
//  ColorWheel.swift
//  Bloom
//
//  Created by Gerardo on 10/23/21.
//


import SwiftUI

struct COLOR: View {
    var diameter: CGFloat
    /*Calculate radius of actual color wheel*/
    ///note the variable radius will actually be twice the size of the actual radius drawn
    var radii: CGFloat{
        diameter/2
    }
    
    @Binding var bright:Double
    @Binding var sat:Double
    @Binding var hue:Double
    @Binding var selected_position:CGPoint
    
    @State private var cursor = Color.white

    
    var body: some View {
        
            //Find center of display
            VStack{
                
                //Draw ColorWheel
                Circle()
                    .fill(
                        AngularGradient(gradient:Gradient(colors:
                                                            [Color(hue:1.0, saturation:1.0, brightness:0.9),
                                                             Color(hue:0.9, saturation:1.0, brightness:0.9),
                                                             Color(hue:0.8, saturation:1.0, brightness:0.9),
                                                             Color(hue:0.7, saturation:1.0, brightness:0.9),
                                                             Color(hue:0.6, saturation:1.0, brightness:0.9),
                                                             Color(hue:0.5, saturation:1.0, brightness:0.9),
                                                             Color(hue:0.4, saturation:1.0, brightness:0.9),
                                                             Color(hue:0.3, saturation:1.0, brightness:0.9),
                                                             Color(hue:0.2, saturation:1.0, brightness:0.9),
                                                             Color(hue:0.1, saturation:1.0, brightness:0.9),
                                                             Color(hue:0.0, saturation:1.0, brightness:0.9)
                                                             
                                                            ]), center: .center))
                    .frame(width: self.diameter, height: self.diameter)
                    .overlay(
                        Circle()
                            .fill(
                                RadialGradient(gradient:Gradient(colors: [Color.white,
                                                                          Color.white.opacity(0.00000001)]), center: .center, startRadius: 0, endRadius: radii)
                            )
                    )
                
                    .overlay(
                                Circle()
                                    .frame(width: self.diameter, height: self.diameter)
                                    .opacity(1.0 - bright)
                    )

                    .overlay(
                
                //Draw cursor for selecting color
                Circle()
                    .fill(Color(hue: hue, saturation: sat ,brightness:bright))
                    .frame(width: radii / 5, height: radii / 5)
                    .position(selected_position) //set initial position
//                    .offset(x:offset.width,y:offset.height) //set to last position
                    
                    .shadow(color: .white, radius: 2.0)
                    .shadow(color:.black,radius:2.0)
                    .overlay(
                                Circle()
                                    .frame(width: radii/5, height: radii/5)
                                    .opacity(1.0 - bright)
                                    .position(selected_position)
//                                    .offset(x:offset.width,y:offset.height)
                    )
                    .gesture(
                        DragGesture()
                            .onChanged{ val in
                                
                                
                                let current_pos = val.location
                                
                                let center = CGPoint(x: radii, y: radii)
                                
                                print("current pos: \(current_pos)")
                                
//                                print("center: \(center)")
                                
                                let dist = sqrt(pow(current_pos.x-center.x,2) + pow(current_pos.y - center.y,2))
                            
//                                print("distance: \(dist)")
                                if dist > radii{
//                                    print("reached edge")
                                    let clampedX = (current_pos.x - center.x) * radii/dist + center.x
                                    let clampedY = (current_pos.y - center.y)*radii/dist + center.y
                                    self.selected_position = CGPoint(x: clampedX, y: clampedY)
                                }
                                
                                else{
                                    self.selected_position = val.location
//                                    print("final location \(selected_position)")
                                }
                                
                                let angle = findAngle(x: selected_position.x - center.x, y: selected_position.y - center.y)

                                if dist == 0{return}
                                
                                print("angle \(angle)")
                                
                                hue = findColorhue(x: angle.degrees)

                                print("hue \(hue)")
                                
                                sat = findColorsat(distance: dist, radius: radii)

                                print("hue \(hue)")
                                
                            }   
                    )
                )
            }
            
        }
        
    }
    

struct COLOR_Previews: PreviewProvider {
    static var previews: some View {
        COLOR(diameter: 250, bright: .constant(0.9),sat:.constant(0.9),hue:.constant(0.9),selected_position: .constant(CGPoint(x: 100, y: 100)))
    }
}

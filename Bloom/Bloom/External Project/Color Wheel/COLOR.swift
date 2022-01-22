//
//  ColorWheel.swift
//  Bloom
//
//  Created by Gerardo on 10/23/21.
//


import SwiftUI

struct COLOR: View {
    var radius: CGFloat
    /*Calculate radius of actual color wheel*/
    ///note the variable radius will actually be twice the size of the actual radius drawn
    var radii: CGFloat{
        radius/2
    }
    
    @Binding var bright:Double
    @Binding var sat:Double
    @Binding var hue:Double
    
    
    @State private var offset = CGSize.zero
    @State private var next_offset = CGSize.zero
    @State private var test_offset = CGSize.zero
    @State private var cursor = Color.white
    
    
    var body: some View {
        
        return GeometryReader{ geo in
            //Find center of display
            let center = CGPoint(x: geo.size.width/2, y:geo.size.height/2)
            
            ZStack{
                
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
                    .frame(width: self.radius, height: self.radius)
                    .position(center)
                    .overlay(
                        Circle()
                            .fill(
                                RadialGradient(gradient:Gradient(colors: [Color.white,
                                                                          Color.white.opacity(0.00000001)]), center: .center, startRadius: 0, endRadius: radii)
                            )
                    )
                
                    .overlay(
                                Circle()
                                    .frame(width: self.radius, height: self.radius)
                                    .opacity(1.0 - bright)
                    )
                
                //Draw cursor for selecting color
                Circle()
                    .fill(cursor)
                    .frame(width: 30, height: 30)
                    //.position(center) //set initial position
                    .offset(x:offset.width,y:offset.height) //set to last position
                    
                    .shadow(color: .white, radius: 2.0)
                    .shadow(color:.black,radius:2.0)
                    .overlay(
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .opacity(1.0 - bright)
                                    .offset(x:offset.width,y:offset.height)
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .global)
                            .onChanged{ val in

                                //test position before anything
                                test_offset = val.translation
                                
                                //calculate distance between center and finger position
                                var distance = sqrt(pow(test_offset.width,2) + pow(test_offset.height,2))
                                
                                //check that the distance is less than the radius to be read
                                if distance < radii {
                                    offset = test_offset
                                    ///print("distance \(distance)")
                                }
                                
                                else{
                                    //if distance exceeds radius, find max point
                                    let clampedX = (test_offset.width) / distance * radii
                                    let clampedY = (test_offset.height) / distance*radii
                                    offset = CGSize(width:clampedX,height:clampedY)
                                    distance = radii
                                    ///print("distance \(distance)")
                                }
                                
                                
                                
                                //calculate angle
                                let angle = findAngle(x: (test_offset.width), y: (test_offset.height))
                                
                                
                                /*
                                //if x is in negatives, add 180 degrees to reflect
                                if test_offset.width < 0 {
                                    angle.degrees += 180
                                }
                                
                                //if point is on first quadrant, add 360
                                
                                else if test_offset.width > 0 && test_offset.height > 0 {
                                    angle.degrees += 360
                                }
                                
                                 
                                 */
                                ///print("Degrees \(angle.degrees)")
                                
                                //allow for the calculation of color
                                
                                if distance == 0 {return}
                                
                                
                                /*
                                //calculate hue
                                let hue = angle.degrees / 360
                                
                                //calculate sat
                                let sat = Double(distance / radii)
                                */
                                
                                /*
                                let colors = findColor(x: angle.degrees, distance: distance, radius: radii)
                                */
                            hue = findColorhue(x: angle.degrees)
                                //reflect color on cursor
                                
                                sat =
                                findColorsat(distance: distance, radius: radii)
                                cursor = Color(hue: hue, saturation: sat ,brightness:bright)
                            }
                        
                            .onEnded{ val in
                               self.test_offset = CGSize.zero
                               self.offset = CGSize.zero
                            }
                    )

            }
            
        }
        
    }
    
}

struct COLOR_Previews: PreviewProvider {
    static var previews: some View {
        COLOR(radius: 300, bright: .constant(0.9),sat:.constant(0.9),hue:.constant(0.9))
    }
}


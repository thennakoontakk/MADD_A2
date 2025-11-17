import SwiftUI

struct DashboardView:View {
    
    var body: some View{
        VStack(spacing:30){
            Text("Welcome , User 1")
                .font(.system(size:50,weight: .bold))
                .foregroundColor(.white)
            
            Text("Daily Goal : 1500ml/200ml")
                .font(.title3)
                .foregroundColor(.gray)
                        ProgressView(value: 0.6)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .frame(width:500)
                .scaleEffect(x:1,y:4, anchor: .center)
            
            Text("Keep drinking water!")
                .font(.headline)
                .padding(.top,20)
            
        }
        .padding()
        
    }
}

struct DashboardView_Previews:PreviewProvider {
    static var previews: some View{
        DashboardView()
    }
}
    


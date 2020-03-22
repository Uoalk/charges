

public PVector angularAcceleration(State s){
  return new PVector(0.01, 0.0, 0.0);  
}
public PVector acceleration(State s){
 return new PVector(0.01,0,0); 
}

final float k=8.99*(float)Math.pow(10,9);
final float minDistSq=1;






public void drawAxis(){
  //X  - red
  float size=100;
  stroke(192,0,0);
  line(-size,0,0,size,0,0);
  //Y - green
  stroke(0,192,0);
  line(0,-size,0,0,size,0);
  //Z - blue
  stroke(0,0,192);
  line(0,0,-size,0,0,size);
}



System s;

public void setup(){
  size(1000,1000,P3D);
  frameRate(60);
  s=new System();
}

public void draw(){
  background(255);
  lights();
  
  drawAxis();
  camera(mouseX-width/2, -mouseY+height/2, 120.0, 0, 0, 0.0, 
       0.0, 1.0, 0.0);
  s.run();
  s.draw();

  //println(s.charges[1].getState().orientation);
  //println(s.charges[1].angularAcceleration(s));
  //Point[] p=((Rod)(s.charges[1])).getPoints();
  //((Rod)(s.charges[1])).state.orientation=new Quaternion(1,1,1,1);
  //for(Point point:p)point.draw();

  for(float x=0;x<10;x+=1){
    for(float y=0;y<10;y+=1){
      for(float z=0;z<10;z+=1){
        PVector f=s.getField(new PVector(x,y,z), null).div(1000000);
        line(x,y,z,x+f.x, y+f.y, z+f.z);
      }
    }
  }

}

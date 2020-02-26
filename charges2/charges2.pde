final float k=8.99*(float)Math.pow(10,9);
final float minDistSq=0;

public interface Charged{
  public PVector getField(PVector loc);
  public float getCharge();
  public void setMot(Mot m);
  public Mot getMot();
  public void draw();
  public void run(System s, float dt);
  public float KE();
  public float V(PVector loc);
  public void updateMot();


}

public float c(float x){return cos(x);}
public float s(float x){return sin(x);}
public PVector proj(PVector u, PVector v){
  //projection of u onto v
  float magSq=v.magSq();
  if(magSq==0)magSq=0.00001;
  return PVector.mult(v,u.dot(v)/magSq);
  
}
public float sgn(float n){
   return abs(n)/n; 
}


public class System{
  Charged[] charges;
  public float dt=0.001;
  public float t;
  public System(){

    charges=new Charged[]{new Rod(0.0001,new PVector(0,0,0)),new Point(1,new PVector(1,1,1))};
    //charges=new Charged[]{new Point(0.001,new PVector(0,0,0)),new Point(0.001,new PVector(5,0,0))};

    ((Rod)charges[0]).l=30;
    ((Rod)charges[0]).mass=0.01;
    ((Rod)charges[0]).pointCount=10;
  }
  public void draw(){
    for(Charged i: charges)i.draw();
  }
  public void run(){
    for(Charged i: charges)i.run(this,dt);
    for(Charged i: charges)i.updateMot();
    t+=dt;
  }
  public float E(){
    float e=0;
    for(Charged i: charges){
      e+=i.KE();
      for(Charged j: charges){
        if(i!=j)e+=i.V(j.getMot().x)*j.getCharge()*0.5;
      }
    }
    
    return e;
  }
  public PVector getField(PVector loc, Charged source){
    PVector field=new PVector();
    for(Charged i: charges){
      if(i!=source)field.add(i.getField(loc));

    }
    return field;
  }
}
public void setup(){
  size(1000,1000,P3D);
  frameRate(60);
}
public void drawAxis(){
  strokeWeight(1);
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
System s=new System();
public void draw(){
  background(255);
  lights();
  drawAxis();
  s.run();
  Rod rod=(Rod)(s.charges[0]);
  rod.rotMot.rot.x+=0.01;
  rod.rotMot.rot.y=0.3;
  //rod.rotMot.rot.z+=0.04;
  for(int i=0;i<rod.getPoints().length;i++){
    rod.getPoints()[i].draw();
  }
  
  fill(0);
  text("t="+s.t+"\nE="+s.E(),0,10,0);
  s.draw();
  //((Rod)(s.charges[0])).rotMot.theta+=0.01;
  //((Rod)(s.charges[0])).rotMot.phi+=0.02;
  
  //println(s.getField(s.charges[0].getMot().x,null)+" "+s.getField(s.charges[1].getMot().x,null));
  //for(Point i: ((Rod)(s.charges[0])).getPoints())i.draw();
  //println(((Rod)(s.charges[0])).mot.xDot+" "+(((Point)(s.charges[1])).mot.xDot));
  //println(s.getField(new PVector(1,1,1),null).magSq());
  camera(mouseX-width/2, -mouseY+height/2, 120.0, 0, 0, 0.0, 
       0.0, 1.0, 0.0);
  
  stroke(0);
  /**
  for(float x=0; x<100;x+=10)
  for(float y=0; y<100;y+=10)
  for(float z=0; z<100;z+=10){
    PVector field=PVector.div(s.getField(new PVector(x,y,z),null),1000);
    line(x,y,z,x+field.x,y+field.y,z+field.z);
  }**/
 
}

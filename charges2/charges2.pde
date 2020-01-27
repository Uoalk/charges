final float k=8.99*(float)Math.pow(10,9);
final float minDistSq=1;


public interface Charged{
  public PVector getField(PVector loc);
  public float getCharge();
  public void setMot(Mot m);
  public Mot getMot();
  public void draw();
  public void run(System s, float dt);
  public float KE();
  public float V(PVector loc);


}
public class Mot{
  PVector x;
  PVector xDot;
  public Mot(){
    this.x=new PVector();
    this.xDot=new PVector();
  }
  public Mot(PVector x){
    this();
    this.x=x;
  }
  public Mot(PVector x, PVector xDot){
    this.x=x;
    this.xDot=xDot;
  }
  public String toString(){return x+" "+xDot;}
}
public Mot mult(Mot m, float h){
  return new Mot(PVector.mult(m.x,h),PVector.mult(m.xDot,h));
}
public Mot add(Mot m1, Mot m2){
  return new Mot(PVector.add(m1.x,m2.x),PVector.add(m1.xDot,m2.xDot));
}

public class RotMot{
  float theta, thetaDot, phi, phiDot; 
  public PVector toCart(){
    return new PVector(cos(theta)*sin(phi),sin(theta)*sin(phi),cos(phi));
  }
}


public class Point implements Charged{
  private float charge;
  Mot mot;
  float mass;
  public Point(float charge, PVector pos){
    this.charge=charge;
    this.mot=new Mot(pos);
   
    mass=1;
  }
  
  public float KE(){return 0.5*mass*mot.xDot.magSq();}
  public float V(PVector loc){
    PVector r=PVector.sub(mot.x,loc);
    if(r.magSq()>minDistSq){return k*charge/r.mag();}
    return 0;
  }

  public void draw(){
    stroke(map(charge,-0.001,0.001,0,255),0,0);
    pushMatrix();
    translate(mot.x.x,mot.x.y,mot.x.z);
    sphere(1);
    popMatrix();
    
  }
  public Mot f(Mot m, System s){
    Mot newMot= new Mot();
    newMot.x=new PVector(m.xDot.x,m.xDot.y,m.xDot.z);
    newMot.xDot=PVector.mult(s.getField(m.x, this),this.charge/this.mass);
    
    return newMot;
  }
  public void run(System s, float dt){
    //mot.x.add(PVector.mult(mot.xDot,dt));
    //mot.xDot.add(PVector.mult(s.getField(mot.x),dt*this.charge/this.mass));
    
    Mot k1=mult(f(mot,s),dt);
    Mot k2=mult(f(add(mot, mult(k1,0.5)),s), dt);
    Mot k3=mult(f(add(mot,mult(k2, 0.5)),s), dt);
    Mot k4=mult(f(add(mot, k3),s), dt);
    mot=add(mot, mult(add(add(add(k1, mult(k2,2)), mult(k3, 2)), k4), 1.0/6));
  }
  public void setMot(Mot m){
    this.mot=m;
  }
  public Mot getMot(){return mot;}
  public float getCharge(){return charge;}
  public PVector getField(PVector loc){
    PVector r=PVector.sub(loc,mot.x);
    float d2=r.magSq();
    if(r.magSq()<minDistSq)return new PVector();
    return PVector.mult(r.normalize(),k*charge/d2);
  }
}


public class Rod implements Charged{
  float charge, mass, I, l;
  int pointCount;
  Mot mot;
  RotMot rotMot;
  public Rod(float charge, PVector pos){
    this.charge=charge;
    this.mot=new Mot(pos);
    rotMot=new RotMot();
   l=0.1;
    mass=10;
    I=1.0/12*mass*l*l;
    pointCount=10;
  }
  public void setMot(Mot m){this.mot=m;}
  public Mot getMot(){return mot;}
  public float getCharge(){return charge;}
  public float KE(){return 0.5*mass*mot.xDot.magSq();}//TODO
  public float V(PVector loc){
    float V=0;
    for(Point i: getPoints()){
      V+=(i.V(loc));
    }
    return V;
  }//TODO
  public Mot fMot(Mot m, System s){
    Mot newMot= new Mot();
    for(Point p: getPoints()){
      newMot.x.add(new PVector(m.xDot.x,m.xDot.y,m.xDot.z));
      newMot.xDot.add(PVector.mult(s.getField(m.x, this),p.charge));
    }
    newMot.xDot.div(mass);
    return newMot;
  }
  public void run(System s, float dt){
    Mot k1=mult(fMot(mot,s),dt);
    Mot k2=mult(fMot(add(mot, mult(k1,0.5)),s), dt);
    Mot k3=mult(fMot(add(mot,mult(k2, 0.5)),s), dt);
    Mot k4=mult(fMot(add(mot, k3),s), dt);
    mot=add(mot, mult(add(add(add(k1, mult(k2,2)), mult(k3, 2)), k4), 1.0/6));
  }
  public PVector getField(PVector loc){
    PVector field=new PVector();
    for(Point i: getPoints()){
      field.add(i.getField(loc));
    }
    return field;
  }
  public void draw(){

    
    pushMatrix();
    translate(mot.x.x,mot.x.y,mot.x.z);
    rotateZ(rotMot.theta);
    rotateY(rotMot.phi);
    box(1,1,l);
    popMatrix();
    
  }
  public Point[] getPoints(){
    Point[] points=new Point[pointCount];
    for(int i=0;i<pointCount;i++){
      points[i]=new Point(charge/pointCount, PVector.add(mot.x,PVector.mult(rotMot.toCart(),(pointCount/2.0-i-0.5)/pointCount*l)));
      points[i].mass=mass/pointCount;
    }
    return points;
  }
  
  
  
  
  
}





public class System{
  Charged[] charges;
  public float dt=0.001;
  public float t;
  public System(){
    //charges=new Charged[]{ new Point(0.001,new PVector(0,0,0)),new Point(-0.001, new PVector(10,1,1))};
    charges=new Charged[]{new Rod(0.001,new PVector(0,0,0)),new Point(0.001,new PVector(0,10,0))};
    //charges[2].setMot(new Mot(new PVector(0,3,0),new PVector(54,0,0)));
    //((Point)charges[1]).mass=1000;
    ((Rod)charges[0]).rotMot.theta=3.14/2;
    ((Rod)charges[0]).rotMot.phi=3.14/2;
    ((Rod)charges[0]).l=20;
  }
  public void draw(){
    for(Charged i: charges)i.draw();
  }
  public void run(){
    for(Charged i: charges)i.run(this,dt);
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
  
  println(((Rod)(s.charges[0])).fMot(s.charges[0].getMot(),s));
 
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
  fill(0);
  text("t="+s.t+"\nE="+s.E(),0,10,0);
  s.draw();
  //((Rod)(s.charges[0])).rotMot.theta+=0.01;
  //((Rod)(s.charges[0])).rotMot.phi+=0.02;
  
  
  for(Point i: ((Rod)(s.charges[0])).getPoints())i.draw();
  //((Rod)(s.charges[0])).pointCount++;
  //println(s.getField(new PVector(1,1,1),null).magSq());
  camera(mouseX-width/2, -mouseY+height/2, 120.0, 0, 0, 0.0, 
       0.0, 1.0, 0.0);
  
  stroke(0);
  for(float x=0; x<100;x+=10)
  for(float y=0; y<100;y+=10)
  for(float z=0; z<100;z+=10){
    PVector field=PVector.div(s.getField(new PVector(x,y,z),null),1000);
    line(x,y,z,x+field.x,y+field.y,z+field.z);
  }
 
}

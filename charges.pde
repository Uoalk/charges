final float scale=1;
final float k=8.99*1000000000;
public float y(float y){//scale a simulated y cooridanant for teh screen
  return height*0.5-(float)(y*scale);
}
public float x(float x){//scale a simulated x cooridanant for teh screen
  return width/2+(float)(x*scale);
}
public float z(float z){ return 3.14/2+atan(z);}

static interface Charged{
  public void interact(Point p);
  public void interact(Charged[] p);
  public void motion(float dt);
  public float getCharge();
  public PVector getPos();
  public float E();
  public void draw();
}

public class Point implements Charged{
  private float charge;
  PVector pos;
  PVector vel;
  PVector acc;
  float mass;
  public Point(float charge, PVector pos){
    this.charge=charge;
    this.pos=pos;
    this.vel=new PVector(0,0);
    this.acc=new PVector(0,0);
   
    mass=1;
  }
  public float getCharge(){return charge;}
  public PVector getPos(){return pos;}
  public float E(){return 0.5*mass*this.vel.magSq();}

  public void draw(){
    stroke(map(charge,-0.001,0.001,0,255),0,0);
    //circle(x(pos.x),y(pos.y),sqrt(pos.z+100));
    //sphere(pos.x,pos.y,pos.z);
    pushMatrix();
    translate(pos.x,pos.y,pos.z);
    sphere(1);
    popMatrix();
    
  }
  public void motion(float dt){
   
    vel.add(PVector.mult(acc,dt));
    pos.add(PVector.mult(vel,dt));
   
    acc=new PVector(0,0,0);
  }
  public PVector interact(Point p){
    PVector r=PVector.sub(this.pos,p.pos);
    float d2=r.magSq();
    float force=k*charge*p.charge/d2;
   
    acc.add(PVector.mult(r.normalize(),force).mult(mass));
  }
  public void interact(Charged[] p){
    for(int i=0;i<p.length;i++){
      if(p[i]==this)continue;
      if(p[i] instanceof Point){
          this.interact((Point)(p[i]));
          
       }
    }
  }
}
public class Rod implements Charged{
  float charge;
  float l;
  int chargeCount;
  float mass;
 
  PVector pos;
  PVector vel;
  PVector acc;
 
  public PVector rot;
  PVector aVel;
  PVector aAcc;
  public Rod(){
    l=10;
    chargeCount=10;
    mass=1;
    
    pos=new PVector();
    vel=new PVector();
    acc=new PVector();
    
    rot=new PVector();
    aVel=new PVector();
    aAcc=new PVector();
  }
  public float E(){return 0.5*mass*this.vel.magSq();}
  public PVector getPos(){return pos;}
  public float getCharge(){return charge;}
  public Point[] getPoints(){
    Point[] points=new Point[chargeCount];
    for(int i=0;i<chargeCount;i++){
      
      points[i]=new Point(charge/chargeCount,new PVector(
        pos.x-(i*chargeCount/l-l/2)*(cos(rot.z)*cos(rot.y)+sin(rot.z)*cos(rot.y)-sin(rot.y)),
        pos.y+(i*chargeCount/l-l/2)*(-sin(rot.z)*sin(rot.x)+cos(rot.z)*sin(rot.y)*sin(rot.x)+cos(rot.z)*sin(rot.y)*sin(rot.x)+cos(rot.z)*sin(rot.x)+cos(rot.y)*sin(rot.x)),
        pos.z-(i*chargeCount/l-l/2)*(cos(rot.z)*sin(rot.y)*cos(rot.x)+sin(rot.z)*sin(rot.x)-cos(rot.z)*sin(rot.x)+sin(rot.z)*sin(rot.y)*cos(rot.x)+cos(rot.y)*cos(rot.x))
        ));
        
    }
    return points;
  }
  public void interact(Charged[] p){
    
  }
 
  public void draw(){
    
   pushMatrix();
   translate(pos.x,pos.y,pos.z);
   rotateX(rot.x);
   rotateY(rot.y);
   rotateZ(rot.z);
   box(1,1,l);
   popMatrix();
  }
  public void interact(Point p){
   
  }
  public void motion(float dt){
   
  }
}
public class Motion{
   PVector x, xDot, xDDot;
   public Motion(){
     x=new PVector();
     xDot=new PVector();
     xDDot=new PVector();
   }
   public Motion(PVector x, PVector xDot, PVector xDDot){
      this.x=x;
      this.xDot=xDot;
      this.xDDot=xDDot;
   }
   public String toString(){
     return "{x:"+x+" xDot:"+xDot+"}";
   }
   
}

public class System{
  final float dt=0.0001;
  float t;
  public Charged[] charges;
  public System(){

    //charges=new Charged[]{new Rod(),new Point (0.0001,new PVector(1,1,1)), new Point(0.0001,new PVector(0,0,0))};
    charges=new Charged[21];
    for(int i=0;i<20;i++){
      charges[i]=new Point(0.001,new PVector(10*sin(i),10*cos(i),0)); 
    }
    charges[20]=new Point(-0.01,new PVector(20,20,0));
    ((Point)(charges[20])).vel=new PVector(-5,0,0);
  }
  public void draw(){
    fill(0);
    //Rod r=(Rod)charges[0];
    //r.rot.y+=0.01;
    //r.rot.z+=0.02;
    //r.rot.x+=0.005;
    
    //for(Point p:r.getPoints())p.draw();
    for(int i=0;i<charges.length;i++){
      charges[i].draw();
    }
    
  }
  public void physics(){
    for(int i=0;i<charges.length;i++){
        
        charges[i].interact(charges);
        
    }
    for(int i=0;i<charges.length;i++){
      t+=dt;
      charges[i].motion(dt);
    }
  }
  public float E(){
    float E=0;
    for(int i=0;i<charges.length;i++){
      for(int j=0;j<charges.length;j++){
        if(i==j)continue;
        E+=0.5*k*charges[i].getCharge()*charges[j].getCharge()/PVector.sub(charges[i].getPos(),charges[j].getPos()).mag();
      }
    }
    for(int i=0;i<charges.length;i++){
      E+=charges[i].E();
    }
    return E;
  }
}
System s=new System();
public void setup(){
  size(1000,1000,P3D);

  frameRate(60);
 
}
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
public void draw(){
  background(255);
  lights();
  
  drawAxis();
  text("t="+s.t+"\nE="+s.E(),0,10,0);
  s.physics();
  s.draw();
  camera(mouseX-width/2, -mouseY+height/2, 120.0, 0, 0, 0.0, 
       0.0, 1.0, 0.0);
 
}

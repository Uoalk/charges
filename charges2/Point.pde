public class Point implements Charged{
  private float charge;
  Mot mot, newMot;
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
    newMot=add(mot, mult(add(add(add(k1, mult(k2,2)), mult(k3, 2)), k4), 1.0/6));
  }
  public void updateMot(){
    mot=newMot;
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

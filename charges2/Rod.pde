public class Rod implements Charged{
  float charge, mass, l;
  int pointCount;
  Mot mot, newMot;
  RotMot rotMot, newRotMot;
  public Rod(float charge, PVector pos){
    this.charge=charge;
    this.mot=new Mot(pos);
    this.rotMot=new RotMot();
   l=0.1;
    mass=1;
    
    pointCount=5;
  }
  public void setMot(Mot m){this.mot=m;}
  public Mot getMot(){return mot;}
  public float getCharge(){return charge;}
  public float I(){
    return 1.0/12*mass*l*l;  
  }
  public float KE(){
    return 0;
    //return 0.5*mass*mot.xDot.magSq()+0.5*I()*(rotMot.thetaDot*rotMot.thetaDot+rotMot.phiDot*rotMot.phiDot);
  }//TODO
  public float V(PVector loc){
    float V=0;
    for(Point i: getPoints()){
      V+=(i.V(loc));
    }
    return V;
  }//TODO
  public Mot fMot(Mot m, System s){
    Mot newMot= new Mot();
    newMot.x.add(new PVector(m.xDot.x,m.xDot.y,m.xDot.z));
    for(Point p: getPoints()){
      
      newMot.xDot.add(PVector.mult(s.getField(p.mot.x, this),p.charge));
    }
    newMot.xDot.div(mass);
    return newMot;
  }
  public RotMot fRotMot(RotMot m, System s){
    RotMot newRotMot=new RotMot();
    PVector torque=new PVector();
    
    for(Point p: getPoints()){
      PVector r=PVector.sub(p.mot.x,mot.x);
      PVector f=PVector.mult(s.getField(p.mot.x, this),p.charge);
      torque.add(r.cross(f));
    }
    newRotMot.theta=m.thetaDot;
    newRotMot.phi=m.phiDot;
    
    PVector alpha=PVector.mult(torque,1.0/I());
    
    
    
    
    
    PVector uHat=new PVector(1,0,0);
    PVector vHat=new PVector(0,0,1);
    PVector wHat=new PVector(1,0,0);
    newRotMot.rotDot.x=proj(alpha,uHat).x;
    newRotMot.rotDot.y=proj(alpha,vHat).z;
    newRotMot.rotDot.z=proj(alpha,wHat).x;
    //println(phiHatComponent);
    
    
    if(Float.isNaN(newRotMot.phiDot))newRotMot.phiDot=0;
    if(Float.isNaN(newRotMot.thetaDot))newRotMot.thetaDot=0;
    
    stroke(255,0,0);
    strokeWeight(10);
    line(0,0,0,phiHat.x*10,phiHat.y*10,phiHat.z*10);
    line(0,0,0,0,0,10);
    stroke(0,255,0);
    line(0,0,0,alpha.x,alpha.y,alpha.z);
    
    println(proj(alpha,zAxis));
    //println(alpha);
    //println(newRotMot.thetaDot+" "+newRotMot.phiDot);
    return newRotMot;
    
  }**/
  public void run(System s, float dt){
    Mot k1=mult(fMot(mot,s),dt);
    Mot k2=mult(fMot(add(mot, mult(k1,0.5)),s), dt);
    Mot k3=mult(fMot(add(mot,mult(k2, 0.5)),s), dt);
    Mot k4=mult(fMot(add(mot, k3),s), dt);
    newMot=add(mot, mult(add(add(add(k1, mult(k2,2)), mult(k3, 2)), k4), 1.0/6));
    

    //newRotMot=add(rotMot,mult(fRotMot(rotMot,s),dt));
    
  }
  public void updateMot(){
    //mot=newMot;
    //rotMot=newRotMot;
  }
  public PVector getField(PVector loc){
    PVector field=new PVector();
    for(Point i: getPoints()){
      field.add(i.getField(loc));
    }
    return field;
  }
  public void draw(){

    strokeWeight(0);
    pushMatrix();
    translate(mot.x.x,mot.x.y,mot.x.z);
    
    
    
    float u=rotMot.rot.x;
    float v=rotMot.rot.y;
    float w=rotMot.rot.z;
    PVector end=rotate(new PVector(0,0,l/2),new PVector(u,v,w));
    
    strokeWeight(10);
    fill(0);
    line(-end.x,-end.y,-end.z, end.x,end.y,end.z);
    popMatrix();
    
  }
  public Point[] getPoints(){
    Point[] points=new Point[pointCount];
    
    
    
    
    
    for(int i=0;i<pointCount;i++){
      points[i]=new Point(charge/pointCount, new PVector());
      PVector pos=new PVector(0,0,(pointCount/2.0-i-0.5)/pointCount*l);
      
      PVector rot=new PVector(rotMot.rot.x,rotMot.rot.y,rotMot.rot.z);
      
      
      PVector newPos=rotate(pos, rot);
      
      
      points[i]=new Point(charge/pointCount, PVector.add(mot.x,newPos));
      points[i].mass=mass/pointCount;
    }
    return points;
  }
  
  
  
  
  
}

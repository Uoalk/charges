public abstract class RigidBody implements Charged{
  public abstract Point[] getPoints();
  float charge, mass;

  State state;

  public RigidBody(float charge, PVector pos){
    this.charge=charge;
    mass=1;
    this.state=new State();
    state.position=pos;
    state.orientation=new Quaternion(1,1,1,1);
  }
  public State getState(){return state;}
  public void setState(State s){state=s;}
  public Charged clone(){
    Rod r=new Rod(charge, new PVector(state.position.x,state.position.y,state.position.z));
    
    r.charge=charge;
    r.mass=mass;
    r.state=(State)(state.clone());
    return r;
  }
  public void run(System s, float dt){
    integrate(this, s, dt);

  }
  public PVector acceleration(System s){
    PVector acc=new PVector();
    for(Point p: getPoints()){
      acc.add(PVector.mult(s.getField(p.state.position, this),p.charge));
    }
    acc.div(mass);
    return acc;
  }
  public PVector angularAcceleration(System s){
    PVector angularAcc=new PVector();
    float inertia=0;
    for(Point p: getPoints()){
      PVector r=PVector.sub(p.state.position,state.position);
      inertia+=p.mass*r.magSq();
      PVector f=PVector.mult(s.getField(p.state.position, this),p.charge);
      println(mass+" "+f);
      angularAcc.add(r.cross(f));
    }
    angularAcc.div(inertia);
    line(state.position.x,state.position.y,state.position.z,state.position.x+angularAcc.x, state.position.y+angularAcc.y,state.position.z+angularAcc.z);
    return angularAcc;
    
  }
  

  public float getCharge(){return charge;}
  public float KE(){
    float KE=0.5*mass*state.velocity.magSq();
    
    
    
     return KE;
  }//TODO
  public float PE(System s){
    float PE=0;
    for(Point i: getPoints()){
      PE+=s.getPotential(i.state.position, this)*i.charge;
    }
    return PE;
  }
  public float getPotential(PVector loc){
    float V=0;
    for(Point i: getPoints()){
      V+=i.getPotential(loc);
    }
    return V;
  }//TODO
  

 PVector getField(PVector loc){
    PVector field=new PVector();
    for(Point i: getPoints()){
      field.add(i.getField(loc));
    }
    return field;
  }
  
  public void draw(){
    
    for(Point i:getPoints())i.draw();
    
  }
  
}

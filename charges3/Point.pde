
import processing.core.PVector;


public class Point implements Charged{
  float charge;
  public State state;
  float mass;
  public Point(float charge, PVector pos){
    this.charge=charge;
    this.state=new State();
    state.position=pos;
   
    mass=1;
  }
  public State getState(){return state;}
  public void setState(State s){state=s;}
  public Charged clone(){
    Point p=new Point(charge, new PVector(this.state.position.x, this.state.position.y, this.state.position.z));
    p.charge=charge;
    p.state=(State)(state.clone());
    p.mass=mass;
    return p;
  }
  public float KE(){return (float)0.5*mass*state.velocity.magSq();}
  public float PE(System s){return s.getPotential(state.position, this)*charge;}
  public float getPotential(PVector pos){
    float r=PVector.sub(state.position, pos).mag();
    return charge/r;
  }

  public void draw(){
    stroke(map(charge,-0.001,0.001,0,255),0,0);
    pushMatrix();
    translate(state.position.x, state.position.y, state.position.z);
    sphere(1);
    popMatrix();
    
  }

  public void run(System s, float dt){
    integrate(this, s, dt);
  }
  public PVector angularAcceleration(System s){
    return new PVector(0,0,0);
  }
  public PVector acceleration(System s){
    return PVector.mult(s.getField(state.position, this),charge/mass);
  }
  public float getCharge(){return charge;}
  public PVector getField(PVector loc){
    PVector r=PVector.sub(loc,state.position);
    float d2=r.magSq();
    if(r.magSq()<0.01)return new PVector();
    return PVector.mult(r.normalize(),k*charge/d2);
  }
}

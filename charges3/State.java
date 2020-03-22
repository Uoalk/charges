import processing.core.PVector;
class State implements Cloneable{
  Quaternion orientation;
  
  PVector angularVelocity;  
  
  float inertia;
  
  
  //Position stuff
  PVector position;
  PVector velocity;

  
  public State(){
    orientation=new Quaternion(1,0,0,0);
    
    angularVelocity=new PVector();
    position=new PVector();
    velocity=new PVector();
  }
  public State clone(){
    State s=new State();
    s.orientation=new Quaternion(orientation.w, orientation.x, orientation.y, orientation.z);
    s.angularVelocity=new PVector(angularVelocity.x, angularVelocity.y, angularVelocity.z);
    s.inertia=inertia;
    s.position=new PVector(position.x, position.y, position.z);
    s.velocity=new PVector(velocity.x, velocity.y, velocity.z);
    
    return s;
  }
  public Quaternion getSpin(){
    Quaternion q=new Quaternion(0, angularVelocity.x, angularVelocity.y, angularVelocity.z);

 
    Quaternion spin=Quaternion.mult(Quaternion.mult(q, orientation),(float)0.5);
    return spin;

    
  }
  void add(Derivative d){
    orientation=Quaternion.add(orientation,d.spin);
    angularVelocity=PVector.add(angularVelocity, d.angularAcceleration);
    
    position=PVector.add(position, d.velocity);
    velocity=PVector.add(velocity, d.acceleration);

  }
  Derivative getDerivative(PVector acceleration, PVector angularAcceleration){
    Derivative d=new Derivative();
    d.spin=this.getSpin();
    d.angularAcceleration=angularAcceleration;
    d.velocity=this.velocity;
    d.acceleration=acceleration;
    return d;
  }

}

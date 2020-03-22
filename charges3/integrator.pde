

//Next we need a function to advance the physics state ahead from t to t+dt using one set of derivatives, and once there, recalculate the derivatives at this new state:
public Derivative evaluate(Charged charge, System s, float dt, Derivative d){
  State initial=charge.getState();
  State state=new State();
  state.orientation = Quaternion.add(initial.orientation, Quaternion.mult(d.spin, dt));
  state.angularVelocity = PVector.add(initial.angularVelocity, PVector.mult(d.angularAcceleration, dt));
  state.position=PVector.add(initial.position, PVector.mult(d.velocity, dt));
  state.velocity=PVector.add(initial.velocity, PVector.mult(d.acceleration, dt));
  
  
  //Make a fake charge where that charge would be after motion
  Charged testCharge=(Charged)(charge.clone());
  testCharge.setState(charge.getState().clone());
  
  Derivative output=new Derivative();
  output.spin=state.getSpin();
  output.angularAcceleration=testCharge.angularAcceleration(s);
  output.velocity=state.velocity;
  output.acceleration=testCharge.acceleration(s);
  
  return output;
}

void integrate(Charged charge, System s,float dt){
  State state=charge.getState();
  Derivative a, b, c, d;
 
  
  a=evaluate(charge, s, dt, state.getDerivative(charge.acceleration(s), charge.angularAcceleration(s)));
  b=evaluate(charge, s, dt/2, a);
  c=evaluate(charge, s, dt/2, b);
  d=evaluate(charge, s, dt, c);
  
  state.add(Derivative.mult(Derivative.add(Derivative.add(a,Derivative.mult(Derivative.add(b,c),2)),d),1.0/6.0*dt));
  state.orientation.normalize();
}

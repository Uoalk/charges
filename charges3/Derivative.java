import processing.core.PVector;
class Derivative{
  Quaternion spin;
  PVector angularAcceleration;
  PVector velocity;
  PVector acceleration;
  static Derivative add(Derivative a, Derivative b){
    Derivative d=new Derivative();
    d.spin=Quaternion.add(a.spin, b.spin);
    d.angularAcceleration=PVector.add(a.angularAcceleration, b.angularAcceleration);
    d.velocity=PVector.add(a.velocity, b.velocity);
    d.acceleration=PVector.add(a.acceleration,b.acceleration);
    
    return d;
  }
  static Derivative mult(Derivative a, float c){
    Derivative d=new Derivative();
    d.spin=Quaternion.mult(a.spin,c);
    d.angularAcceleration=PVector.mult(a.angularAcceleration, c);
    d.velocity=PVector.mult(a.velocity, c);
    d.acceleration=PVector.mult(a.acceleration, c);
    return d;
  }
}

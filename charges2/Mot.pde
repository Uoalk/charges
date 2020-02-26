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
  PVector rot;
  PVector rotDot;
  public RotMot(){
    rot=new PVector();
    rotDot=new PVector();
  }

}
public RotMot mult(RotMot m, float h){
  RotMot newM=new RotMot();
  newM.rot=PVector.mult(m.rot,h);
  newM.rotDot=PVector.mult(m.rotDot,h);
  return newM;
}
public RotMot add(RotMot m1, RotMot m2){
  RotMot newM=new RotMot();
  newM.rot=PVector.add(m1.rot,m2.rot);
  newM.rotDot=PVector.add(m1.rotDot,m2.rotDot);
  return newM;
}

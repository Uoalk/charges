

public class System{
  Charged[] charges;
  public float dt=(float)0.001;
  public float t;
  public System(){
    //charges=new Charged[]{ new Point(0.001,new PVector(0,0,0)),new Point(-0.001, new PVector(10,1,1))};
    //charges=new Charged[]{new Point(0.001,new PVector(3,100,0)), new Rod(0.10, new PVector(0,0,0)), new SquareLamina(0.001, new PVector(5,5,5))};
    
    charges=new Charged[]{new SquareLamina(0.1,new PVector(0,0,0))};//,new Rod(0.01,new PVector(3,30,3))};
    
    charges[1].getState().orientation=new Quaternion(1,1,0,0);
    charges[1].getState().velocity=new PVector(0,-100,0);
    //((Point)charges[0]).state.velocity=new PVector(0,-800,0);
    //((Rod)charges[1]).state.velocity=new PVector(0,0,0);
    //charges[2].setMot(new Mot(new PVector(0,3,0),new PVector(54,0,0)));
    
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
        if(i!=j)e+=i.getPotential(j.getState().position)*j.getCharge()*0.5;
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
  public float getPotential(PVector loc, Charged source){
    float potential=0;
    for(Charged i: charges){
      if(i!=source)potential+=(i.getPotential(loc));

    }
    return potential;
  }
}

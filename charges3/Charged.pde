import processing.core.PVector;

public interface Charged {
  public Charged clone();
  public PVector getField(PVector loc);
  public float getCharge();
  public void draw();
  public void run(System s, float dt);
  public float KE();
  public float PE(System s);
  public State getState();
  public void setState(State s);
  public float getPotential(PVector loc);
  public PVector acceleration(System s);
  public PVector angularAcceleration(System s);

}

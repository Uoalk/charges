
public class SquareLamina extends RigidBody{
  float l=10;
  float pointSpacing=1;
  public SquareLamina(float charge, PVector position){
    super(charge, position);
    this.mass=100;
  }
  
  public Point[] getPoints(){
    int pointCount=(int)((l/pointSpacing)*(l/pointSpacing));
    Point[] points=new Point[pointCount];
    int index=0;
    for(float i=-l/2;i<l/2;i+=pointSpacing){
      for(float j=-l/2;j<l/2;j+=pointSpacing){
        
        
        //local Position
        PVector p=new PVector(0,i, j);
        float[] m=state.orientation.getMatrix();
        
        
        PVector rotatedPosition=new PVector(p.x*m[0]+p.y*m[1]+p.z*m[2], p.x*m[4]+p.y*m[5]+p.z*m[6], p.x*m[8]+p.y*m[9]+p.z*m[10]);
        
        points[index]=new Point((int)(charge/pointCount),
        PVector.add(state.position,rotatedPosition));
        
        points[index].mass=mass/pointCount;
        index++;
      }
    }
    return points;
  }
  
  public void draw(){
     pushMatrix();
    
    translate(state.position.x,state.position.y,state.position.z);
    
    state.orientation.normalize();
    float[] m=state.orientation.getMatrix();
    applyMatrix(m[0], m[1], m[2], m[3], m[4], m[5], m[6], m[7], m[8], m[9], m[10], m[11], m[12], m[13], m[14], m[15]);
    
    box(1,l,l);
    popMatrix(); 
  }
  
  
  
  
}

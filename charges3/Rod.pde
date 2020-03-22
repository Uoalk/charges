import processing.core.PVector;
public class Rod extends RigidBody{
  int pointCount=50;
  float l=10;
  public Rod(float charge, PVector position){
    super(charge, position);
    this.mass=1;
  }
  
  public Point[] getPoints(){
    Point[] points=new Point[pointCount];
    for(int i=0;i<pointCount;i++){
      
      //local Position
      PVector p=new PVector(0,0, (pointCount/2.0-i-0.5)/pointCount*l);
      float[] m=state.orientation.getMatrix();
      
      
      PVector rotatedPosition=new PVector(p.x*m[0]+p.y*m[1]+p.z*m[2], p.x*m[4]+p.y*m[5]+p.z*m[6], p.x*m[8]+p.y*m[9]+p.z*m[10]);
      
      points[i]=new Point(charge/pointCount, PVector.add(state.position,rotatedPosition));
      
      points[i].mass=mass/pointCount;
    }
    return points;
  }
  
  public void draw(){
     pushMatrix();
    
    translate(state.position.x,state.position.y,state.position.z);
    
    state.orientation.normalize();
    float[] m=state.orientation.getMatrix();
    applyMatrix(m[0], m[1], m[2], m[3], m[4], m[5], m[6], m[7], m[8], m[9], m[10], m[11], m[12], m[13], m[14], m[15]);
    
    box(1,1,l);
    popMatrix(); 
    //super.draw();
  }
  
  
  
  
}

public class Quaternion
{
    public Quaternion(float w,float x,float y,float z){
      this.w=w;
      this.x=x;
      this.y=y;
      this.z=z;
    }
    float w,x,y,z;
    public void normalize(){
      float c=(float)Math.sqrt(w*w+x*x+y*y+z*z);
      if(c==0){
        w=1;x=0;y=0;z=0;
        return;  
      }else{
         w=w/c;
         x=x/c;
        y=y/c;
        z=z/c;
      }
     
     
    }
    public float[] getMatrix(){
      return new float[]{
        1-2*y*y-2*z*z, 2*x*y-2*z*w, 2*x*z+2*y*w, 0,
        2*x*y+2*z*w, 1-2*x*x-2*z*z, 2*y*z-2*x*w, 0,
        2*x*z-2*y*w, 2*y*z+2*x*w, 1-2*x*x-2*y*y, 0,
        0, 0, 0, 1};
      }
    
    static Quaternion mult(Quaternion a, Quaternion b){
        return new Quaternion(
        a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z,  // 1
        a.w * b.x + a.x * b.w + a.y * b.z - a.z * b.y,  // i
        a.w * b.y - a.x * b.z + a.y * b.w + a.z * b.x,  // j
        a.w * b.z + a.x * b.y - a.y * b.x + a.z * b.w   // k
        );
    }
    static Quaternion add(Quaternion a, Quaternion b){
      return new Quaternion(a.w+b.w, a.x+b.x, a.y+b.y, a.z+b.z);
    }
    static Quaternion mult(Quaternion a, float c){
      return new Quaternion(a.w*c, a.x*c, a.y*c, a.z*c);  
    }
    public String toString(){
      return w+", "+x+", "+y+", "+z;
    }
    
};


import ddf.minim.*;

Minim minim, minim2;
AudioInput in;
AudioOutput out;
import processing.net.*;

String ip = "10.42.3.204";
int port = 500;

Client c, c1;
String input;
float frate = 50;

int maxx = 0;
long timm1 = 0;

boolean th = false, ma = false, pl = false, mi = false , pause = false, high = false, fr = false;


float calib = 0;
float minL = 0, maxL = 0;

boolean up = false, down = false, right = false, left = false;


void send_data(String levl)
{

   try { c.output.write(levl.getBytes()); 
 //        println("\t good\t" + c.active()+ "\t" + millis() ); 
       }
    catch (Exception ee) 
          {
     println("bad bad bad\t" + millis()); delay(500);
     c = new Client(this, ip, port);   //c.write(aa.getBytes()); 
   //ee.printStackTrace();
          }

  if (c.available() > 0) {
    input = c.readString();
    input = input.substring(0, input.indexOf("\n")); // Only up to the newline
     println(input);
  }
  
}
 void setup() 
{

  background(0);
  //stroke(0);
  frameRate(frate); 
    size(360, 360);

  minim = new Minim(this);
  minim2 = new Minim(this);

  in = minim.getLineIn(Minim.STEREO, 2048);
  out = minim2.getLineOut(Minim.STEREO, 2048);
  
     c = new Client(this, ip, port); 
  
   int timm = millis();
   int ii =0 ;
  while(millis() - timm < 5000)
  {calib += (in.left.level()*640+in.right.level()*640)/20; ii++; delay(1);}
   println(ii);
   calib /= ii;
   calib *= 10;
   calib *= 1.3;
   minL = calib;
   maxL = 500;
   println(calib);
   delay(300);

}

 void draw() 
{
    background(0); 
   noStroke();

  //       ellipse(width/2, height/2, in.left.level()*width, in.right.level()*width);


float avgg = (in.left.level()*640+in.right.level()*640)/2;
float cali = avgg - calib;
float cali1 = constrain(avgg, minL,maxL);
 cali1 = map(cali1, minL, maxL, 0, 1023);  

//float sout = (out.left.level()*640+out.right.level()*640)/2;
float sout1 = 0; 
println(out.bufferSize() + "\t");
  for( int i = 0; i < out.bufferSize() - 1; i++ )
  {
    // find the x position of each buffer value
    float x1  =  map( i, 0, out.bufferSize(), 0, 200 );
    float x2  =  map( i+1, 0, out.bufferSize(), 0, 200 );
    // draw a line from one buffer position to the next for both channels
    line( x1, 50 + out.left.get(i)*50, x2, 50 + out.left.get(i+1)*50);
    line( x1, 150 + out.right.get(i)*50, x2, 150 + out.right.get(i+1)*50);
    sout1 += out.right.get(i) + out.left.get(i);
    
  }  

//avgg = constrain(avgg, 0,600);
cali = constrain(cali, 0,600);
  float kavgg = map(avgg, 0,600,400,1023);
  cali = map(cali, 0,600,400,1023);
  
  int avg  = (int)(avgg+0.5);
  //int ical = (int)(cali+0.5);
  int ical1 = (int)(cali1+0.5);;
         fill( 255, 0, 0 );
         ellipse(width/2, height/2, avg/3, avg/3);
         fill(0,0,255);
         ellipse(width/2, height/2, ical1/3,ical1/3);
  
ical1 = constrain(ical1, 0,1023);
  if (ical1 > maxx) maxx = ical1;

if(millis() - timm1 > 200 )
{ //  println(avg + "\t" + ical1 + '\t' +  maxx + "\tboo\t" + th + "\t" + ma + "\t" + pl + "\t" + mi);
//println(ical1);
println(sout1);
timm1 = millis();}


if (pause) 
{
  if (high) ical1 = 1023;
  else ical1 = 0;
  textSize(15); stroke(255,255,255); strokeWeight(2); fill(255,255,255);
  text("P" , 200, height - 5);
}
  
  String lev = "s" + ical1 + "d" + "\n";
send_data(lev);  
  
  textSize(15); stroke(255,255,255); strokeWeight(2); fill(255,255,255);
  text((int)calib, 10, height- 5 );
  text((int)minL, 50, height- 5 ); text(avg, 100, height- 5 ); text((int)maxL, 150, height- 5 );
   text(ical1, 260, height- 5 ); text((int)frate, 310, height- 5 );
  // text("0", 220, height- 5 ); text(ical1, 260, height- 5 ); text("1023", 310, height- 5 );
  
if (right) minL += 1;
if (left)  minL -= 1;
if (up)    maxL += 1;
if (down)  maxL -= 1;

if (fr && pl) {frate += 0.5; frate = constrain(frate, 20, 100);frameRate(frate); }
if (fr && mi) {frate -= 0.5; frate = constrain(frate, 20, 100);frameRate(frate); }

}


 void keyPressed()
{
  //println(keyCode);
  if (keyCode ==  19 )  {pause = !pause;} 
  switch (keyCode)
    {
      case LEFT : { left = true; } break; case RIGHT: { right = true; } break; 
      case UP : { up = true; } break;  case DOWN : { down = true; } break; 
      
    }
  switch (key)
   {
    
    case 'F' : { fr = true;} break;   case 'f' : { fr = true;} break; 
    case '+' : {pl = true;} break;    case '-' : {mi = true;} break;
    
    
    case 'p' : {pause = !pause;} break;   case 'P' : {pause = !pause;} break;
    case 'h' : {high = !high;} break;     case 'H' : {high = !high;} break;
    
    case '/' : {pause = !pause;} break;    case '*' : {high = !high;} break; 
    case '0' : {pause = true; high = true;} break;
    
    case '.' : { if (!pause) { pause = true; high = true;}
                  else { if (!high) {high = true; pause = false;} else high = false;} }
    
   }
  
}

void keyReleased()
{
  switch (keyCode)
    {
      case LEFT : { left = false; } break; case RIGHT: { right = false; } break; 
      case UP : { up = false; } break;  case DOWN : { down = false; } break;  
    }
  switch (key)
   {
  
  case '+' : {pl = false;} break;     case '-' : {mi = false;} break;
    
    case 'F' : { fr = false;} break;   case 'f' : { fr = false;} break;
    case '0' : {pause = false; high = false;} break;
    
   }
}
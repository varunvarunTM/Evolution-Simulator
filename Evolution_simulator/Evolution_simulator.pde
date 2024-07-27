int cellscale = 4;
int mapwidth, mapheight;
int gridwidth, gridheight;
map themap;
float zoom, cameraX, cameraY;
int foodCount = 0;
int minpop = 100;
ArrayList<creature> pop;

int numgenes;
HashMap<String, Integer> genes = new HashMap<String, Integer>();


void setup(){
  size(800,1000,P3D);
  genes.put("angle",0);
  genes.put("distance",1);
  genes.put("appendage",2);
  genes.put("fruitturnspeed",3);
  genes.put("seaweedturnspeed",4);
  genes.put("landturnspeed",5);
  genes.put("waterturnspeed",6);
  genes.put("shape",7);
  genes.put("fruitenergy",8);
  genes.put("seaweedenergy",9);
  genes.put("speed",10);
  numgenes = genes.size();
  
  pop = new ArrayList<creature>();
  for(int i = 0; i < minpop; i++){
    pop.add(new creature());
  }
  
  mapwidth = 1*width;
  mapheight = 1*height;
  gridwidth = mapwidth/cellscale;
  gridheight = mapheight/cellscale;
  themap = new map();
  cameraX = width/2.0;
  cameraY = height/2.0;
  zoom = (height/2.0) / tan(PI*30.0/180.0);
  
  
}

void draw(){
  background(0);
  themap.addFood();
  themap.display();
  for(creature c: pop){
    c.update();
    c.display();
  }
  keyinput();
  reproduce();
  checkpop();
}

void checkpop(){
  for(int i = pop.size()-1; i >= 0; i--){
    creature c = pop.get(i);
    if(c.energy <= 0){
      pop.remove(i);
    }
  }
}

void reproduce(){
  for(int i = 0; i < pop.size(); i++){
    creature c = pop.get(i);
    if(c.energy > 1500){
      creature offspring = new creature();
      
      c.energy -= 1000;
      offspring.heading = random(0,2*PI);
      offspring.calcvalues();
      pop.add(offspring);
    }
  }
  if(pop.size() < minpop){
    creature c = new creature();
    pop.add(c);
  }
}

void keyinput(){
  if(keyPressed){
    if(keyCode == LEFT){
      cameraX-=5;
    }
    if(keyCode == RIGHT){
      cameraX+=5;
    }
    if(keyCode == UP){
      cameraY-=5;
    }
    if(keyCode == DOWN){
      cameraY+=5;
    }
    camera(cameraX,cameraY,zoom , cameraX,cameraY,0 , 0,1,0);
  }
}

void mouseWheel(MouseEvent event){
  float e = event.getCount();
  zoom += 20*e;
  camera(cameraX,cameraY,zoom , cameraX,cameraY,0 , 0,1,0);
}

float sigmoid(float x){
  float r = 0.5;
  return(2.0/(1+exp(-r*x)) - 1);
}

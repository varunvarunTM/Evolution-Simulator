class creature{
  float x,y;
  float heading;
  float[] genome;
  float basespeed, waterspeed, landspeed;
  float energyfruit, energyseaweed;
  color c;
  float energy;
  
  creature(){
    energy = 500;
    x = random(width);
    y = random(height);
    heading = random(2*PI);
    genome =  new float[numgenes];
    for(int i = 0; i< numgenes; i++){
      genome[i] = random(-5.0,5.0);
    }
    calcvalues();
  }
  
  void copy(creature source){
    x = source.x;
    y = source.y;
    for(int i = 0; i < genome.length; i++){
      genome[i] = source.genome[i];
    }
  }
  
  void mutate(){
    int gene =  int(random(genome.length));
    genome[gene] += random(-0.5,0.5);
  }
  
  void calcvalues(){
    basespeed = 2 + sigmoid(genome[genes.get("speed")]);
    waterspeed = basespeed*(1-(sigmoid(genome[genes.get("appendage")])));
    landspeed = basespeed*(1+(sigmoid(genome[genes.get("appendage")])));
    float sum = (1 + abs(sigmoid(genome[genes.get("fruitenergy")])) + abs(sigmoid(genome[genes.get("seaweedenergy")])));
    energyfruit = 200*(abs(sigmoid(genome[genes.get("fruitenergy")])))/sum;
    energyseaweed = 200*(abs(sigmoid(genome[genes.get("seaweedenergy")])))/sum;
    if (Math.abs(sigmoid(genome[genes.get("fruitenergy")])) > Math.abs(sigmoid(genome[genes.get("seaweedenergy")]))) {
      c = color(255*abs(sigmoid(genome[genes.get("fruitenergy")])),0,0);      
    } else {
      c = color(0,255*abs(sigmoid(genome[genes.get("seaweedenergy")])),0);
    }
  }
  
  void update(){
    float leftsensorX, leftsensorY;
    float rightsensorX, rightsensorY;
    int leftsensorR, leftsensorC;
    int rightsensorR, rightsensorC;
    float angle = sigmoid(genome[genes.get("angle")])*0.5*PI;
    float len = 3 + abs(sigmoid(genome[genes.get("distance")]))*cellscale;
    float speed = 1;
    leftsensorX = x + len*cos(heading+angle);
    leftsensorY = y + len*sin(heading+angle);
    rightsensorX = x + len*cos(heading-angle);
    rightsensorY = y + len*sin(heading-angle);
    leftsensorC = int(leftsensorX/cellscale);
    leftsensorR = int(leftsensorY/cellscale);
    rightsensorC = int(rightsensorX/cellscale);
    rightsensorR = int(rightsensorY/cellscale);
    fill(0);
    stroke(c);
    line(x,y,leftsensorX,leftsensorY);
    line(x,y,rightsensorX,rightsensorY);
    noStroke();
    circle(leftsensorX,leftsensorY,2);
    circle(rightsensorX,rightsensorY,2);
    
    float leftfoodscent = 0;
    float rightfoodscent = 0;
    int leftterrain,rightterrain;
    
    if(leftsensorC >= 0 && leftsensorC < gridwidth && leftsensorR >= 0 && leftsensorR < gridheight && rightsensorC >= 0 && rightsensorC < gridwidth && rightsensorR >=0 && rightsensorR < gridheight){
      leftfoodscent = themap.map[leftsensorR][leftsensorC].fruitscent;
      rightfoodscent = themap.map[rightsensorR][rightsensorC].fruitscent;
      heading += sigmoid(genome[genes.get("fruitturnspeed")])*0.25*PI*(leftfoodscent-rightfoodscent);
      
      leftfoodscent = themap.map[leftsensorR][leftsensorC].seaweedscent;
      rightfoodscent = themap.map[rightsensorR][rightsensorC].seaweedscent;
      heading += sigmoid(genome[genes.get("seaweedturnspeed")])*0.25*PI*(leftfoodscent-rightfoodscent);
      
      if(themap.map[leftsensorR][leftsensorC].altitude >= 0){
        leftterrain = 1;
      } else {
        leftterrain = -1;
      }
      
      if(themap.map[rightsensorR][rightsensorC].altitude >= 0){
        rightterrain = 1;
      } else {
        rightterrain = -1;
      }
      
      heading += sigmoid(genome[genes.get("landturnspeed")])*0.25*PI*(leftterrain - rightterrain);
      heading += sigmoid(genome[genes.get("waterturnspeed")])*0.25*PI*(leftterrain - rightterrain);
    }
      
    if(themap.map[int(y/cellscale)][int(x/cellscale)].altitude < 0) { // water
      speed = waterspeed;
    } else {
      speed = landspeed;
    }
    x += speed*cos(heading);
    y += speed*sin(heading);
    if(x < 0 || x > width || y < 0 || y > height){
      heading += PI;
      x += speed * cos(heading);
      y += speed * sin(heading);
    }
    eat();
    energy -= abs(0.1 + basespeed);
  }
  
  void eat(){
    int cellX,cellY;
    cellX = int(x/cellscale);
    cellY = int(y/cellscale);
    if(themap.map[cellY][cellX].food == "fruit"){
      energy += energyfruit;
      themap.changescent(cellY,cellX,-1);
      themap.map[cellY][cellX].food = "";
    }
    if(themap.map[cellY][cellX].food == "seaweed"){
      energy += energyseaweed;
      themap.changescent(cellY,cellX,-1);
      themap.map[cellY][cellX].food = "";
    }
  }
  
  
  void display(){
    fill(c);
    pushMatrix();
      translate(x,y);
      rotate(heading);
      float append = sigmoid(genome[genes.get("appendage")]);
      pushMatrix();
        scale(abs(append));
        if(append < 0){ // tail
          translate(-cellscale,0);
          rotate(0.5*sin(0.5*frameCount));
          triangle(0,0, -cellscale,-0.5*cellscale,-cellscale,0.5*cellscale);
        } else {
          stroke(c);
          strokeWeight(3);
          line(0,-2*cellscale,0,2*cellscale);
        }
      popMatrix();
        noStroke();
      ellipse(0,0,cellscale,cellscale*(1+(sigmoid(genome[genes.get("shape")]))));
    popMatrix();
  }
}

  
  

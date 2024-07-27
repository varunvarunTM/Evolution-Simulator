class map{
  cell map[][];
  
  map(){
    map = new cell[gridheight][gridwidth];
    float a;
    float noisescale = 0.01;
    for(int r = 0; r < gridheight; r++){
      for(int c = 0; c < gridwidth; c++){
        a = noise(r*noisescale,c*noisescale);
        a = map(a,0,1,-1,1);
        map[r][c] = new cell(a);
      }
    }
    for(int i = 0; i < 100; i++){
      addFood();
    }
  }
  
  void changescent(int row, int col, int flag){
    float scent;
    int scentrange = 5;
    for(int r = row - scentrange; r <= row+scentrange; r++){
      for(int c = col - scentrange; c <= col+scentrange; c++){
        scent = scentrange/(1+pow(abs(r-row),2)+pow(abs(c-col),2));
        if((r >= 0) && (r < gridheight) && (c >= 0) && (c < gridwidth)){
          if(map[row][col].food == "fruit"){
            map[r][c].fruitscent += scent*flag;
          }
          if(map[row][col].food == "seaweed"){
            map[r][c].seaweedscent += scent*flag;
          }
        }
      }
    }
  }
  
  void addFood(){
    int r,c;
    r = int(random(gridheight));
    c = int(random(gridwidth));
    if(map[r][c].food != ""){
      return;
    }
    if(map[r][c].altitude < 0){
      map[r][c].food = "seaweed";
    } else {
      map[r][c].food = "fruit";
    }
    changescent(r,c,1);
  }
  
  void displayscent(){
    for(int r = 0; r < gridheight;r++){
      for(int c = 0; c < gridwidth;c++){
        if(map[r][c].fruitscent > 0){
          fill(255,0,0,map[r][c].fruitscent*20);
          rect(c*cellscale,r*cellscale,cellscale,cellscale);
        }
        if(map[r][c].seaweedscent > 0){
          fill(0,255,0,map[r][c].seaweedscent*20);
          rect(c*cellscale,r*cellscale,cellscale,cellscale);
        }
      }
    }
  }
   
     void display(){
       noStroke();
       for(int r = 0; r < gridheight; r++){
         for(int c = 0; c < gridwidth; c++){
           if(map[r][c].altitude < 0){
             fill(0,0,255-map[r][c].altitude*-200);
           } else {
             fill(0,255-map[r][c].altitude*200,0);
           }
           rect(c*cellscale,r*cellscale,cellscale,cellscale);
           if(map[r][c].food == "fruit"){
             fill(200,50,50);
             circle(c*cellscale+cellscale*0.5,r*cellscale+cellscale*0.5,cellscale * 0.5f);
           }
           if(map[r][c].food == "seaweed"){
             fill(150,200,50);
             circle(c*cellscale+cellscale*0.5,r*cellscale+cellscale*0.5,cellscale * 0.5f);
           }
         }
       }
       displayscent();
     }
};

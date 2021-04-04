/* @pjs font="Arial.ttf"; */

// Setup the Processing Canvas
var fps = 6;
void setup(){
  size( 500, 400 );
  strokeWeight( 10 );
  frameRate( fps );
}

noStroke();

/*

This game is the creation of Denis Auroux - the Math Professor who taught at MIT and currently is teaching at UCB. (http://www-math.mit.edu/~auroux/)

The Java Applet code for this game is made available by him under a free license here :- 
https://math.berkeley.edu/~auroux/software/index.html 

https://math.berkeley.edu/~auroux/software/freefall.zip 


I am using the tilemaps and game ideas from his code.

Credit for the game goes to him.

*/

{
//LevelCode entry not yet implemented.

var customCharMade = 0 ;

var start = 0 ;
var level = 0 ;
var target = 0;

var levelsComplete = 0;

var getCode = 0;

var enableNextLevel = 0;

var keyArray = [];
var cellImages = [];
var levels ;

var levelCodes = [35690,	99518,	98862,	81733,	68400,
16942,	40552,	63428,	75527,	67532,
76574,	42396,	83471,	87531,	63045,
80561,	90929,	61023,	67246,	55002,
92083,	38191,	30282,	40226,	35616,
99818,	84656,	68323,	47334,	51940,
76428,	33728,	];

//Queue datastructure :- 

var cellQueue = function(){
    
    this.data = [];
    this.begIdx = 0;
    this.nextIdx = 0;
};

cellQueue.prototype.isEmpty = function(){
    if(this.begIdx === this.nextIdx){
        return true;
    }
    else{
        return false;
    }
};

cellQueue.prototype.enqueue = function(x,y){

  if(  this.nextIdx >= this.data.length){
      this.data.push([x,y]);
      this.nextIdx++;
      return;
  }
  this.data[this.nextIdx] = [x,y];
  this.nextIdx++;
};

cellQueue.prototype.dequeue = function(){  // do not dequeue without checking for emptyness first.
    var temp = this.data[this.begIdx];
    this.begIdx++;
    if(this.begIdx === this.nextIdx){
        this.data = [];
        this.begIdx = 0;
        this.nextIdx = 0;
    }
    
    return temp;
};

cellQueue.prototype.clear = function(){
    this.begIdx = 0;
    this.data = [];
    this.begIdx = 0;
    this.nextIdx = 0;
};

var cellQ = new cellQueue();
var nmoves = [15,25,10,13,10,14,22,3,1,35,21,28,30,26,29,37,33,27,82,33,36,47,36,8,24,32,34,36,42,45,45,19];

var movesRem = nmoves[level];

//the map is 10 x 6 . will try to make use of full canvas later.
var initLevels = function(){
    levels  = [
      [[0,0,0,0,0,0,0,0,0,0],
       [0,0,0,0,0,0,0,0,4,0],
       [0,0,0,0,0,0,2,3,1,1],
       [0,0,0,0,0,3,1,1,1,1],
       [0,0,4,2,1,1,1,1,1,1],
       [1,1,1,1,1,1,1,1,1,1]],

      [[1,3,1,1,1,1,1,1,1,2],
       [1,2,3,0,0,0,2,3,2,3],
       [1,1,1,0,1,0,1,1,1,1],
       [1,1,1,1,1,0,1,1,1,1],
       [1,1,1,1,1,1,1,1,1,1],
       [1,1,1,1,1,1,1,1,1,1]],

      [[0,0,0,0,0,2,0,0,0,0],
       [0,0,0,0,0,3,0,3,0,0],
       [0,0,0,0,0,1,0,1,0,0],
       [0,0,0,0,0,4,0,0,0,0],
       [0,0,2,3,4,2,3,0,0,0],
       [1,1,1,1,1,1,1,1,1,1]],

      [[0,0,0,0,0,3,2,1,0,0],
       [0,0,0,0,0,1,1,1,0,0],
       [0,0,0,2,3,0,0,0,0,0],
       [0,0,0,1,1,0,0,0,0,0],
       [0,0,2,3,2,3,0,0,0,0],
       [1,1,1,1,1,1,1,1,1,1]],

      [[0,0,2,0,0,0,4,0,0,0],
       [0,0,3,0,0,0,1,0,0,0],
       [0,0,4,0,0,0,0,0,0,0],
       [0,0,3,0,0,0,0,0,0,0],
       [0,0,2,0,1,4,0,0,0,0],
       [1,1,1,1,1,1,1,1,1,1]],

      [[0,0,0,4,0,0,0,0,0,0],
       [0,0,0,1,0,0,0,0,0,0],
       [0,0,4,0,0,0,0,0,0,0],
       [0,0,3,0,4,5,0,0,0,0],
       [0,5,2,0,2,3,0,0,0,0],
       [1,1,1,1,1,1,1,1,1,1]],

      [[2,0,2,0,2,0,2,0,2,0],
       [1,0,1,0,1,0,1,0,1,0],
       [0,3,0,3,0,3,0,3,0,3],
       [0,1,0,1,0,1,0,1,0,1],
       [0,0,0,0,0,0,0,0,0,0],
       [1,1,1,1,1,1,1,1,1,1]],

      [[0,0,4,0,0,0,0,0,0,0],
       [0,0,3,0,0,0,0,0,0,0],
       [0,2,1,0,0,0,0,0,0,0],
       [0,3,2,0,0,0,0,0,0,0],
       [3,2,4,0,0,0,0,0,0,0],
       [1,1,1,1,1,1,1,1,1,1]],

      [[0,0,0,0,6,0,0,0,0,0],
       [0,0,0,0,4,6,4,0,0,0],
       [0,0,0,0,3,2,5,0,0,0],
       [0,0,0,0,4,3,2,0,0,0],
       [0,0,0,4,3,2,5,4,0,0],
       [1,1,1,1,1,1,1,1,1,1]],

      [[4,2,0,0,0,0,0,2,3,0],
       [1,1,4,1,2,1,3,1,1,0],
       [2,1,1,1,1,1,1,1,1,3],
       [3,1,4,1,2,1,5,1,0,5],
       [4,0,2,0,4,0,4,0,0,2],
       [1,1,1,1,1,1,1,1,1,1]],

      [[0,5,0,4,0,0,0,0,0,0],
       [0,3,0,2,0,0,0,0,0,0],
       [0,1,0,1,3,1,0,0,0,0],
       [0,5,0,0,1,0,0,0,0,0],
       [5,4,2,0,0,2,0,0,0,0],
       [1,1,1,1,1,1,1,1,1,1]],

      [[1,2,1,1,1,1,3,1,0,3],
       [1,3,1,0,0,3,2,1,0,2],
       [1,4,0,0,0,1,1,1,0,3],
       [1,1,1,1,0,1,1,3,0,1],
       [1,1,4,0,0,0,1,2,0,0],
       [1,1,1,1,1,1,1,1,1,1]],

      [[0,0,0,0,2,1,0,3,2,0],
       [2,1,5,3,1,0,4,1,1,0],
       [1,0,4,1,0,3,1,1,0,0],
       [0,0,1,0,5,1,1,0,0,0],
       [0,0,0,0,1,1,2,3,0,0],
       [1,1,1,1,1,1,1,1,1,1]],

      [[0,0,0,2,0,0,0,0,0,0],
       [0,0,2,1,1,0,2,0,0,0],
       [0,2,3,1,1,5,1,1,0,0],
       [1,1,4,0,1,4,1,1,3,0],
       [1,1,5,0,0,3,0,1,2,3],
       [1,1,1,1,1,1,1,1,1,1]],

      [[2,0,0,0,0,0,0,4,0,2],
       [1,4,0,0,3,0,0,3,0,1],
       [1,1,6,7,1,1,1,1,0,2],
       [5,0,7,6,0,0,1,1,0,1],
       [1,1,1,1,0,0,5,1,2,1],
       [1,1,1,1,1,1,1,1,1,1]],

      [[8,7,0,0,0,0,0,4,0,2],
       [1,4,0,0,3,8,0,3,0,1],
       [1,1,6,0,1,1,2,1,0,2],
       [5,0,7,6,0,0,1,1,0,1],
       [1,1,1,1,0,0,5,1,2,1],
       [1,1,1,1,1,1,1,1,1,1]],

      [[2,3,4,0,0,2,0,0,2,6],
       [1,1,1,3,1,1,1,0,1,1],
       [0,0,0,4,1,5,6,0,0,1],
       [1,1,0,1,1,1,1,0,1,1],
       [0,0,0,0,0,1,5,0,0,1],
       [1,1,1,1,1,1,1,1,1,1]],

      [[2,0,0,0,4,0,4,0,0,5],
       [1,1,0,3,1,1,1,0,3,1],
       [1,4,0,1,1,0,4,0,1,1],
       [1,1,3,0,0,0,1,3,0,1],
       [1,1,1,0,5,1,1,1,0,2],
       [1,1,1,1,1,1,1,1,1,1]],

      [[2,3,2,4,0,0,0,3,2,3],
       [1,1,1,1,1,1,0,1,1,1],
       [4,5,6,5,0,0,0,0,0,1],
       [1,1,1,1,0,1,1,1,0,6],
       [1,4,5,0,0,0,0,1,1,1],
       [1,1,1,1,1,1,1,1,1,1]],

      [[1,1,4,2,0,4,1,0,2,5],
       [1,1,1,1,0,1,1,0,1,1],
       [1,1,0,5,3,0,1,0,3,1],
       [1,1,0,1,1,0,0,0,1,1],
       [0,0,0,4,1,0,1,0,0,5],
       [1,1,1,1,1,1,1,1,1,1]],

      [[1,0,0,0,0,4,0,4,2,1],
       [1,0,2,0,2,5,0,1,1,1],
       [1,0,1,1,1,3,0,5,3,1],
       [1,0,5,0,1,1,0,1,1,1],
       [1,5,1,2,1,0,3,0,0,1],
       [1,1,1,1,1,1,1,1,1,1]],

      [[1,2,0,0,0,5,4,3,2,1],
       [1,1,0,1,2,1,1,1,1,1],
       [1,0,4,1,5,0,0,0,4,1],
       [1,0,1,1,1,1,1,0,1,1],
       [1,0,4,3,1,0,0,0,0,1],
       [1,1,1,1,1,1,1,1,1,1]],

      [[0,0,0,0,2,0,0,6,5,7],
       [0,0,0,0,1,0,2,1,1,1],
       [0,0,0,0,0,3,5,0,0,0],
       [0,0,1,1,0,1,6,0,0,0],
       [0,7,2,1,4,0,4,1,0,3],
       [1,1,1,1,1,1,1,1,1,1]],

      [[0,2,5,4,5,2,0,1,0,0],
       [0,3,7,6,7,3,0,1,0,0],
       [0,2,5,4,5,2,0,1,0,0],
       [0,3,7,6,7,3,0,1,0,0],
       [0,2,5,4,5,2,0,1,0,0],
       [1,1,1,1,1,1,1,1,1,1]],

      [[0,0,7,0,0,5,0,0,0,0],
       [0,1,1,0,3,6,0,0,0,2],
       [0,0,4,0,5,4,0,0,0,1],
       [5,0,1,0,4,3,0,0,0,0],
       [1,7,0,4,3,2,0,1,6,0],
       [1,1,1,1,1,1,1,1,1,1]],

      [[4,0,2,0,0,3,0,5,7,0],
       [1,0,1,0,0,4,0,1,3,0],
       [0,0,0,0,2,1,0,0,2,0],
       [0,0,1,0,1,0,6,0,1,0],
       [5,1,6,0,0,0,1,0,0,7],
       [1,1,1,1,1,1,1,1,1,1]],

      [[4,3,0,0,0,0,7,0,0,7],
       [1,1,2,0,0,5,6,0,6,5],
       [0,0,1,0,2,1,1,0,7,1],
       [7,0,0,0,1,6,0,0,1,0],
       [1,4,0,0,2,1,0,3,6,0],
       [1,1,1,1,1,1,1,1,1,1]],

      [[0,4,2,3,0,3,5,7,0,0],
       [0,1,1,1,0,1,1,1,1,0],
       [2,0,4,0,0,6,7,5,0,6],
       [1,0,1,1,0,1,1,1,0,1],
       [2,0,0,0,1,0,0,6,0,0],
       [1,1,1,1,1,1,1,1,1,1]],

      [[0,0,0,0,0,6,0,0,6,0],
       [2,3,0,4,0,3,4,0,5,2],
       [1,1,0,1,0,1,1,0,1,1],
       [0,0,1,0,0,0,0,0,0,0],
       [2,0,0,0,0,5,6,1,0,0],
       [1,1,1,1,1,1,1,1,1,1]],

      [[7,8,5,0,4,3,0,5,2,3],
       [2,1,6,0,1,1,0,1,1,1],
       [1,1,1,0,6,4,0,1,0,5],
       [8,6,1,0,1,1,0,0,0,1],
       [7,5,0,0,1,0,0,1,0,6],
       [1,1,1,1,1,1,1,1,1,1]],

      [[6,0,7,8,5,0,0,6,3,7],
       [1,0,1,1,1,0,0,1,1,4],
       [7,0,2,0,5,0,0,0,0,8],
       [1,0,1,0,1,0,0,0,7,1],
       [1,2,3,4,2,1,5,1,5,1],
       [1,1,1,1,1,1,1,1,1,1]],

      [[2,3,1,1,2,1,3,1,0,3],
       [3,1,0,1,3,1,4,1,0,1],
       [4,0,1,1,4,0,2,1,0,4],
       [3,1,3,1,1,0,1,1,0,1],
       [2,0,4,1,1,0,1,1,3,4],
       [1,1,1,1,1,1,1,1,1,1]]
     ];
};


var customChar = function(){
    
    background(255,255,255);
    cellImages.push(get(0,0,400,400)); //0
    
    background(255,255,255);
    noStroke();
    fill(192,192,192);
    rect(20,20,380,380);
    cellImages.push(get(0,0,400,400)); //1
    
    background(255,255,255);
    noStroke();
    fill(251,7,0);
    rect(20,20,380,380);
    cellImages.push(get(0,0,400,400)); //2
  
    background(255,255,255);
    noStroke();
    fill(3,255,0);
    rect(20,20,380,380);
    cellImages.push(get(0,0,400,400)); //3
  
    background(255,255,255);
    noStroke();
    fill(3,2,227);
    rect(20,20,380,380);
    cellImages.push(get(0,0,400,400)); //4
  
    background(255,255,255);
    noStroke();
    fill(255,255,9);
    rect(20,20,380,380);
    cellImages.push(get(0,0,400,400)); //5
   
    background(255,255,255);
    noStroke(); 
    fill(11,255,255);
    cellImages.push(get(0,0,400,400)); //6

    background(255,255,255);
    noStroke();
    fill(245,0,255);
    rect(20,20,380,380);
    cellImages.push(get(0,0,400,400)); //7

    background(255,255,255);
    noStroke();
    fill(2,2,2);
    rect(20,20,380,380);
    cellImages.push(get(0,0,400,400)); //8

    background(0,0,0,0);
    fill(0,0,0);
    rect(0,0,20,150);
    rect(0,250,20,150);
    rect(0,0,150,20);
    rect(250,0,150,20);
    rect(380,0,20,150);
    rect(380,250,20,150);
    rect(0,380,150,20);
    rect(250,380,150,20);
    cellImages.push(get(0,0,400,400)); //cursor
    
    customCharMade = 1;
};
var tryMatches = function(x,y){
    var val = levels[level][y][x];
    var flag = false;
    if(y < 5 && levels[level][y+1][x] === val){
        levels[level][y+1][x] = 0 ; //its neighbors affected 
        
        flag = true;
        target--;
    }
    if(y > 0 && levels[level][y-1][x] === val){
        levels[level][y-1][x] = 0 ; //its neighbors affected 
        flag = true;
        target--;

    }
    if(x > 0 && levels[level][y][x-1] === val){
        levels[level][y][x-1] = 0 ; //its neighbors affected 
        if(y > 0 && levels[level][y - 1][x - 1] > 1){
            cellQ.enqueue(x-1,y-1);
        }
        flag = true;
        target--;
    }
    if(x < 9 && levels[level][y][x+1] === val){
        levels[level][y][x+1] = 0 ; //its neighbors affected 
        if(y > 0 && levels[level][y - 1][x + 1] > 1){
            cellQ.enqueue(x+1,y-1);
        }
        flag = true;
        target--;

    }
    if(flag === true){
        levels[level][y][x] = 0;
        target--;

    }
};
var tryFall = function(x,y){

    var newPos = y;
    while(newPos < 5 && levels[level][newPos+1][x] === 0){
        newPos++;
    }
    if(newPos !== y){
        levels[level][newPos][x] = levels[level][y][x];
        levels[level][y][x] = 0;
    }
    return newPos;
};

var boardObj = function(){
    this.scheduledFlag = false;
    this.process = new PVector(0,0);
    this.dir = 0;
    this.timer = 0;
};

boardObj.prototype.loadLevel = function(newLevel){
    if(newLevel >= 32){
        levelsComplete = 1;
    }
    initLevels(); // just for safety .
    level = newLevel;
    target = 0;
    movesRem = nmoves[level];
    for(var i = 0 ; i < 6 ; i++){
        for(var j = 0; j < 10 ; j++){
            if(levels[level][i][j] > 1){
                target++;
            }
        }
    }    
};


boardObj.prototype.scheduled = function(x,y,dir){
    this.scheduledFlag  = true;
    this.dir = dir;
    this.process.set(x,y);
};
boardObj.prototype.update = function(){
    if(this.timer > 0){
        this.timer = (this.timer + 1)%60;
        }
    if(this.scheduledFlag){
        levels[level][this.process.y][this.process.x + this.dir] = levels[level][this.process.y][this.process.x];
        levels[level][this.process.y ][this.process.x] = 0;
      
        var newY = tryFall(this.process.x + this.dir,this.process.y);
        tryMatches(this.process.x + this.dir,newY);
       
        if(this.process.y > 0 && levels[level][this.process.y - 1][this.process.x] > 1){
            cellQ.enqueue(this.process.x,this.process.y-1);
        }
        while(!cellQ.isEmpty()){
            var temp = cellQ.dequeue();
            var upIdx = temp[1]-1;

            if(upIdx >= 0 && levels[level][upIdx][temp[0]] > 1){
                cellQ.enqueue(temp[0],upIdx);
            }
            newY = tryFall(temp[0],temp[1]);
            tryMatches(temp[0],newY);
        }
        this.scheduledFlag = false;
        
        if(target === 0){
            enableNextLevel = 1;
            this.timer++;
            //this.loadLevel(level + 1);
        }
        
    }
    if(enableNextLevel === 1 && this.timer === 0){
        for(var i = 0 ; i < keyArray.length ; i++){
            if(keyArray[i] === 1){
                this.loadLevel(level+1);
                enableNextLevel = 0;
                return;
            }
        }
    }
};

var board = new boardObj();

var cursorObj = function(){
    this.position = new PVector(0,0);
    this.timer = 0;
};

cursorObj.prototype.draw  = function() {
    pushMatrix();
    translate(0,80);
    image(cellImages[9],40*this.position.x,40*this.position.y,40,40);
    popMatrix();
};

cursorObj.prototype.update = function(){
    if(this.timer > 0){
        this.timer = (this.timer + 1)%30;
    }
    if(this.timer !== 0){
        return;
    }
    
    if(keyArray[CONTROL] === 1){
        getCode = 1;
        return;
    }
    
    if(keyArray[ESC] === 1){
        board.loadLevel(level);
        return;
    }
    
    if(keyArray[SHIFT] === 0){
    if(keyArray[UP] === 1 && this.position.y > 0){
        this.position.y--;
        this.timer++;
    }
    if(keyArray[DOWN] === 1 && this.position.y < 5){
        this.position.y++;
        this.timer++;
    }
    if(keyArray[RIGHT] === 1 && this.position.x < 9){
        this.position.x++;
        this.timer++;
    }
    if(keyArray[LEFT] === 1 && this.position.x > 0){
        this.position.x--;
        this.timer++;
    }
    }
    else{
        if(movesRem === 0){
            return;
        }
        if(levels[level][this.position.y][this.position.x] > 1){
            if(keyArray[RIGHT] === 1 && (this.position.x < 9) && levels[level][this.position.y][this.position.x + 1] === 0){
                board.scheduled(this.position.x, this.position.y, 1);
                this.position.x++;
                movesRem--;
                this.timer++;
            }
            
            if(keyArray[LEFT] === 1 && (this.position.x > 0) && levels[level][this.position.y][this.position.x - 1] === 0){
                board.scheduled(this.position.x,this.position.y,-1);
                this.position.x--;
                movesRem--;
                this.timer++;
            }
        }
    }
};

var crsr = new cursorObj(0,0);


var drawTilemap  = function(){
    pushMatrix();
    translate(0,80);
    for(var i = 0 ; i < 6 ; i++){
        for(var j  = 0 ; j < 10 ; j++){
            image(cellImages[levels[level][i][j]],40*j,40*i,40,40);
        }
    }
    popMatrix();
};   

mouseClicked = function(){
    if(start === 0){
        start = 1;
    }
};

keyPressed = function(){
    keyArray[keyCode] = 1;
};

keyReleased = function(){
    keyArray[keyCode] = 0;
};


draw = function() {

/*    if(getCode === 1){
        background(38, 166, 189);
        fill(0,0,0);
        textSize(20);
        text("Enter Code\n",120,200);
        
        return;
    }*/
    if(start === 0){
        if(customCharMade === 0){
            customChar();
            initLevels();
            getCode  = 0;
            keyArray = [];
            target = 0;
            for(var i = 0 ; i < 6 ; i++){
                for(var j = 0; j < 10 ; j++){
                    if(levels[level][i][j] > 1){
                        target++;
                    }
                }
            }
        }
        levelsComplete = 0;
        keyArray[SHIFT] = 0;
        enableNextLevel = 0;
        level = 0 ; //start with level 0
        board.timer = 0;
        movesRem = nmoves[level];
        background(61, 189, 49);
        fill(24, 199, 106);
        rect(120,140,160,60,15);
        fill(0,0,0);
        textSize(25);
        text("Free Fall", 150,180);
        textSize(16);
        text("The aim of this game is to remove all \ncolored blocks from the board. Colored \nblocks cancel each other as soon as they \nare in contact, but are always subject to \ngravity first. The number of moves you \ncan make in a level is limited.",20,20);
        text("- Click mouse to start\n- Move pointer using arrows,\nshift-left or right to move a block.\n- Press Escape to restart the current level.\n- Press any key at the end of a level to\n start the following level.\n\n- FreeFall is copyright (c) Denis Auroux, 1996. ",20,230);
       // -  Press C to enter the code corresponding\n to the level you wish to reach.

    }
    else if(start === 1){
        if(levelsComplete === 1){
            background(61, 189, 49);
            fill(24, 199, 106);
            rect(120,140,160,60,15);
            fill(0,0,0);
            textSize(25);
            text("You won", 150,180);
            return;
        }
        
        background(50, 60, 61);
        drawTilemap();
        crsr.draw();
        crsr.update();
        board.update();
        fill(18, 230, 159);
        textSize(20);
        text("Moves Remaining :- "+movesRem,30,360);
       // text("Level Code :- "+levelCodes[level],30,385);
        
    }
};
}

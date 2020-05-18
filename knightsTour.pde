/* @pjs font="Arial.ttf"; */

// Setup the Processing Canvas
var fps = 6;
void setup(){
  size( 500, 400 );
  strokeWeight( 10 );
  frameRate( fps );
}

noStroke();

var numMoves = 0 ; 
var squaresLeft = 64;

function square(x,y){

    this.rowNum = x;
    this.colNum = y;
    this.bwFlag = (x+y)%2 ; 
    
    this.cR = (this.bwFlag === 1 ? 171 : 210);
    this.cG = (this.bwFlag === 1 ? 171 : 210);
    this.cB = (this.bwFlag === 1 ? 171 : 210);
    
    this.pieceFlag = false;
    this.firstOccupation = false;

};

square.prototype.hasPiece = function(){
    return this.pieceFlag;
};
square.prototype.putPiece = function(){
  this.pieceFlag = true;  
  if(this.firstOccupation === false){
      this.firstOccupation = true;
      squaresLeft--;
  }
};
square.prototype.removePiece = function(){
    this.pieceFlag = false;
};
square.prototype.draw = function() {
    
    fill(this.cR, this.cG, this.cB);
    rect(this.rowNum*50, this.colNum*50, 50,50);
    if(this.firstOccupation === true){
        fill(0, 255, 0);
        ellipse(this.rowNum * 50 + 25, this.colNum*50 + 25,10,10);
    }
    
    
};

var pieceSelected = false;

function knight(x,y){
    this.rowNum = x;
    this.colNum = y;
    
    this.xPos = x*50 - 5;
    this.yPos = (y+1)*50;
};

knight.prototype.draw = function() {
    textFont(createFont("Arial"));
    if(pieceSelected === true){
        if((this.rowNum + this.colNum)%2 === 1){
            fill(131, 131,131);
        }
        else{
            fill(240, 240, 240);
        }
        rect(this.rowNum*50, this.colNum*50, 50,50);
    }
    textSize(65);
    fill(255, 255, 255);
    text("♞",this.xPos,this.yPos);
};

knight.prototype.move = function(x1,y1){
  this.xPos = x1;
  this.yPos = y1;
};

knight.prototype.setPos = function(){
    this.rowNum = floor(mouseX/50);
    this.colNum = floor(mouseY/50);
    
    this.xPos = this.rowNum*50 - 5;
    this.yPos = (this.colNum+1)*50;
};

knight.prototype.isLegalMove = function(){
   var newRow = floor(mouseX/50);
   var newCol = floor(mouseY/50);
   return (abs(newRow - this.rowNum) === 2 && abs(newCol - this.colNum) === 1) || 
          (abs(newRow - this.rowNum) === 1 && abs(newCol - this.colNum) === 2);
};

var squares = [];

for(var i = 0 ; i < 8 ; i++)
{
    squares[i] = [];
    for(var j = 0 ; j < 8 ; j++){
      squares[i].push(new square(i,j));
    }
}


void displayScore(){
    textFont(createFont("Arial"));
    textSize(14);
    fill(0, 0, 0);
    text("Moves",420,130);
    text(numMoves,430,150);
    text("squares left",420,170);
    text(squaresLeft,430,190);
    if(squaresLeft === 0){
        text("DONE !",420,210);
    }
};



var knightW = new knight(3,4);
squares[3][4].putPiece();
var dragged = false;

void mousePressed()
{

    if(pieceSelected === false){
        if(squares[floor(mouseX/50)][floor(mouseY/50)].hasPiece() === true){
            //println("piece Selected");
            pieceSelected = true;
            squares[floor(mouseX/50)][floor(mouseY/50)].removePiece();
            
        } 
    }

};

void mouseDragged(){
    if(pieceSelected === true){
        dragged = true;
        if(mouseX < 400){
            knightW.move(mouseX-13,mouseY);
        }
    }

};

void mouseReleased(){
  pieceSelected = false;
    if(mouseX < 400 && knightW.isLegalMove()){
            squares[floor(mouseX/50)][floor(mouseY/50)].putPiece();
            if(squaresLeft > 0){
                numMoves++;
            }
            knightW.setPos();
        }
    else{
        squares[knightW.rowNum][knightW.colNum].putPiece();
        knightW.move(knightW.rowNum*50 - 5, (knightW.colNum + 1)*50);
    }
};

void draw() {
    background(255,255,255);
    //Draw the empty chess Board.
    for (var i = 0; i < squares.length; i++) {
        for(var j = 0; j < squares[i].length; j++){
            squares[i][j].draw();
        }
    }
    knightW.draw();
    displayScore();
};

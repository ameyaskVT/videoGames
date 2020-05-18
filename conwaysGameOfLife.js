var sketchProc=function(processingInstance){ with (processingInstance){

size(400, 400); 
frameRate(60);
  
var gamestate = 0;
    
var gameboard = function()
{
    this.framenum = 0;
    
    this.squares = new Array(40);
    this.nextsq = new Array(40);
    for(var i = 0 ; i < 40 ; i++)
    {
        this.squares[i] = new Array(36);
        this.nextsq[i] = new Array(36);
    }
    
    for(var i = 0 ; i < 40 ; i++)
    {
        for(var j = 0 ; j < 36 ; j++)
        {
            this.squares[i][j] = 0;
            this.nextsq[i][j] = 0;
        }
    }
    
};

gameboard.prototype.processmouseclick = function(x,y)
{
    if(gamestate === 0)
    {
        var xpos = floor(x/10);
        var ypos = floor(y/10);
        
        if(xpos >= 0 && xpos < 40 && ypos >= 0 && ypos < 36)
        {
            this.squares[xpos][ypos] = 1;
        }
    }
};

gameboard.prototype.getstatus = function(x,y)
{
    if(x >= 0 && x < 40 && y >= 0 && y < 36)
    {
        return this.squares[x][y] ;      
    }
    return 0;
};


gameboard.prototype.getneighborcount = function(x,y)
{
    var cnt = 0;
    
    cnt += this.getstatus(x-1,y-1);
    cnt += this.getstatus(x,y-1);
    cnt += this.getstatus(x+1,y-1);
    cnt += this.getstatus(x-1,y);
    cnt += this.getstatus(x+1,y);
    cnt += this.getstatus(x-1,y+1);
    cnt += this.getstatus(x,y+1);
    cnt += this.getstatus(x+1,y+1);

    return cnt;
};

gameboard.prototype.update = function()
{
    this.framenum = (this.framenum + 1) % 60;
    if(gamestate === 0 || this.framenum !== 0)
    {
        return;
    }
    
    for(var i = 0 ; i < 40 ; i++)
    {
        for(var j = 0 ; j < 36 ; j++)
        {
            this.nextsq[i][j] = 0;
        }
    }
    
    for(var i = 0  ; i < 40 ; i++)
    {
        for(var j = 0 ; j < 36; j++)
        {
            var cnt = this.getneighborcount(i,j);
            if(this.squares[i][j] === 1)
            {
                if(cnt < 2 || cnt > 3)
                {
                    this.nextsq[i][j] = 0;
                }
                else
                {
                    this.nextsq[i][j] = 1;
                }
            }
            else
            {
                if(cnt === 3)
                {
                    this.nextsq[i][j] = 1;
                }
            }
        }
    }
    
    for(var i = 0 ; i < 40 ; i++)
    {
        for(var j = 0 ; j < 36 ; j++)
        {
            this.squares[i][j] = this.nextsq[i][j];
        }
    }
    
    
    
    /*
    Any live cell with fewer than two live neighbors dies, as if by under population.
    Any live cell with two or three live neighbors lives on to the next generation.
    Any live cell with more than three live neighbors dies, as if by overpopulation.
    Any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction.
    */


};

gameboard.prototype.resetboard = function()
{
    for(var i = 0 ; i < 40 ; i++)
    {
        for(var j = 0 ; j < 36 ; j++)
        {
            this.squares[i][j] = 0;
        }
    }
};

gameboard.prototype.draw = function() {
    fill(255,255,255);
    for(var i = 0 ; i < 40 ; i++)
    {
        for(var j = 0 ; j < 36; j++)
        {
            stroke(240,240,240);
            if(this.squares[i][j] === 1)
            {
                fill(0,0,0);
            }
            else{
                fill(255,255,255);
            }
            rect(i*10,j*10,10,10);
        }
    }
    
    fill(0, 187, 255);
    rect(250,370,100,20,5);
    if(gamestate === 0)
    {
        textSize(18);
        fill(0,0,0);
        text("START",267,385);
    }
    else
    {
        textSize(18);
        fill(0,0,0);
        text("STOP",267,385);
    }
    fill(0,0,0);
    textSize(15);
    text("- Click on squares to fill them",10,380);
    text("- click START to see world evolve",10,395);
};

var gameboardObj = new gameboard();

mouseClicked = function()
{
    rect(150,370,100,20,5);

    if(mouseX > 250 && mouseX < 350 && mouseY > 370 && mouseY < 390)
    {
        gamestate = (gamestate + 1)%2;
        if(gamestate === 0)
        {
            gameboardObj.resetboard();
        }
    }
    gameboardObj.processmouseclick(mouseX,mouseY);
};

draw = function() {
    background(255,255,255);
    gameboardObj.draw();
    gameboardObj.update();
};
}};

import de.bezier.guido.*;
public int NUM_ROWS = 10;
public int NUM_COLS = 10;
public String levelN = "";

private boolean allowClick = true;
private boolean enterBool = false;
private boolean firstClick = true;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 450);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r ++){
        for(int c = 0; c < NUM_COLS; c ++){
            buttons[r][c] = new MSButton(r, c);
        }
    }

    for(int i = 0; i < (NUM_COLS*NUM_ROWS)/ 10; i++){
        setMines();
    }
}
public void setMines()
{
    int tempRow = (int)(Math.random()*NUM_ROWS);
    int tempCol = (int)(Math.random()*NUM_COLS);

    if(mines.contains(buttons[tempRow][tempCol]) == false){
        mines.add(buttons[tempRow][tempCol]);
    }
}

public void draw ()
{
    background( 0 );
    fill(255);
    textSize(25);
    text("Level: " + levelN, 200, 420);
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    for(int r = 0 ; r < buttons.length; r++){
        for(int c = 0; c < buttons[r].length; c++){
            if(!mines.contains(buttons[r][c]) && buttons[r][c].clicked == false){
                return false;
            }else if(mines.contains(buttons[r][c]) && buttons[r][c].flagged == false){
                return false;
            }
        }
    }
    return true;
}
public void displayLosingMessage()
{
    for(int r = 0; r < NUM_ROWS; r ++){
        for(int c = 0; c < NUM_COLS; c ++){
            buttons[r][c].setLabel("Lose");
            buttons[r][c].flagged = false;
            if(mines.contains(buttons[r][c])){
                buttons[r][c].clicked = true;
            }
        }
    }
    allowClick = false;
}
public void displayWinningMessage()
{
    for(int r = 0; r < NUM_ROWS; r ++){
        for(int c = 0; c < NUM_COLS; c ++){
            buttons[r][c].setLabel("Win");
            buttons[r][c].flagged = false;
            if(mines.contains(buttons[r][c])){
                buttons[r][c].clicked = true;
            }
        }
    }
    allowClick = false;
}
public boolean isValid(int r, int c)
{
    if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS){
        return true;
    }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;

    if(mines.contains(buttons[row][col])){
        numMines --;
    }

    for(int r = row-1; r <= row+1; r ++){
        for(int c = col-1; c <= col+1; c ++){
            if(isValid(r,c) && mines.contains(buttons[r][c])){
                numMines++;
            }
        }
    }

    return numMines;
}

public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        if(firstClick == true){
            firstClick = false;
            if(mines.contains(this)){
                setMines();
                mines.remove(buttons[myRow][myCol]);
            }
        }

        if(allowClick == false){
        }else if(clicked == false && mouseButton == RIGHT){
            flagged = !flagged;
            clicked = false;
        }else if(mines.contains(this)){
            clicked = true; 
            displayLosingMessage();
        }else if(countMines(myRow,myCol) > 0){
            clicked = true;
            setLabel(countMines(myRow,myCol));
        }else {
            clicked = true;
            for(int r = myRow-1; r <= myRow+1; r ++){
                for(int c = myCol-1; c <= myCol+1; c ++){
                    if(isValid(r,c) && buttons[r][c].clicked == false){
                        buttons[r][c].mousePressed();
                    }
                }
            }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        textSize(12);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}


public void keyPressed(){
    if(key >= '0' && key <= '9' && enterBool == false){
        levelN += key;
    }else if(key == '\n'){
        if(Integer.parseInt(levelN) >= 5 && Integer.parseInt(levelN) <= 20){
            NUM_ROWS = Integer.parseInt(levelN);
            NUM_COLS = Integer.parseInt(levelN);
        }
        levelN = "";
        background(0);
        

        buttons = new MSButton[NUM_ROWS][NUM_COLS];
        for(int r = 0; r < NUM_ROWS; r ++){
            for(int c = 0; c < NUM_COLS; c ++){
                buttons[r][c] = new MSButton(r, c);
            }
        }

        for(int i = 0; i < mines.size(); i++){
            mines.remove(i);
            i--;
        }

        for(int i = 0; i < (NUM_COLS*NUM_ROWS)/ 10; i++){
            setMines();
        }
    }
}
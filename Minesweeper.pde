import de.bezier.guido.*;
public int NUM_ROWS = 5;
public int NUM_COLS = 5;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < NUM_ROWS; i ++){
        for(int e = 0; e < NUM_COLS; e ++){
            buttons[i][e] = new MSButton(i, e);
        }
    }

    setMines();
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
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    //your code here
    return false;
}
public void displayLosingMessage()
{
    //your code here
}
public void displayWinningMessage()
{
    //your code here
}
public boolean isValid(int r, int c)
{
    if(r > 0 && r < NUM_ROWS && c > 0 && c < NUM_COLS){
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

    for(int i = row-1; i <= row+1; i ++){
        for(int e = col-1; e <= col+1; e ++){
                if(mines.contains(buttons[i][e])){
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
        clicked = true;
        if(mouseButton == RIGHT){
            flagged = !flagged;
            clicked = flagged;
        }else if(mines.contains(this)){
            displayLosingMessage();
        }else if(countMines(myRow,myCol) > 0){
            myLabel += countMines(myRow,myCol);
        }else {
            mousePressed();
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

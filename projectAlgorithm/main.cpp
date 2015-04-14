#include <iostream>
#include <stdlib.h>
int field[4][4];
static const int MAXROW = 4;
static const int MAXCOL = 4;
static const int MAXSIZE = 4;
static const int outside_field_right = 4;
static const int outside_field_left = -1;
bool hasMoved = false;
using namespace std;
void printField(){
    for(int row = 0; row < MAXROW; row++){
        for(int col = 0; col < MAXCOL; col++){
            cout << field[row][col] << ' ';
        }
        cout << endl;
    }
}
bool canMergeRight(int row, int current_col){

    //cout << "currentVal: " << currentVal << endl;
    for(int i = current_col; i < MAXCOL - 1; i++){
        int currentVal = field[row][current_col];
        int neighbourVal = field[row][current_col + 1];
        //Nästa granne till höger är 0
        if (field[row][current_col + 1] == 0){
            field[row][current_col] = 0;
            field[row][current_col + 1] = currentVal;
            //Vi fortsätter följa kolumnen åt höger
            current_col++;
        }
        else if(currentVal == neighbourVal){
            field[row][current_col] = 0;
            field[row][current_col + 1] += currentVal;
            return true;
        }
        else{
            return false;
        }
    }
}
void switchLeft(){

}

void switchRight(){
    //cout << "Switching field right..." << endl;
    for(int row = 0; row < MAXROW; row++){
        int current_col = MAXCOL -2;
        while(current_col != outside_field_left){
            int field_val = field[row][current_col];
            //cout << "field_val: " << field_val << endl;
            if (field_val == 0){
                if (current_col == 0){
                    break;
                }else{
                    current_col--;
                }
            }
            else if(canMergeRight(row, current_col)){
                hasMoved = true;
                current_col--;
            }else{
                current_col--;
            }
        }
    }
}

void randomInsertTwoOrFour() {
    int twoOrFourList[5] = {2,2,2,2,4};
    int randNum = rand() % 5;

    int randValue = twoOrFourList[randNum];
    cout << "randval" << randValue << endl;

    bool hasNotInserted = true;
    while(hasNotInserted) {
        int randCol = rand() % 3;
        int randRow = rand() % 3;

        if (field[randRow][randCol] == 0) {
            field[randRow][randCol] = randValue;
            hasNotInserted = false;
        }
    }
}

bool gameOver(){
    for (int row = 0; row < grid.numRows(); ++row) {
        for (int col = 0; col < grid.numCols(); ++col) {
            currentVal = field[row][col];

            // ej klar ^

            vector<int> xValues {col - 1,  col, col, col + 1};
            vector<int> yValues {row, row + 1, row - 1,row};

            int countAliveNeighbours = 0;
            // Count neighbours algorithm
            for (int i = 0; i < MAXSIZE; i++) {
                if (xValues[i] < MAXCOL && xValues[i] >= 0
                        && yValues[i] < MAXROW && yValues[i] >= 0) {
                    if (field[yValues[i]][xValues[i]] == 0
                            || currentVal == field[yValues[i]][xValues[i]]) {
                        countAliveNeighbours++;
                    }
                }
            }
        }
    }
}

int main()
{
    char dir = ' ';

    for(int row = 0; row < 4; row++){
        for(int col = 0; col < 4; col++){
            field[row][col] = 0;
        }
    }

    randomInsertTwoOrFour();
    randomInsertTwoOrFour();


    printField();
    cout << "Direction: ";
    cin >> dir;
    while(dir != 'q'){
        hasMoved = false;
        switch(dir){
        case 'l':
            switchLeft();
            break;
        case 'r':
            switchRight();
            break;
        default:
            break;
        }

        if (hasMoved) {
            randomInsertTwoOrFour();
        }
        if (gameOver()){
            break;
        }

        printField();
        cout << "Direction: ";
        cin >> dir;
    }
    return 0;
}


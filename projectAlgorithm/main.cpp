#include <iostream>
#include <stdlib.h>
#include <vector>

int field[4][4];
static const int MAXROW = 4;
static const int MAXCOL = 4;
static const int MAXSIZE = 4;
static const int outside_field_right = 4;
static const int outside_field_left = -1;
static const int outside_field_down = 4;
static const int outside_field_up = -1;
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

bool canMergeDown(int current_row, int col){

    //cout << "currentVal: " << currentVal << endl;
    for(int i = current_row; i < MAXROW - 1; i++){
        int currentVal = field[current_row][col];
        int neighbourVal = field[current_row+1][col];
        //Nästa granne till höger är 0
        if (field[current_row+1][col] == 0){
            field[current_row][col] = 0;
            field[current_row+1][col] = currentVal;
            //Vi fortsätter följa kolumnen åt höger
            current_row++;
        }
        else if(currentVal == neighbourVal){
            field[current_row][col] = 0;
            field[current_row+1][col] += currentVal;
            return true;
        }
        else{
            return false;
        }
    }
}

bool canMergeLeft(int row, int current_col){

    //cout << "currentVal: " << currentVal << endl;
    for(int i = current_col; i > 0; i--){
        int currentVal = field[row][current_col];
        int neighbourVal = field[row][current_col - 1];
        //Nästa granne till höger är 0
        if (field[row][current_col - 1] == 0){
            field[row][current_col] = 0;
            field[row][current_col - 1] = currentVal;
            //Vi fortsätter följa kolumnen åt höger
            current_col--;
        }
        else if(currentVal == neighbourVal){
            field[row][current_col] = 0;
            field[row][current_col - 1] += currentVal;
            return true;
        }
        else{
            return false;
        }
    }
}

bool canMergeUp(int current_row, int col){

    //cout << "currentVal: " << currentVal << endl;
    for(int i = current_row; i > 0; i--){
        int currentVal = field[current_row][col];
        int neighbourVal = field[current_row-1][col];
        //Nästa granne till höger är 0
        if (field[current_row-1][col] == 0){
            field[current_row][col] = 0;
            field[current_row-1][col] = currentVal;
            //Vi fortsätter följa kolumnen åt höger
            current_row--;
        }
        else if(currentVal == neighbourVal){
            field[current_row][col] = 0;
            field[current_row-1][col] += currentVal;
            return true;
        }
        else{
            return false;
        }
    }
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

void switchDown() {
    //cout << "Switching field right..." << endl;
    for(int col = 0; col < MAXCOL; col++){
        int current_row = MAXROW -2;
        while(current_row != outside_field_up){
            int field_val = field[current_row][col];
            //cout << "field_val: " << field_val << endl;
            if (field_val == 0){
                if (current_row == 0){
                    break;
                }else{
                    current_row--;
                }
            }
            else if(canMergeDown(current_row,col)){
                hasMoved = true;
                current_row--;
            }else{
                current_row--;
            }
        }
    }
}

void switchLeft() {
    //cout << "Switching field right..." << endl;
    for(int row = 0; row < MAXROW; row++){
        int current_col = 1;
        while(current_col != outside_field_right){
            int field_val = field[row][current_col];
            //cout << "field_val: " << field_val << endl;
            if (field_val == 0){
                if (current_col == 3){
                    break;
                }else{
                    current_col++;
                }
            }
            else if(canMergeLeft(row, current_col)){
                hasMoved = true;
                current_col++;
            }else{
                current_col++;
            }
        }
    }
}

void switchUp() {
    //cout << "Switching field right..." << endl;
    for(int col = 0; col < MAXCOL; col++){
        int current_row = 1;
        while(current_row != outside_field_down){
            int field_val = field[current_row][col];
            //cout << "field_val: " << field_val << endl;
            if (field_val == 0){
                if (current_row == 3){
                    break;
                }else{
                    current_row++;
                }
            }
            else if(canMergeUp(current_row,col)){
                hasMoved = true;
                current_row++;
            }else{
                current_row++;
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
        int randCol = rand() % 4;
        int randRow = rand() % 4;

        if (field[randRow][randCol] == 0) {
            field[randRow][randCol] = randValue;
            hasNotInserted = false;
        }
    }
}

bool gameOver(){
    for (int row = 0; row < MAXROW; ++row) {
        for (int col = 0; col < MAXCOL; ++col) {
            int currentVal = field[row][col];

            vector<int> colValues {col - 1, /*col, col,*/ col + 1};
            vector<int> rowValues {row    , /*row + 1 , row - 1,*/ row    };

            // Count neighbours algorithm
            // should be MAXSIZE, but is MAXSIZE 2 due to no up, won movement.
            for (int i = 0; i < MAXSIZE-2; i++) {
                if (colValues[i] < MAXCOL && colValues[i] >= 0
                        && rowValues[i] < MAXROW && rowValues[i] >= 0) {
                    if (field[rowValues[i]][colValues[i]] == 0
                            || currentVal == field[rowValues[i]][colValues[i]]) {
                        cout << currentVal << endl;
                        cout << row << endl;
                        cout << col << endl;
                        return true;

                    }
                }
            }
        }
    }
    cout << "nooo" << endl;
    return false;

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
        case 'u':
            switchUp();
            break;
        case 'd':
            switchDown();
            break;
        default:
            break;
        }

        if (hasMoved) {
            randomInsertTwoOrFour();
        }

        if (!gameOver()){
            cout<<"gg"<<endl;
            break;
        }


        printField();
        cout << "Direction: ";
        cin >> dir;
    }
    return 0;
}

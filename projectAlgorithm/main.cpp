#include <iostream>
int field[4][4];
static const int MAXROW = 4;
static const int MAXCOL = 4;
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
    int currentVal = field[row][current_col];
    for(int i = current_col; i < MAXCOL; i++){
        //Nästa granne till höger är 0
        if (field[row][current_col + i] == 0){
            field[row][current_col] = 0;
            field[row][current_col] = currentVal;
            //Vi fortsätter följa kolumnen åt höger
            current_col++;
        }
        else if(currentVal == field[row][current_col + i]){
            field[row][current_col] = 0;
            field[row][current_col] += currentVal;
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
    cout << "Switching field right..." << endl;
    for(int row = 0; row < MAXROW; row++){
        int current_col = MAXCOL -2;
        while(current_col != outside_field_left){
            int field_val = field[row][current_col];
            if (field_val == 0){
                if (current_col == 0){
                    current_col = outside_field_left;
                }else{
                    current_col--;
                }
            }
            else if(canMergeRight(row, current_col)){
                hasMoved = true;
            }
            current_col--;
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

    field[0][0] = 2;
    field[0][2] = 2;

    printField();
    cout << "Direction: ";
    cin >> dir;
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

    printField();
    return 0;
}


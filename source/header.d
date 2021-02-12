module headerModule;

import button;
import raylib;

class header : button{
	int seconds;
	this(int x, int y, int size){
		super(x, y, size);
	}
}
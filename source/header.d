module headerModule;

import raylib;

class header{
	Rectangle faceRec, innerRec, mDownRec;
	int seconds, borderSize;
	this(int xCoord, int yCoord, int size){
		borderSize = size / 6;
		faceRec = Rectangle(xCoord, yCoord, size, size);
		innerRec = Rectangle(xCoord + borderSize, yCoord + borderSize, size - (borderSize * 2), size - (borderSize * 2));
		
		mDownRec = faceRec;
		int tmp = size / 12;
		mDownRec.x += tmp;
		mDownRec.y += tmp;
		mDownRec.w -= tmp * 2;
		mDownRec.h -= tmp * 2;
	}
	
	void draw(){
		if(IsMouseButtonDown(MouseButton.MOUSE_LEFT_BUTTON) && CheckCollisionPointRec(GetMousePosition(), faceRec)){
			drawMouseDown();
		}
		else{
			drawNeutral();
		}
	}
	
	void drawNeutral(){
		DrawRectangleRec(faceRec, Colors.LIGHTGRAY);
		DrawRectangleRec(innerRec, Colors.GRAY);
		
		DrawTriangle(
			Vector2(faceRec.x, faceRec.y + faceRec.h),
			Vector2(faceRec.x + borderSize, faceRec.y + faceRec.h),
			Vector2(faceRec.x + borderSize, faceRec.y + (faceRec.h - borderSize)),
			Colors.DARKGRAY
		);
		DrawTriangle(
			Vector2(faceRec.x + faceRec.w, faceRec.y),
			Vector2(faceRec.x + (faceRec.w - borderSize), faceRec.y + borderSize),
			Vector2(faceRec.x + faceRec.w, faceRec.y + borderSize),
			Colors.DARKGRAY
		);
		
		DrawRectangleV(
			Vector2(faceRec.x + borderSize, faceRec.y + (faceRec.h - borderSize)),
			Vector2(faceRec.w - borderSize, borderSize),
			Colors.DARKGRAY
		);
		DrawRectangleV(
			Vector2(faceRec.x + (faceRec.w - borderSize),faceRec.y + borderSize),
			Vector2(borderSize, faceRec.h - borderSize),
			Colors.DARKGRAY
		);
	}
	
	void drawMouseDown(){
		DrawRectangleRec(faceRec, Colors.DARKGRAY);
		DrawRectangleRec(mDownRec, Colors.GRAY);
	}
}
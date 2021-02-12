module button;

import raylib;

class button{
	
	@property Rectangle asRectangle() { return outRec; }
	@property float x() { return outRec.x; }
	@property float y() { return outRec.y; }
	@property float w() { return outRec.w; }
	@property float h() { return outRec.h; }
	
	@property float innerX() { return inRec.x; }
	@property float innerY() { return inRec.y; }
	
	int size, borderSize;
	Rectangle outRec, midRec, inRec;
	
	this(int x, int y, int size){
		this.size = size;
		borderSize = size / 6;
		
		outRec = Rectangle(x, y, size, size);
		
		inRec = outRec;
		inRec.x += borderSize;
		inRec.y += borderSize;
		inRec.w -= borderSize * 2;
		inRec.h -= borderSize * 2;
		
		midRec = outRec;
		midRec.x += borderSize / 2;
		midRec.y += borderSize / 2;
		midRec.w -= borderSize;
		midRec.h -= borderSize;
	}
	
	void draw(){
		if(IsMouseButtonDown(MouseButton.MOUSE_LEFT_BUTTON) && CheckCollisionPointRec(GetMousePosition(), outRec)){
			drawPressed();
		}
		else{
			drawNeutral();
		}
	}
	
	void drawNeutral(){
		DrawRectangleRec(outRec, Colors.LIGHTGRAY);
		DrawRectangleRec(inRec, Colors.GRAY);
		
		DrawTriangle(
			Vector2(outRec.x, outRec.y + outRec.h),
			Vector2(outRec.x + borderSize, outRec.y + outRec.h),
			Vector2(outRec.x + borderSize, outRec.y + (outRec.h - borderSize)),
			Colors.DARKGRAY
		);
		DrawTriangle(
			Vector2(outRec.x + outRec.w, outRec.y),
			Vector2(outRec.x + (outRec.w - borderSize), outRec.y + borderSize),
			Vector2(outRec.x + outRec.w, outRec.y + borderSize),
			Colors.DARKGRAY
		);
		
		DrawRectangleV(
			Vector2(outRec.x + borderSize, outRec.y + (outRec.h - borderSize)),
			Vector2(outRec.w - borderSize, borderSize),
			Colors.DARKGRAY
		);
		DrawRectangleV(
			Vector2(outRec.x + (outRec.w - borderSize),outRec.y + borderSize),
			Vector2(borderSize, outRec.h - borderSize),
			Colors.DARKGRAY
		);
	}
	
	void drawPressed(){
		DrawRectangleRec(outRec, Colors.DARKGRAY);
		DrawRectangleRec(midRec, Colors.GRAY);
	}
	
	void drawPressed(Color c1, Color c2){
		DrawRectangleRec(outRec, c1);
		DrawRectangleRec(midRec, c2);
	}
}
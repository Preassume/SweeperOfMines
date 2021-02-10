module tileModule;

import raylib;
import std.stdio;
import std.conv;

struct Triangle{
	Vector2 p1;
	Vector2 p2;
	Vector2 p3;
};

struct Circle{
	int xCenter;
	int yCenter;
	float radius;
};

struct Ring{
	Vector2 center;
	float inRadius;
	float outRadius;
	int startAngle;
	int endAngle;
	int segments;
};

class tile{
private:
	Triangle t1, t2;
	
public:
	int type = 0;
	int size = 50;
	int flagged = 0;
	bool covered = true;
	bool showBombs = false;
	bool mouseDown = false;
	float borderSize;
	Rectangle tileRec;
	Rectangle inRecCovered;
	Rectangle inRecUncovered;

	this(Vector2 Pos, int size){
		this.size = size;
		borderSize = size / 6;
		tileRec = raylib.Rectangle(Pos.x, Pos.y, size, size);
		inRecCovered = tileRec;
		inRecCovered.x += borderSize;
		inRecCovered.y += borderSize;
		inRecCovered.w -= borderSize * 2;
		inRecCovered.h -= borderSize * 2;
		
		inRecUncovered = tileRec;
		int tmp = size / 12;
		inRecUncovered.x += tmp;
		inRecUncovered.y += tmp;
		inRecUncovered.w -= tmp * 2;
		inRecUncovered.h -= tmp * 2;
		
		
		t1 = Triangle(
			Vector2(tileRec.x, tileRec.y + tileRec.h),
			Vector2(tileRec.x + borderSize, tileRec.y + tileRec.h),
			Vector2(tileRec.x + borderSize, tileRec.y + (tileRec.h - borderSize))
		);
		t2 = Triangle(
			Vector2(tileRec.x + tileRec.w, tileRec.y),
			Vector2(tileRec.x + (tileRec.w - borderSize), tileRec.y + borderSize),
			Vector2(tileRec.x + tileRec.w, tileRec.y + borderSize)
		);
	}

	void uncover(){
		if(flagged == 0){
			covered = false;
		}
	}
	
	void flag(){
		if(!covered) return;
		
		if(flagged == 0) flagged = 1;
		else if(flagged == 1) flagged = 2;
		else flagged = 0;
	}
	
	void draw(){
		if(!showBombs){
			if(covered){
				if(IsMouseButtonDown(MouseButton.MOUSE_LEFT_BUTTON) && flagged == 0 && CheckCollisionPointRec(GetMousePosition(), tileRec)){
					drawMouseDown();
				}
				else{
					drawCovered();
				}
			}
			else{
				drawUncovered();
			}
		}
		else{
			if(type == -1){
				drawShowBombs();
			}
			else{
				if(covered){
					drawCovered();
				}
				else{
					drawUncovered();
				}
			}
		}
	}
private:
	
	void drawCovered(){
		//if(IsMouseButtonDown(MouseButton.MOUSE_LEFT_BUTTON) && CheckCollisionPointRec(GetMousePosition, tileRec)){
		if(mouseDown && flagged == 0){
			drawMouseDown();
		}
		else{
			DrawRectangleRec(tileRec, Colors.LIGHTGRAY);
			DrawRectangleRec(inRecCovered, Colors.GRAY);
			DrawRectangleV(t1.p3, Vector2(tileRec.w - borderSize, borderSize), Colors.DARKGRAY);
			DrawRectangleV(t2.p2, Vector2(borderSize, tileRec.h - borderSize), Colors.DARKGRAY);
			
			DrawTriangle(t1.p1, t1.p2, t1.p3, Colors.DARKGRAY);
			DrawTriangle(t2.p1, t2.p2, t2.p3, Colors.DARKGRAY);
			
			if(flagged == 1){
				int recSize = size / 8;
				DrawRectangle(
					cast(int)(tileRec.x + tileRec.w / 2 - recSize), cast(int)(tileRec.y + borderSize),
					recSize, cast(int)(tileRec.h - borderSize * 2), Colors.BLACK
				);
				DrawTriangle(
					Vector2(tileRec.x + tileRec.w / 2, tileRec.y + borderSize),
					Vector2(tileRec.x + tileRec.w / 2, tileRec.y + borderSize * 3),
					Vector2(tileRec.x + tileRec.w / 2 + borderSize * 1.5, tileRec.y + borderSize * 2),
					Colors.MAROON
				);
			}
			else if(flagged == 2){
				DrawText("?", cast(int)(inRecCovered.x + borderSize / 2), cast(int)(inRecCovered.y), cast(int)(size / 1.2), Colors.BLACK);
			}
		}
	}
	
	void drawUncovered(){
		if(type != -1){
			DrawRectangleRec(tileRec, Colors.DARKGRAY);
			DrawRectangleRec(inRecUncovered, Colors.GRAY);
			if(type > 0){
				Color numColor;
				switch(type){
					case 1: numColor = Colors.DARKBLUE; break;
					case 2: numColor = Colors.DARKGREEN; break;
					case 3: numColor = Colors.MAROON; break;
					case 4: numColor = Colors.DARKPURPLE; break;
					case 5: numColor = Colors.ORANGE; break;
					case 6: numColor = Colors.PINK; break;
					case 7: numColor = Colors.SKYBLUE; break;
					default: numColor = Colors.BLACK; break;
				}
				char num = to!char(type);
				char* ptr = &num;
				DrawText(ptr, cast(int)(inRecCovered.x + borderSize / 2), cast(int)(inRecCovered.y), cast(int)(size / 1.2), numColor);
			}
		}
		else{
			DrawRectangleRec(tileRec, Colors.MAROON);
			DrawRectangleRec(inRecUncovered, Colors.RED);
			drawBomb();
		}
		
	}
	
	void drawMouseDown(){
		DrawRectangleRec(tileRec, Colors.DARKGRAY);
		DrawRectangleRec(inRecUncovered, Colors.GRAY);
	}
	
	void drawShowBombs(){
		DrawRectangleRec(tileRec, Colors.DARKGRAY);
		DrawRectangleRec(inRecUncovered, Colors.GRAY);
		drawBomb();
	}
	
	void drawBomb(){
		int recSize = size / 6;
		float strSize = recSize / 2.4;
		DrawRectangle(
			cast(int)(tileRec.x + (tileRec.w / 2) - (strSize / 2)),
			cast(int)(tileRec.y + (tileRec.h / 2.8) - (recSize * 1.2)),
			cast(int)(strSize), cast(int)(strSize * 2), Colors.BLACK
		);
		recSize += 2;
		DrawRectangle(
			cast(int)(tileRec.x + (tileRec.w / 2) - (recSize / 2)),
			cast(int)(tileRec.y + (tileRec.h / 2.8) - (recSize / 2)),
			cast(int)(recSize), cast(int)(recSize), Colors.BLACK
		);
		recSize -= 2;
		DrawRectangle(
			cast(int)(tileRec.x + (tileRec.w / 2) - (recSize / 2)),
			cast(int)(tileRec.y + (tileRec.h / 2.8) - (recSize / 2)),
			cast(int)(recSize), cast(int)(recSize), Colors.LIGHTGRAY
		);
		
		DrawCircle(
			cast(int)(tileRec.x + (tileRec.w / 2)),
			cast(int)(tileRec.y + (tileRec.h / 2) + (borderSize / 2)),
			size / 4,
			Colors.BLACK
		);
		DrawCircle(
			cast(int)(tileRec.x + (tileRec.w / 2) - (tileRec.w / 12)),
			cast(int)(tileRec.y + (tileRec.h / 2) + (borderSize / 2) - (tileRec.h / 12)),
			size / 16,
			Colors.WHITE
		);
	}
};

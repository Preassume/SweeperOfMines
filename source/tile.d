module tileModule;

import raylib;
import button;
import std.stdio;
import std.conv;
import std.string;

class tile : button{
	int type = 0;
	int flagged = 0;
	bool covered = true;
	bool showBombs = false;
	
	this(int x, int y, int size){
		super(x, y, size);
	}
	
	void reset(){
		type = 0;
		flagged = 0;
		covered = true;
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
	
	override void draw(){
		if(covered){
			super.draw();
		}
		else{
			drawPressed();
		}
	}
	
	override void drawNeutral(){
		super.drawNeutral();
		
		if(flagged == 1){
			int recSize = size / 8;
			DrawRectangle(
				cast(int)(super.x +  super.w / 2 - recSize), cast(int)(super.y + super.borderSize),
				recSize, cast(int)( super.h - super.borderSize * 2), Colors.BLACK
			);
			DrawTriangle(
				Vector2(super.x + super.w / 2, super.y + super.borderSize),
				Vector2(super.x + super.w / 2, super.y + super.borderSize * 3),
				Vector2(super.x + super.w / 2 + super.borderSize * 1.5, super.y + super.borderSize * 2),
				Colors.MAROON
			);
		}
		else if(flagged == 2){
			DrawText("?", cast(int)(super.innerX + super.borderSize / 2), cast(int)(super.innerY), cast(int)(size / 1.2), Colors.BLACK);
		}
	}
	
	override void drawPressed(){
		if(covered){
			super.drawPressed();
		}
		else{
			if(type != -1){
				super.drawPressed();
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
					string num = to!string(type);
					DrawText(toStringz(num), cast(int)(super.innerX + super.borderSize / 2), cast(int)(super.innerY), cast(int)(size / 1.2), numColor);
				}
			}
			else{
				super.drawPressed(Colors.MAROON, Colors.RED);
				drawBomb();
			}
		}
	}
	
	void drawShowBombs(){
		super.drawPressed();
		drawBomb();
	}
	
	void drawBomb(){
		int recSize = size / 6;
		float strSize = recSize / 2.4;
		DrawRectangle(
			cast(int)(super.x + (super.w / 2) - (strSize / 2)),
			cast(int)(super.y + (super.h / 2.8) - (recSize * 1.2)),
			cast(int)(strSize), cast(int)(strSize * 2), Colors.BLACK
		);
		recSize += 2;
		DrawRectangle(
			cast(int)(super.x + (super.w / 2) - (recSize / 2)),
			cast(int)(super.y + (super.h / 2.8) - (recSize / 2)),
			cast(int)(recSize), cast(int)(recSize), Colors.BLACK
		);
		recSize -= 2;
		DrawRectangle(
			cast(int)(super.x + (super.w / 2) - (recSize / 2)),
			cast(int)(super.y + (super.h / 2.8) - (recSize / 2)),
			cast(int)(recSize), cast(int)(recSize), Colors.LIGHTGRAY
		);
		
		DrawCircle(
			cast(int)(super.x + (super.w / 2)),
			cast(int)(super.y + (super.h / 2) + (borderSize / 2)),
			size / 4,
			Colors.BLACK
		);
		DrawCircle(
			cast(int)(super.x + (super.w / 2) - (super.w / 12)),
			cast(int)(super.y + (super.h / 2) + (borderSize / 2) - (super.h / 12)),
			size / 16,
			Colors.WHITE
		);
	}
}
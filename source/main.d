import std.stdio;
import std.random;
import std.conv;
import raylib;
import tileModule;
import sweepModule;

void main()
{
	sweep sw1 = new sweep(32, 16, 40, 80);
	
	InitWindow(1280, 720, "DEE   SWEEP");
	
	while (!WindowShouldClose())
	{
		BeginDrawing();
		ClearBackground(Colors.GRAY);
		sw1.draw();
		EndDrawing();
	}
	CloseWindow();
}

import std.stdio;
import std.random;
import std.conv;
import raylib;
import tileModule;
import sweepModule;

void main()
{
	sweep sw1 = new sweep(32, 18, 60);
	
	InitWindow(1920, 1080, "DEE   SWEEP");
	
	while (!WindowShouldClose())
	{
		BeginDrawing();
		ClearBackground(Colors.BLACK);
		sw1.draw();
		EndDrawing();
	}
	CloseWindow();
}

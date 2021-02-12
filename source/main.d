import std.stdio;
import std.random;
import std.conv;
import raylib;
import tileModule;
import sweepModule;
import button;

void main()
{
	sweep sw1 = new sweep(32, 16, 40, 80);
	 tile b1 = new  tile(10, 10, 15);
	 tile b2 = new  tile(35, 10, 30);
	 tile b3 = new  tile(75, 10, 45);
	 tile b4 = new  tile(130, 10, 60);
	
	InitWindow(1280, 720, "DEE   SWEEP");
	
	while (!WindowShouldClose())
	{
		BeginDrawing();
		ClearBackground(Colors.GRAY);
		sw1.draw();
		b1.draw();
		b2.draw();
		b3.draw();
		b4.draw();
		EndDrawing();
	}
	CloseWindow();
}

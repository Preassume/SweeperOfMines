module sweepModule;
import tileModule;
import std.stdio;
import raylib;
import std.random;

class sweep{
public:
	tile[][] board;
	bool gameStarted = false;
	int width, height, tileSize, numBombs, headerHeight;
	
	this(int width, int height, int tileSize, int headerHeight){
		this.width = width;
		this.height = height;
		this.tileSize = tileSize;
		this.headerHeight = headerHeight;
		
		numBombs = cast(int)(width * height * 0.12);
		
		board = new tile[][](width, height);
        foreach(y; 0 .. height){
            foreach(x; 0 .. width){
                board[x][y] = new tile(Vector2(x * tileSize, y * tileSize + headerHeight), tileSize);
            }
        }
	}
	/*
	void populate2(int iX, int iY){
		auto rnd = Random(42);
		int x, y;
		int count = 0;
		while(count < numBombs){
			x = uniform!"[)"(0, width, rnd);
			y = uniform!"[)"(0, height, rnd);
			if(board[x][y].type != -1 && x != iX && y != iY){
				board[x][y].type = -1;
				count++;
				
				for(int i = -1; i <= 1; i++){
					for(int j = -1; j <= 1; j++){
						if(x+i >= 0 && y+j >= 0 && x+i < width && y+j < height){
							if(board[x+i][y+j].type >= 0){
								board[x+i][y+j].type++;
							}
						}
					}
				}
			}
		}
	}*/
	
	
	void increment(int x, int y){
		foreach(i; -1 .. 2){
			foreach(j; -1 .. 2){
				if(x + i >= 0 && y + j >= 0 && x + i < width && y + j < height){
					if(board[x+i][y+j].type >= 0){
						board[x+i][y+j].type++;
					}
				}
			}
		}
	}
	
	void populate(int xInit, int yInit){
		auto rnd = Random(42);
		int x, y;
		int bombsGend = 0;
		while(bombsGend <= numBombs){
			x = uniform!"[)"(0, width, rnd);
			y = uniform!"[)"(0, height, rnd);
			writeln(x, ' ', y);
			if(x != xInit && y != yInit && board[x][y].type != -1){
				board[x][y].type = -1;
				increment(x, y);
				bombsGend++;
			}
		}
	}
	
	void mouse(){
		if(IsMouseButtonReleased(MouseButton.MOUSE_LEFT_BUTTON)){
			int x = cast(int)(GetMousePosition().x) / tileSize;
			int y = cast(int)(GetMousePosition().y - headerHeight) / tileSize;
			writeln("uncover ", x, ' ', y);
			
			uncover(x, y);
		}
		if(IsMouseButtonReleased(MouseButton.MOUSE_RIGHT_BUTTON)){
			int x = cast(int)(GetMousePosition().x) / tileSize;
			int y = cast(int)(GetMousePosition().y - headerHeight) / tileSize;
			writeln("flag ", x, ' ', y);
			
			board[x][y].flag();
		}
	}
	
	bool uncover(int x, int y){
		if(!gameStarted){
			gameStarted = true;
			populate(x, y);
		}
		bool alive = true;
        if(board[x][y].type == -1){
			board[x][y].uncover();
            alive = false;
        }
        else if(board[x][y].type == 0){
			uncoverAux(x, y);
		}
		else if(board[x][y].type > 0){
			board[x][y].uncover();
		}
        return alive;
    }
    
    void uncoverAux(int x, int y){
		if(x >= 0 && x < width && y >= 0 && y < height && board[x][y].type >= 0 && board[x][y].covered == true){
			board[x][y].uncover;
			if(board[x][y].type == 0){
				foreach(i; -1 .. 2){
					foreach(j; -1 .. 2){
						if(i != 0 || j != 0){
							uncoverAux(x+i, y+j);
						}
					}
				}
			}
		}
		else{
			return;
		}
	}
	
	void draw(){
		mouse();
		foreach(y; 0 .. height){
            foreach(x; 0 .. width){
                board[x][y].draw();
            }
        }
	}
};
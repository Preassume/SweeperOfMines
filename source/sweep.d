module sweepModule;
import tileModule;
import headerModule;
import std.stdio;
import raylib;
import std.random;
import std.datetime.systime;

//TODO: make button class for tile and the header's button to inherit from


class sweep{
public:
	tile[][] board;
	header topHeader;
	bool gameStarted = false;
	bool dead = false;
	int width, height, tileSize, headerHeight;
	int numBombs;
	int numFlagged = 0;
	
	this(int width, int height, int tileSize, int headerHeight){
		this.width = width;
		this.height = height;
		this.tileSize = tileSize;
		this.headerHeight = headerHeight;
		
		numBombs = cast(int)(width * height * 0.12);
		//bombsLeft = numBombs;
		
		int faceButtonSize = headerHeight - (headerHeight / 5);
		topHeader = new header((width * tileSize) / 2 - faceButtonSize / 2 , headerHeight / 10, faceButtonSize);
		
		board = new tile[][](width, height);
        foreach(y; 0 .. height){
            foreach(x; 0 .. width){
                board[x][y] = new tile(Vector2(x * tileSize, y * tileSize + headerHeight), tileSize);
            }
        }
	}
	
	void resetGame(){
		foreach(y; 0 .. height){
            foreach(x; 0 .. width){
                board[x][y].reset();
            }
        }
		dead = false;
		gameStarted = false;
		numFlagged = 0;
	}
	
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
		auto date = Clock.currTime();
		int seed = date.second * date.hour * date.day;
		auto rnd = Random(seed);
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
			int x = cast(int)(GetMousePosition().x);
			int y = cast(int)(GetMousePosition().y);
			writeln("lmb ", x, ' ', y);
			
			if(y <= headerHeight){
				if(CheckCollisionPointRec(GetMousePosition(), topHeader.faceRec)){
					resetGame();
				}
			}
			else{
				if(dead) return;
				y -= headerHeight;
				x /= tileSize;
				y /= tileSize;
				if(x >= 0 && y >= 0 && x < width && y < height){
					if(!uncover(x, y)) dead = true;
				}
			}
		}
		if(IsMouseButtonReleased(MouseButton.MOUSE_RIGHT_BUTTON)){
			if(dead) return;
			int x = cast(int)(GetMousePosition().x) / tileSize;
			int y = cast(int)(GetMousePosition().y - headerHeight) / tileSize;
			writeln("rmb ", x, ' ', y);
			
			if(x >= 0 && y >= 0 && x < width && y < height){
				board[x][y].flag();
			}
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
				board[x][y].showBombs = dead;
            }
        }
		topHeader.draw();
	}
};
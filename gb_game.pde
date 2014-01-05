Buster gB;
Controller gameController = new Controller();
Ghost [] ghost_ = new Ghost[1];
String difficulty = "hard"; // testing, easy, hard
int level = 1;

void setup() {
	smooth();
	frameRate(60);
	size(500, 500);
	gB = new Buster();
			for(int i = 0; i < ghost_.length; i++) {
		ghost_[i] = new Ghost();
	}
}

void draw() {
	int deathToll = 0;
	background(255);

	gB.findTarget();	
	gB.move();
	gB.beam();
	gB.display();
	
	for(int i = 0; i < ghost_.length; i++) {
		if(ghost_[i].dead) {
			ghost_[i].kill();
			deathToll += 1;
		}
		else {
			ghost_[i].display();
			ghost_[i].updateSpawn();
			ghost_[i].spawnOoze();
			ghost_[i].updateOoze();
			ghost_[i].move();
			ghost_[i].freakout();
			ghost_[i].mouseCheck();
			ghost_[i].updateCounter();
			ghost_[i].deathWatch();
		}
	}
	if(deathToll == 3) {
		textSize(20);
		textAlign(CENTER, CENTER);
		text("VICTORY!", width/2, height/2);
		//println("You won!");
	}
}

void keyPressed() {
    gameController.handleKeyPress();
}
void keyReleased() {
    gameController.handleKeyReleased();
}
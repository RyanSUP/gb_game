Buster gB;
Controller gameController = new Controller();
Ghost [] ghost_ = new Ghost[1];
String difficulty = "testing"; // testing, easy, hard
int level = 1;

void setup() {
	smooth();
	frameRate(60);
	size(500, 500);
	startLevel(level);
}

void draw() {
	//frameRate(10);
	int deathToll = 0;
	background(255);

	if (gB.alive) {

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

		healthBar();

		// If all enemies got killed
		if(deathToll == ghost_.length) {
			startLevel(level+1);
			textSize(50);
			textAlign(CENTER, CENTER);
			text("LEVEL "+level, width/2, height/2);
		}

	}
	else {
		textSize(50);
		textAlign(CENTER, CENTER);
		text("DEFEAT!", width/2, height/2);
	}
}

void keyPressed() {
    gameController.handleKeyPress();
}

void keyReleased() {
    gameController.handleKeyReleased();
}

void startLevel(int levelNumber) {

	level = levelNumber;
	gB = new Buster();

	if (levelNumber == 1) {
		ghost_ = new Ghost[1];
	}
	else if (levelNumber >= 2) {
		ghost_ = new Ghost[2];
	}

	for(int i = 0; i < ghost_.length; i++) {
		ghost_[i] = new Ghost();
	}

}

void healthBar() {
	fill(100, 255, 100);
	noStroke();
	rect(0, 0, gB.health * 20, 20);
	//println(gB.health);
}
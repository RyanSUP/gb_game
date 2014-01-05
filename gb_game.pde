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
		if(deathToll == ghost_.length) {
			textSize(50);
			textAlign(CENTER, CENTER);
			text("VICTORY!", width/2, height/2);
			//println("You won!");
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
void healthBar() {
	fill(100, 255, 100);
	noStroke();
	rect(0, 0, gB.health * 20, 20);
	//println(gB.health);
}
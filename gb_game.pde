Buster gB;
int ghostCount = 0; // how many ghosts are on screen
Controller gameController = new Controller();
Ghost [] ghost_ = new Ghost[1];
BluePower shield;
int shieldStr = 0; // strength of shield
String difficulty = "testing"; // testing, easy, hard
int level = 1;
boolean blueSpawn = false;
float powerNumber;
void setup() {
	smooth();
	frameRate(60);
	size(500, 500);
	startLevel(level);
	gB = new Buster();
}

void draw() {
	//frameRate(10);
	println(ghostCount);
	int deathToll = 0;
	background(255);

	if (gB.alive) {

		gB.findTarget();	
		gB.move();
		gB.beam();
		gB.display();

		for(int i = 0; i < ghost_.length; i++) {
			if(ghost_[i].dead) {
				ghost_[i].updateOoze();
				ghost_[i].updateDeathOoze();
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
		levelCount();
		healthBar();
		shieldBar();
		CheckSpawnPower();
		SpawnBluePower();
		movePower();		
		// If all enemies got killed
		if(deathToll == ghost_.length) {
			startLevel(level+1);
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
	
	if (levelNumber == 1) {
		ghostCount = 1;
		ghost_ = new Ghost[1];
	}
	else if (levelNumber >= 2) {
		ghostCount = level + 1;
		ghost_ = new Ghost[level + 1];
	}

	for(int i = 0; i < ghost_.length; i++) {
		ghost_[i] = new Ghost();
	}

}

void healthBar() {
	//background bar
	fill(100, 255, 100);
	noStroke();
	rect(0, 0, gB.health * 20, 20);
	noFill();
	strokeWeight(2);
	stroke(0);
	rect(-2, -2, 200, 20);
	//println(gB.health);
}
void shieldBar() {
	fill(100,100,255, 130);
	noStroke();
	rect(0,0, shieldStr * 20, 17);
}
void levelCount() {
	fill(0);
	textSize(20);
	textAlign(CENTER, CENTER);
	text("LEVEL "+level, width - 50, 10);
}
void CheckSpawnPower() {
	powerNumber = random(300);
	if(ghostCount >= powerNumber) {
		blueSpawn = true;
	}
	else {
		blueSpawn = false;
	}
}
void SpawnBluePower() {
	if(blueSpawn && shield == null){
		shield = new BluePower();
	}
}
void movePower(){
		if(shield != null) {
		// if the ooze fell past the ground get rid of it so we can make a new one
		if (shield.y > height) {
			shield = null;
		}
		else if(shield.checkForBuster()) {
			if(shieldStr < gB.health) {
				shieldStr = shieldStr + 1;
			}
			else {
				shieldStr = shieldStr;
			}
			shield = null;
		}
		// if the ooze didn't fall to the ground yet then update it
		else {
			shield.move();
			shield.display();
		}
	}
}
import ddf.minim.*;

Minim minim;
AudioSample [] oozeSfxDropOoze = new AudioSample[3];
AudioSample oozeSfxDeath;
AudioSample [] busterSfxHit = new AudioSample[2];
AudioSample busterSfxShield;
AudioSample busterSfxDeath;
boolean sfx;

PImage oozeImg;
PImage busterGuy;
PImage backgroundScene;
PImage ghostImg;
PImage shieldImg;

Buster gB;
int ghostCount = 0; // how many ghosts are on screen
Controller gameController = new Controller();
Ghost [] ghost_ = new Ghost[1];
BluePower shield;
int shieldStr = 0; // strength of shield
String difficulty = "easy"; // testing, easy, hard
int level = 1;
boolean stunReady = false;
StunBeam stunPower;
boolean blueSpawn = false;
float powerNumber;
void setup() {
	smooth();
	frameRate(60);
	size(500, 500);
	frame.setTitle("GHOST BUSTER");
	frame.setIconImage( getToolkit().getImage("ghost_buster.ico") );
	minim = new Minim(this);
	startLevel(level);
	gB = new Buster();
	loadSfx();
	loadImages();
}

void draw() {
	//frameRate(10);
	int deathToll = 0;
	background(255);
	image(backgroundScene, 0, 0);

	if (gB.alive) {
		gB.beam();
		gB.findTarget();	
		gB.display();
		gB.move();

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
		canUseStun();
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
		int i;
		if (level > 0) {
			level = 0;
			ghost_ = new Ghost[80];
			for(i = 0; i < ghost_.length; i++) {
				ghost_[i] = new Ghost();
			}
		}
		for(i = 0; i < ghost_.length; i++) {
			ghost_[i].display();
			ghost_[i].move();
		}
		noStroke();
		fill(255,100,100, 100);
		rect(0,0, width, height);
		fill(0,0,0);
		textSize(80);
		textAlign(CENTER, CENTER);
		text("DEFEAT!", width/2, height - 100);
	}
}

void keyPressed() {
    gameController.handleKeyPress();
    if(stunReady && key == 'f' || key == 'F') {
    	shieldStr = shieldStr - 5;
    	stunPower = new StunBeam();
    	activateStun();
    	println("Stun, ACTIVATE!");
    }
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
	// Text
	fill(255,255,255);
	textSize(10);
	textAlign(RIGHT, TOP);
	text("HEALTH", width - 200 - 7, 1);
	// Bar
	noStroke();
	fill(100,255,100);
	rect(width - 200 - 3, 2, gB.health * 20, 10);
	// Outline
	noFill();
	stroke(255,255,255, 50);
	rect(width - 200 - 3, 2, 200, 10);
}

void shieldBar() {
	// Text
	fill(255,255,255);
	textSize(10);
	textAlign(RIGHT, TOP);
	text("SHIELD", width - 200 - 7, 15);
	// Bar
	if(stunReady) {
		fill(255,255,255);
		textSize(20);
		textAlign(RIGHT, TOP);
		text("PRESS F", width/2, 0);
	
		noStroke();
		fill(255, 255, 255);	
		rect(width - 200 - 3, 15, shieldStr * 20, 10);
	}
	else {
		noStroke();
		fill(100,100,255, 130);
		rect(width - 200 - 3, 15, shieldStr * 20, 10);
	}
	// Outline
	noFill();
	stroke(255,255,255, 50);
	rect(width - 200 - 3, 15, 200, 10);
}

void levelCount() {
	fill(255,255,255);
	textSize(20);
	textAlign(LEFT, TOP);
	text("LEVEL "+level, 5, 3);
}

void CheckSpawnPower() {
	powerNumber = random(1000);
	if(ghostCount >= powerNumber && shield == null) {
		blueSpawn = true;
		println(powerNumber);
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
void canUseStun() {
	if(shieldStr >= 5) {
		stunReady = true;
	}
	else {
		stunReady = false;
	}
}
void loadImages() {
	oozeImg = loadImage("oozedrop.png");
	backgroundScene = loadImage("background.png");
	busterGuy = loadImage("buster.png");
	ghostImg = loadImage("ghost.png");
	shieldImg = loadImage("shield.png");
}
void activateStun() {
	stunPower.display();
	stunPower.setStun();

}
void loadSfx() {
	sfx = true;
	// http://www.freesound.org/
	// Search for these file types:
	//   type: wav, bitdepth: 16, license: "Creative Commons 0"
	oozeSfxDropOoze[0] = minim.loadSample("164596__adam-n__water-splash-5.wav", 512);
	oozeSfxDropOoze[1] = minim.loadSample("189504__music-boy__water-splash.wav", 512);
	oozeSfxDropOoze[2] = minim.loadSample("190085__tran5ient__splash9.wav", 512);
	oozeSfxDeath = minim.loadSample("171844__oliroches__deathscream.wav", 512);
	busterSfxHit[0] = minim.loadSample("163441__under7dude__man-getting-hit.wav", 512);
	busterSfxHit[1] = minim.loadSample("163442__under7dude__man-dying.wav", 512);
	busterSfxShield = minim.loadSample("108823__freek12345__rejectj.wav", 512);
	busterSfxDeath = minim.loadSample("76376__spazzo-1493__game-over.wav", 512);
}
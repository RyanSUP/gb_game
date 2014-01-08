import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class gb_game extends PApplet {



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
boolean blueSpawn = false;
float powerNumber;

public void setup() {
	smooth();
	frameRate(60);
	size(500, 500);
	minim = new Minim(this);
	startLevel(level);
	gB = new Buster();
	loadSfx();
	loadImages();
}

public void draw() {
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
			ghost_[i].updateSpawn();
			ghost_[i].spawnOoze();
			ghost_[i].updateOoze();
			ghost_[i].move();
		}
		noStroke();
		fill(255,100,100, 100);
		rect(0,0, width, height);
		fill(255,20,20);
		textSize(80);
		textAlign(CENTER, CENTER);
		text("DEFEAT!", width/2, height - 100);
		println("gb alive "+gB.alive);
	}
}

public void keyPressed() {
    gameController.handleKeyPress();
}

public void keyReleased() {
    gameController.handleKeyReleased();
}

public void startLevel(int levelNumber) {

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

public void healthBar() {
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

public void shieldBar() {
	// Text
	fill(255,255,255);
	textSize(10);
	textAlign(RIGHT, TOP);
	text("SHIELD", width - 200 - 7, 15);
	// Bar
	noStroke();
	fill(100,100,255, 130);
	rect(width - 200 - 3, 15, shieldStr * 20, 10);
	// Outline
	noFill();
	stroke(255,255,255, 50);
	rect(width - 200 - 3, 15, 200, 10);
}

public void levelCount() {
	fill(255,255,255);
	textSize(20);
	textAlign(LEFT, TOP);
	text("LEVEL "+level, 5, 3);
}

public void CheckSpawnPower() {
	powerNumber = random(1000);
	if(ghostCount >= powerNumber && shield == null) {
		blueSpawn = true;
		println(powerNumber);
	}
	else {
		blueSpawn = false;
	}
}

public void SpawnBluePower() {
	if(blueSpawn && shield == null){
		shield = new BluePower();
	}
}

public void movePower(){
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

public void loadImages() {
	oozeImg = loadImage("oozedrop-sketch-mike.png");
	backgroundScene = loadImage("background.png");
	busterGuy = loadImage("buster-sketch-mike.png");
	ghostImg = loadImage("ghost-sketch-mike.png");
	shieldImg = loadImage("shield-sketch-mike.png");
}

public void loadSfx() {
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
class BluePower {
	float x, y, w, speed, powerLife;
	boolean bluePower = false;
	BluePower() {
		x = random(width/4, width/4*3);
		y = 0;
		w = 40;
		speed = 4;
	}
	public void display() {
		image(shieldImg, x, y);
		//noStroke();
		//fill(100,100,255);
		//ellipseMode(CORNER);
		//ellipse(x,y,w,w);
	}
	public void move() {
		y = y + speed;
	}
	public boolean checkForBuster() {
		if(x + w >= gB.x && x <= gB.x + gB.w && y + w >= gB.y) {
			if (sfx) busterSfxShield.trigger();
			bluePower = true;
			return true;
		}
		else {
			bluePower = false;
			return false;
		}
	}
}
class Buster {
	float beamX, x, y, w, beamY;
	boolean hasTarget = false;
	boolean alive = true;
	int health = 10;
	boolean rDirection = false;
	boolean lDirection = true;
	boolean beamDirection; // true == left false == right
	Ghost currentTarget = null;
	// ---Data ^^
	Buster() {
		w = 50;	
		x = width/2 - w/2;
		y = height - w;
		beamX = x;
		beamY = y - w/2;
	} // ----constructor
	public void hit() {
		if (sfx) busterSfxHit[PApplet.parseInt(random(2))].trigger();
		if(shieldStr > 0) {
			shieldStr = shieldStr - 1;
		}
		else {
			health -= 1;
		}
		if (health <= 0) {
			alive = false;
			if (sfx) busterSfxDeath.trigger();
		}
	}
	public void move() {
		if(gameController.isGoingLeft()) {
			x = constrain(x - 3, 0, width); // move ghost buster left if A is pressed
			if(currentTarget == null) {
			rDirection = false;
			lDirection = true;
		}
			}			
		else if(gameController.isGoingRight()) {
			x = constrain(x + 3, 0, width - w); // move ghost buster right if D is pressed
			if(currentTarget == null) {
			lDirection = false;
			rDirection = true;
		}
		}
	}
	public void display() {
		noStroke();
		rect(x,y,w,w);
		if(lDirection) {
			faceLeft();
		}
		else if(rDirection) {
			faceRight();
		}
	}
	public void findTarget() { // detects if there is a ghost under a mouse pointer and saves the last ghost
		int targetID = -1; // save the array pointer to the hovered ghost
		for(int i = 0; i < ghost_.length; i++) { // loop through all the ghosts
			if(ghost_[i].hasMouse == true) {
				targetID = i; // if there is a hovered ghost save it's array pointer
			}
		}
		if (targetID == -1) { // -1 means there were no hovered ghosts detected
			currentTarget = null;
			//println("There is no target.");
		}
		else {
			currentTarget = ghost_[targetID]; // set Buster's current target to a ghost
			//println("This is the Current Target: " + currentTarget);
		}
		if(targetID > -1 && currentTarget != null) {
			if(ghost_[targetID].x > x) {
				lDirection = false;
				rDirection = true;
			}
			else {
				rDirection = false;
				lDirection = true;
			}
		}	
	}
	public void beam() { // draw beam - more layers = colorful beam
		if(currentTarget != null) {
			strokeWeight(10);
			stroke(245, random(100,200), 0);
			line(beamX, beamY + w + 5, currentTarget.centerX, currentTarget.centerY);
			strokeWeight(5);
			stroke(245, random(100,200), 0);
			line(beamX, beamY + w + 5, currentTarget.centerX, currentTarget.centerY);
			strokeWeight(2);
			stroke(245, random(100,200), 0);
			line(beamX, beamY + w + 5, currentTarget.centerX, currentTarget.centerY);
			//println("This is the Current Target: " + currentTarget);
		}
		else {
			//println("There is no target");
		}
	}
	public void faceRight() {
		beamX = x + w; // update beamX position

		if(rDirection) {
			pushMatrix();
			scale(-1,1);
			image(busterGuy, -x -w, y);
			popMatrix();
		}
	}
	public void faceLeft() {
		beamX = x; // update beamX position
		if(lDirection) {
			pushMatrix();
			scale(1,1);
			image(busterGuy, x, y);
			popMatrix();
		}
	}
	 // functions ----
}
class Controller {

	boolean leftKeyDown = false;
	boolean rightKeyDown = false;

	boolean goingLeft = false;
	boolean goingRight = false;

	Controller() {

	}

	public void handleKeyPress() {
		if(key == 'a' || key == 'A') {
			leftKeyDown = true;
			goingLeft = true;
			goingRight = false;
		}
		if(key == 'd' || key == 'D') {
			rightKeyDown = true;
			goingRight = true;
			goingLeft = false;
		}
	}

	public void handleKeyReleased() {
		if(key == 'a' || key == 'A') {
			leftKeyDown = false;
			goingLeft = false;
			if (rightKeyDown) {
				goingRight = true;
			}
		}
		else if(key == 'd' || key == 'D') {
			rightKeyDown = false;
			goingRight = false;
			if (leftKeyDown) {
				goingLeft = true;
			}
		}
	}

	public boolean isGoingLeft() {
		if(gameController.leftKeyDown && gameController.goingLeft) {
			return true;
		}
		return false;
	}

	public boolean isGoingRight() {
		if(gameController.rightKeyDown && gameController.goingRight) {
			return true;
		}
		return false;
	}

}

class Ghost {
	float x, y, rx, ry, w, speed, centerX, centerY, counter, hoverLimit, spawnCheck, r, prob;
	boolean hasMouse = false;
	boolean dead = false;
	boolean spawnSwitch = false;	
	OozeDrop ooze;
	OozeDrop [] finalOoze = new OozeDrop[5];
	// --- data
	Ghost() {
		spawnCheck = random(1, 100);
		speed = 6; //ghost speed
		w = 50;
		x = random(0, width);
		y = random(0, height/2);
		centerX = x + 25;
		centerY = y + 25;
		if (level == 1) {
			if (difficulty == "testing") {
				hoverLimit = 10;
			}
			else if (difficulty == "easy") {
				hoverLimit = 20;
			}
			else if (difficulty == "hard") {
				hoverLimit = 35;
			}
		}
		else if (level >= 2) {
			if (difficulty == "testing") {
				hoverLimit = 10;
			}
			else if (difficulty == "easy") {
				hoverLimit = 22;
			}
			else if (difficulty == "hard") {
				hoverLimit = 37;
			}
		}
	} // constructor -----
	public void display() {
		image(ghostImg,x,y);
	}
	public void move() {
		r = random(1); //random value for proabability
		prob = 0.9f; //probability value
		if(r < prob) {
			rx = random(-speed, speed); // ^^
			x = constrain(x + rx, 0, width - w); //gets a random value from ry and rx, addes it to the x coordinate of ghost
		}
		else {
			ry = random(-speed, speed); // change speed with G
			y = constrain(y + ry, 20, height - gB.w - 100); // ^ same with Y
		}
		centerX = x + 25;
		centerY = y + 25;
	}
	public void freakout() { // increases speed if mouse is over the ghost
		if(hasMouse) {
			speed = 15;
		}
		else {
			speed = 6;
		}
	}
	public void mouseCheck() {
		if(mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + w) {
			hasMouse = true;
		}
		else {
			hasMouse = false;
		}
	}
	public void updateCounter() {
		if(hasMouse) {
			counter += 1;
		}
		else {
			counter = 0;
		}
		//println("counter equals: " + counter);
	}
	public void deathWatch() {
		if(counter >= hoverLimit) {
			dead = true;
			ghostCount -= 1;
			if (sfx) oozeSfxDeath.trigger();
			spawnDeathOoze();
			//println("You killed a ghost!");
		}
	}
	public void kill() {
		hasMouse = false;
	}
	public void updateSpawn() { // checks through the random spawn number
		spawnCheck = random(0, 200); // random spawn cycles through numbers 1 - 100
		if(spawnCheck >= 55 && spawnCheck <= 60) {  // if the number is between 50 and 60
			spawnSwitch = true; // ^ turn spawn on
		}
		else {
			spawnSwitch = false; // else keep it off
		}
		//println("the random ooze number is: " + spawnCheck + "The switch is: " + spawnSwitch);
	}		
	public void spawnOoze() {
		// spawns the ooze only if the switch is set and only if there isn't already an ooze
		if(spawnSwitch && ooze == null) {
			ooze = new OozeDrop(centerX, centerY);
			if (sfx) oozeSfxDropOoze[PApplet.parseInt(random(3))].trigger();
		}
	}
	public void updateOoze() {
		// first check if ooze exists, if it does then update it
		if(ooze != null) {
			// if the ooze fell past the ground get rid of it so we can make a new one
			if (ooze.y > height) {
				ooze = null;
			}
			else if(ooze.busterCheck()) {
				ooze = null;
			}
			// if the ooze didn't fall to the ground yet then update it
			else {
				ooze.move();
				ooze.display();
			}
		}
	}
	public void spawnDeathOoze() {
		for(int i = 0; i < finalOoze.length; i++) {
			finalOoze[i] = new OozeDrop(centerX + PApplet.parseInt(random(-35, 35)), centerY + PApplet.parseInt(random(-35, 35)));
		}
	
	}
	public void updateDeathOoze() {
		for(int i = 0; i < finalOoze.length; i++) {
			if(finalOoze[i] != null) {
				// if the ooze fell past the ground get rid of it so we can make a new one
				if (finalOoze[i].y > height) {
					finalOoze[i] = null;
				}
				else if(finalOoze[i].busterCheck()) {
					finalOoze[i] = null;
				}
				// if the ooze didn't fall to the ground yet then update it
				else {
					finalOoze[i].move();
					finalOoze[i].display();
				}
			}
		}
	}

}//
class OozeDrop {
	float x, y, rx, ry, w, speed, gravity;
	OozeDrop (float parentX, float parentY) {
		x = parentX;
		y = parentY;
		w = random(15, 25);
		speed = w/4;
		gravity = .03f;
	}
	public void display() {
		image(oozeImg, x, y, w, w);
	}
	public void move() {
		speed = speed + gravity;
		y = y + speed;
	}
	public boolean busterCheck() {
		if(x + w >= gB.x && x <= gB.x + gB.w && y + w >= gB.y) {
			gB.hit();
			return true;
		}
		else {
			return false;
		}
	}
}//
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "gb_game" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

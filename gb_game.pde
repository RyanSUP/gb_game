Buster gB;
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

class Buster {
	float center, x, y, w, h;
	boolean hasTarget = false;
	Ghost currentTarget = null;
	// ---Data ^^
	Buster() {
		w = 50;
		h = 50;	
		x = width/2 - w/2;
		y = height - h;
		center = x + w/2;
	} // ----constructor
	void move() {
		if(keyPressed) {
			if(key == 'a' || key == 'A') {
				x -= 3; // move ghost buster left if A is pressed
				center = x + 25; // update center position
			}
			if(key == 'd' || key == 'D') {
				x += 3; // move ghost buster right if D is pressed
				center = x + 25; // update center position
			}
		}
	}
	void display() {
		noStroke();
		fill(175);
		rect(x, y, w, h); // Ghost buster position
	}
	void findTarget() { // detects if there is a ghost under a mouse pointer and saves the last ghost
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
	}
	void beam() { // draw beam - more layers = colorful beam
		if(currentTarget != null) {
			strokeWeight(10);
			stroke(245, random(100,200), 0);
			line(center, height - 50, currentTarget.centerX, currentTarget.centerY);
			strokeWeight(5);
			stroke(245, random(100,200), 0);
			line(center, height - 50, currentTarget.centerX, currentTarget.centerY);
			strokeWeight(2);
			stroke(245, random(100,200), 0);
			line(center, height - 50, currentTarget.centerX, currentTarget.centerY);
			//println("This is the Current Target: " + currentTarget);
		}
		else {
			//println("There is no target");
		}
	}
	 // functions ----
}//

class Ghost {
	float x, y, rx, ry, w, speed, centerX, centerY, counter, hoverLimit, spawnCheck;
	boolean hasMouse = false;
	boolean dead = false;
	boolean spawnSwitch = false;
	OozeDrop ooze;
	// --- data
	Ghost() {
		spawnCheck = random(1, 100);
		speed = 3; //ghost speed
		w = 50;
		x = 200;
		y = 200;
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
	void display() {
		noStroke();
		ellipseMode(CORNER);
		fill(100, 255, 100);
		ellipse(x, y, w, w);
	}
	void move() {
		ry = random(-speed, speed); // change speed with G
		rx = random(-speed, speed); // ^^
		x = x + rx; //gets a random value from ry and rx, addes it to the x coordinate of ghost
		y = y + ry; // ^ same with Y
		centerX = x + 25;
		centerY = y + 25;
	}
	void freakout() { // increases speed if mouse is over the ghost
		if(hasMouse) {
			speed = 10;
		}
		else {
			speed = 3;
		}
	}
	void mouseCheck() {
		if(mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + w) {
			hasMouse = true;
		}
		else {
			hasMouse = false;
		}
	}
	void updateCounter() {
		if(hasMouse) {
			counter += 1;
		}
		else {
			counter = 0;
		}
		//println("counter equals: " + counter);
	}
	void deathWatch() {
		if(counter >= hoverLimit) {
			dead = true;
			println("You killed a ghost!");
		}
	}
	void kill() {
		hasMouse = false;
	}
	void updateSpawn() { // checks through the random spawn number
		spawnCheck = random(1, 100); // random spawn cycles through numbers 1 - 100
		if(spawnCheck >= 50 && spawnCheck <= 60) {  // if the number is between 50 and 60
			spawnSwitch = true; // ^ turn spawn on
		}
		else {
			spawnSwitch = false; // else keep it off
		}
		//println("the random ooze number is: " + spawnCheck + "The switch is: " + spawnSwitch);
	}		
	void spawnOoze() {
		// spawns the ooze only if the switch is set and only if there isn't already an ooze
		if(spawnSwitch && ooze == null) {
			ooze = new OozeDrop(centerX, centerY);
		}
	}
	void updateOoze() {
		// first check if ooze exists, if it does then update it
		if(ooze != null) {
			// if the ooze fell past the ground get rid of it so we can make a new one
			if (ooze.y > height) {
				ooze = null;
			}
			// if the ooze didn't fall to the ground yet then update it
			else {
				ooze.move();
				ooze.display();
				ooze.busterCheck();
			}
		}
	}
}//
class OozeDrop {
	float x, y, rx, ry, w, speed, centerX, centerY, gravity;
	OozeDrop (float parentX, float parentY) {
		x = parentX;
		y = parentY;
		w = 15;
		speed = 2;
		gravity = .05;
	}
	void display() {
		noStroke();
		ellipseMode(CORNER);
		fill(100, 255, 100);
		ellipse(x, y, w, w);
	}
	void move() {
		speed = speed + gravity;
		y = y + speed;
		centerX = x + w / 2;
		centerY = y + w / 2;
	}
	void busterCheck() {
		if(x + w >= gB.x && x + w <= gB.x + gB.w && y + w >= gB.y && y < gB.y + gB.w) {
			//hasMouse = true;
			println("within x range of buster");
		}
		else {
			//hasMouse = false;
		}
	}
}//

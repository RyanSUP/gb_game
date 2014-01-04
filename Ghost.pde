
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

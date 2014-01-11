
class Ghost {
	float x, y, rx, ry, w, speed, centerX, centerY, counter, hoverLimit, spawnCheck, r, prob;
	boolean stunned = false;
	boolean direction = true; 
	boolean hasMouse = false;
	boolean dead = false;
	boolean spawnSwitch = false;
	String type;
	OozeDrop ooze;
	OozeDrop [] finalOoze = new OozeDrop[5];
	// --- data
	Ghost() {
		type = "normal";
		spawnCheck = random(1, 100);
		speed = 3; //ghost speed
		w = 50;
		x = random(0, width);
		y = random(0, height/2);
		if (gameOver) {
			y = random(0, height);
		}
		centerX = x + 25;
		centerY = y + 25;
		hoverLimit = 10;
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
		facing();
	}
	void facing() {
		if(direction) {
			image(getImg(),x,y);
		}
		else {
			pushMatrix();
			scale(-1,1);
			image(getImg(), -x -w, y);
			popMatrix();
		
		}
	}
	PImage getImg() {
		if (type == "normal") {
			return ghostImg;
		}
		if (type == "follow") {
			return followGhostImg;
		}
		if (type == "side") {
			return sideGhostImg;
		}
		return ghostImg;
	}
	void move() {
		if(stunned == false) {
			if(gB.center > centerX) { //face right
				direction = false;
			}
			else {
				direction = true;
			}
			ry = random(-speed, speed); // change speed with G
			rx = random(-speed, speed); // ^^
			x = constrain(x + rx, 0, width - w); //gets a random value from ry and rx, addes it to the x coordinate of ghost
			if (!gameOver) {
				y = constrain(y + ry, 20, height - gB.w - 100); // ^ same with Y
			}
			else {
				y = constrain(y + ry, 20, height - w);
			}
			centerX = x + 25;
			centerY = y + 25;
		}
	}
	void freakout() { // increases speed if mouse is over the ghost
		if(hasMouse) {
			speed = 6;
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
			ghostCount -= 1;
			if (sfx) oozeSfxDeath.trigger();
			spawnDeathOoze();
			//println("You killed a ghost!");
		}
	}
	void kill() {
		hasMouse = false;
	}
	void updateSpawn() { // checks through the random spawn number
		spawnCheck = random(0, 200); // random spawn cycles through numbers 1 - 100
		if(spawnCheck >= 55 && spawnCheck <= 60) {  // if the number is between 50 and 60
			spawnSwitch = true; // ^ turn spawn on
		}
		else {
			spawnSwitch = false; // else keep it off
		}
		//println("the random ooze number is: " + spawnCheck + "The switch is: " + spawnSwitch);
	}		
	void spawnOoze() {
		// spawns the ooze only if the switch is set and only if there isn't already an ooze
		if(spawnSwitch && ooze == null && stunned == false) {
			ooze = new OozeDrop(type, centerX, centerY);
			if (sfx) oozeSfxDropOoze[int(random(3))].trigger();
		}
	}
	void updateOoze() {
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
				if(stunned) {
					ooze.display();
				}
				else {
					ooze.move();
					ooze.display();
				}
			}
		}
	}
	void spawnDeathOoze() {
		for(int i = 0; i < finalOoze.length; i++) {
			finalOoze[i] = new OozeDrop(type, centerX + int(random(-35, 35)), centerY + int(random(-35, 35)));
		}
	
	}
	void updateDeathOoze() {
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
					if(stunned) {
						finalOoze[i].display();
					}
					else {
						finalOoze[i].move();	
						finalOoze[i].display();
					}
				}
			}
		}
	}

}//

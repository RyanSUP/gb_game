class Buster {
	float center, x, y, w, h;
	boolean hasTarget = false;
	boolean alive = true;
	int health = 10;
	Ghost currentTarget = null;
	// ---Data ^^
	Buster() {
		w = 50;
		h = 50;	
		x = width/2 - w/2;
		y = height - h;
		center = x + w/2;
	} // ----constructor
	void hit() {
		if (sfx) busterSfxHit[int(random(2))].trigger();
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
	void move() {
		if(gameController.isGoingLeft()) {
			x = constrain(x - 3, 0, width); // move ghost buster left if A is pressed
			center = x + 25; // update center position
			}			
		if(gameController.isGoingRight()) {
			x = constrain(x + 3, 0, width - w); // move ghost buster right if D is pressed
			center = x + 25; // update center position
		}
	}
	void display() {
		image(busterGuy, x, y);
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
}
class Buster {
	float beamX, x, y, w, beamY, center;
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
		center = x - w/2;
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
			x = constrain(x - 4, 0, width); // move ghost buster left if A is pressed
			if(currentTarget == null) {
			rDirection = false;
			lDirection = true;
		}
			}			
		else if(gameController.isGoingRight()) {
			x = constrain(x + 4, 0, width - w); // move ghost buster right if D is pressed
			if(currentTarget == null) {
			lDirection = false;
			rDirection = true;
		}
		}
	}
	void display() {
		if(lDirection) {
			faceLeft();
		}
		else if(rDirection) {
			faceRight();
		}
	}
	void findTarget() { // detects if there is a ghost under a mouse pointer and saves the last ghost
		int ghostID = -1;
		int sideGuyID = -1;
		int followerID = -1; // save the array pointer to the hovered ghost
		for(int i = 0; i < sideGuy.length; i++) { // loop through all the ghosts
			if(sideGuy[i].hasMouse == true) {
				sideGuyID = i; // if there is a hovered ghost save it's array pointer
			}
		}
		for(int i = 0; i < ghost_.length; i++) { // loop through all the ghosts
			if(ghost_[i].hasMouse == true) {
				ghostID = i; // if there is a hovered ghost save it's array pointer
			}
		}
		for(int i = 0; i < follower.length; i++) { // loop through all the ghosts
			if(follower[i].hasMouse == true) {
				followerID = i; // if there is a hovered ghost save it's array pointer
			}
		}
		if (ghostID == -1 && sideGuyID == -1 && followerID == -1) { // -1 means there were no hovered ghosts detected
			currentTarget = null;
			//println("There is no target.");
		}
		else {
			if(sideGuyID > -1) {
				currentTarget = sideGuy[sideGuyID]; // set Buster's current target to a ghost
				//println("This is the Current Target: " + currentTarget);
				if(currentTarget != null) {
					if(sideGuy[sideGuyID].x > x) {
						lDirection = false;
						rDirection = true;
					}
					else {
						rDirection = false;
						lDirection = true;
					}
				}	
			}
			else if(ghostID > -1) {
				currentTarget = ghost_[ghostID]; // set Buster's current target to a ghost
				//println("This is the Current Target: " + currentTarget);					
					if(currentTarget != null) {
						if(ghost_[ghostID].x > x) {
							lDirection = false;
							rDirection = true;
						}
						else {
							rDirection = false;
							lDirection = true;
						}
					}	
			}
			else if(followerID > -1) {
				currentTarget = follower[followerID]; // set Buster's current target to a ghost
				//println("This is the Current Target: " + currentTarget);			
					if(currentTarget != null) {
						if(follower[followerID].x > x) {
							lDirection = false;
							rDirection = true;
						}
						else {
							rDirection = false;
							lDirection = true;
						}
					}	
			}
		}
	}	
	void beam() { // draw beam - more layers = colorful beam
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
	void faceRight() {
		beamX = x + w; // update beamX position
		center = x + w/2;
		if(rDirection) {
			pushMatrix();
			scale(-1,1);
			image(busterGuy, -x -w, y);
			popMatrix();
		}
	}
	void faceLeft() {
		beamX = x; // update beamX position
		center = x + w/2;
		if(lDirection) {
			pushMatrix();
			scale(1,1);
			image(busterGuy, x, y);
			popMatrix();
		}
	}
	 // functions ----
}
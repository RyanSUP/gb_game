class SideGhost extends Ghost {

	boolean sideScroll = false;

	SideGhost() {
		speed = 3;
	}
	void facing() {
		if(direction) {
			image(sideGhostImg,x,y);
		}
		else {
			pushMatrix();
			scale(-1,1);
			image(sideGhostImg, -x -w, y);
			popMatrix();
		
		}
	}
	void move() {
		if(stunned == false && hasMouse == false) {
			if(gB.center > centerX) { //face right
					direction = false;
			}
			else {
				direction = true;
			}
			if(x == width - w) {
				sideScroll = true;
			}
			else if(x == 0) {
				sideScroll = false;
			}
			if(sideScroll == false) {
				rx = random(0, speed); // ^^
				x = constrain(x + rx, 0, width - w);
			}
			else {	
				rx = random(-speed, 0); // ^^
				x = constrain(x + rx, 0, width - w);
			}
		}
		else if(stunned == false && hasMouse == true) {
			ry = random(-speed, speed); // change speed with G
			rx = random(-speed, speed); // ^^
			x = constrain(x + rx, 0, width - w);
			y = constrain(y + ry, 20, height - gB.w - 100);
		}	
			centerX = x + 25;
			centerY = y + 25;
	}

	void freakout() { // increases speed if mouse is over the ghost
		if(hasMouse) {
			speed = 6;
		}
		else {
			speed = 3;
		}
	}

	void spawnOoze() {
		// spawns the ooze only if the switch is set and only if there isn't already an ooze
		if(spawnSwitch && ooze == null && stunned == false) {
			ooze = new OozeDropSideGhost(centerX, centerY);
			if (sfx) oozeSfxDropOoze[int(random(3))].trigger();
		}
	}

}
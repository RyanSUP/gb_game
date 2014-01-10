class SideGhost extends Ghost {

	boolean sideScroll = false;

	SideGhost() {
		graphic = loadImage("sideghost.png");
		speed = 3;
	}

	void move() {
		if(stunned == false) {
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

}
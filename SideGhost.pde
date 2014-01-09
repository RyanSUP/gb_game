class SideGhost extends Ghost {
	boolean direction = false;
	float speed;
	SideGhost() {
		speed = 4;
	}
	void move() {
		if(x == width - w) {
			direction = true;
		}
		else if(x == 0) {
			direction = false;
		}
		if(direction == false) {
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
class OozeDrop {
	float x, y, rx, ry, w, speed, gravity;
	boolean freeze = false;
	OozeDrop (float parentX, float parentY) {
		x = parentX;
		y = parentY;
		w = random(15, 25);
		speed = w/4;
		gravity = .03;
	}
	void display() {
		image(oozeImg, x, y, w, w);
	}
	void move() {
		if(freeze == false) {
			speed = speed + gravity;
			y = y + speed;
		}
	}
	boolean busterCheck() {
		if(x + w >= gB.x && x <= gB.x + gB.w && y + w >= gB.y) {
			gB.hit();
			return true;
		}
		else {
			return false;
		}
	}
	void freezeCheck() {
		if(x + w >= stun.x && x + w <= stun.x + stun.w) {
			freeze = true;
		}
		else {
			freeze = false;
		}
	}
}//

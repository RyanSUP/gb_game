class OozeDrop {
	float x, y, rx, ry, w, speed, gravity;
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
	}
	boolean busterCheck() {
		if(x + w >= gB.x && x <= gB.x + gB.w && y + w >= gB.y) {
			//hasMouse = true;
			gB.hit();
			return true;
		}
		else {
			return false;
		}
	}
}//

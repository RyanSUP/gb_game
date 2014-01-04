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

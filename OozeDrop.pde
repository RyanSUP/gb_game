class OozeDrop {
	float x, y, rx, ry, w, speed, gravity;
	OozeDrop (float parentX, float parentY) {
		x = parentX;
		y = parentY;
		w = random(15, 25);
		speed = random(1.5, 8);
		gravity = .07;
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
		println(y);
	}
	boolean busterCheck() {
		if(x + w >= gB.x && x <= gB.x + gB.w && y + w >= gB.y) {
			println("within x range of buster");
			gB.hit();
			return true;
		}
		else {
			return false;
		}
	}
}//

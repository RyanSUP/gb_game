class OozeDrop {

	float x, y, rx, ry, w, speed, gravity;
	String type;
	boolean stunned = false;

	OozeDrop (String parentType, float parentX, float parentY) {
		type = parentType;
		x = parentX;
		y = parentY;
		w = random(10, 20);
		speed = w/4;
		gravity = .03;
	}
	void display() {
		if (type == "normal") {
			image(oozeImg, x, y, w, w);
		}
		else if (type == "follow") {
			image(oozeImgFollowGhost, x, y, w, w);
		}
		else if (type == "side") {
			image(oozeImgSideGhost, x, y, w, w);
		}
	}
	void move() {
		if(stunned == false) {
			speed = speed + gravity;
			y = y + speed;
		}
		else {
			y = y;
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
}//

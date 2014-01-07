class BluePower {
	float x, y, w, speed, powerLife;
	boolean bluePower = false;
	BluePower() {
		x = random(0, width - w);
		y = 0;
		w = 40;
		speed = 4;
	}
	void display() {
		image(shieldImg, x, y);
		//noStroke();
		//fill(100,100,255);
		//ellipseMode(CORNER);
		//ellipse(x,y,w,w);
	}
	void move() {
		y = y + speed;
	}
	boolean checkForBuster() {
		if(x + w >= gB.x && x <= gB.x + gB.w && y + w >= gB.y) {
			if (sfx) busterSfxShield.trigger();
			bluePower = true;
			return true;
		}
		else {
			bluePower = false;
			return false;
		}
	}
}
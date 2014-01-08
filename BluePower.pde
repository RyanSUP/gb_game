class BluePower {
	float x, y, w, speed, powerLife;
	boolean bluePower = false;
	BluePower() {
		x = random(width/4, width/4*3);
		y = 0;
		w = 40;
		speed = 4;
	}
	void display() {
		image(shieldImg, x, y);
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
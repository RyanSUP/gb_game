class StunBeam {
	float x,y,w,h;	
	StunBeam() {
		x = gB.x - w/2;
		y = height;
		w = shieldStr*20;
		h = 0;
	}
	void display() {
		noStroke();
		fill(100, 100, 255,100);
		rect(x, y, w, h);
	}
	void setStun() {
		for(int i = 0; i < ghost_.length; i++) {
			if(ghost_[i].x + ghost_[i].w >= x && x <= ghost_[i].x + ghost_[i].w) {
				ghost_[i].stunned = true;
			}	
			else {
				ghost_[i].stunned = false;
			}
		}
	}
}
class StunBeam {
	float x,y,w,h;	
	StunBeam() {
		timer = 0;
		x = gB.x - w/2;
		y = 0;
		w = 200;
		h = height;
	}
	void display() {
		noStroke();
		fill(100, 100, 255, 100);
		rect(x, y, w, h);
		//println("should be beam");
	}
	void setStun() {
		for(int i = 0; i < ghost_.length; i++) {
			if(ghost_[i].x + ghost_[i].w >= x && ghost_[i].x + ghost_[i].w <= x+w) {
				ghost_[i].stunned = true;
			}	
		}
	}

	void unsetStun() {
		for(int i = 0; i < ghost_.length; i++) {
			ghost_[i].stunned = false;
		}
	}

}
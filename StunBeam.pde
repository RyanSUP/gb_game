class StunBeam {
	float x,y,w,h;	
	StunBeam() {
		timer = 0;
		w = 200;
		x = gB.center - w/2;
		y = 0;
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
		for(int i = 0; i < follower.length; i++) {
			if(follower[i].x + follower[i].w >= x && follower[i].x + follower[i].w <= x+w) {
				follower[i].stunned = true;
			}	
		}
		for(int i = 0; i < sideGuy.length; i++) {
			if(sideGuy[i].x + sideGuy[i].w >= x && sideGuy[i].x + sideGuy[i].w <= x+w) {
				sideGuy[i].stunned = true;
			}	
		}
	}

	void unsetStun() {
		for(int i = 0; i < ghost_.length; i++) {
			ghost_[i].stunned = false;
		}
		for(int i = 0; i < sideGuy.length; i++) {
			sideGuy[i].stunned = false;
		}
		for(int i = 0; i < follower.length; i++) {
			follower[i].stunned = false;
		}


	}

}
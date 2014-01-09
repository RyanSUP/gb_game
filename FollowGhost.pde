class FollowGhost extends Ghost {
	
	FollowGhost() {

	}
	void move() {
		if(stunned == false) {
			r = random(1); //random value for proabability
			prob = 0.9; //probability value
			if(r < prob) {
                if(r < 0.1) {
                    if(x < gB.x) {
                           rx = random(speed); // ^^
                    }
                    else if(x > gB.x) {
                           rx = random(-speed, 0);
                    }
                   	x = constrain(x + rx, 0, width - w); //gets a random value from ry and rx, addes it to the x coordinate of ghost
         	   	}
            }
            else {
                ry = random(-speed, speed); // change speed with G
              	y = constrain(y + ry, 20, height - gB.w - 100); // ^ same with Y
	    	}
			centerX = x + 25;
			centerY = y + 25;
		}
	}
}//

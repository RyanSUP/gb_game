class FollowGhost extends Ghost {
	
	FollowGhost() {
		type = "follow";
		speed = 6;
	}

	void move() {
		if(stunned == false && hasMouse == false) {
			if(gB.center > centerX) { //face right
					direction = false;
			}
			else {
				direction = true;
			}
			r = random(1); //random value for proabability
			prob = 0.9; //probability value
			if(r < prob) {
                if(r < 0.5) {
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
		}
		else if(stunned == false && hasMouse == true) {
			ry = random(-speed, speed); // change speed with G
			rx = random(-speed, speed); // ^^
			x = constrain(x + rx, 0, width - w);
			y = constrain(y + ry, 20, height - gB.w - 100);
		}
		centerX = x + 25;
		centerY = y + 25;
	
	}

	void freakout() { // increases speed if mouse is over the ghost
		if(hasMouse) {
			speed = 10;
		}
		else {
			speed = 6;
		}
	}

}//

/*void superCrazyMove() {
		if(stunned == false && hasMouse == false) {
			if(gB.center > centerX) { //face right
					direction = false;
			}
			else {
				direction = true;
			}
			r = random(1); //random value for proabability
			prob = 0.9; //probability value
			if(r < prob) {
                if(r < 0.5) {
                    if(x < gB.x) {
                        rx = random(speed); // ^^
                    }
                    else if(x > gB.x) {
                       rx = random(-speed, 0);
                    }
         	   	}
            }
            else {
                ry = random(-speed, speed); // change speed with G
	    	}
		}
		else if(stunned == false) {
			ry = random(-speed, speed); // change speed with G
			rx = random(-speed, speed); // ^^
		}

		x = constrain(x + rx, 0, width - w); //gets a random value from ry and rx, addes it to the x coordinate of ghost
		y = constrain(y + ry, 20, height - gB.w - 100); // ^ same with Y
		centerX = x + 25;
		centerY = y + 25;
	}*/

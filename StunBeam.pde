class StunBeam {
	float x,y,w,h;	
	StunBeam() {
		x = width/2;
		y = 0;
		w = 200;
		h = height;
	}
	void display() {
		noStroke();
		fill(100, 100, 255,100);
		rect(x, y, w, h);
	}
}
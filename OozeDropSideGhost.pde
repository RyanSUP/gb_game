class OozeDropSideGhost extends OozeDrop {

	OozeDropSideGhost (float parentX, float parentY) {
		super(parentX, parentY);
	}

	void display() {
		image(oozeImgSideGhost, x, y, w, w);
	}

}//

class OozeDropFollowGhost extends OozeDrop {

	OozeDropFollowGhost (float parentX, float parentY) {
		super(parentX, parentY);
	}

	void display() {
		image(oozeImgFollowGhost, x, y, w, w);
	}

}//

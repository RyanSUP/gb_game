class Controller {

	boolean leftKeyDown = false;
	boolean rightKeyDown = false;

	boolean goingLeft = false;
	boolean goingRight = false;

	Controller() {

	}

	void handleKeyPress() {
		if(key == 'a' || key == 'A') {
			leftKeyDown = true;
			goingLeft = true;
			goingRight = false;
		}
		if(key == 'd' || key == 'D') {
			rightKeyDown = true;
			goingRight = true;
			goingLeft = false;
		}
	}

	void handleKeyReleased() {
		if(key == 'a' || key == 'A') {
			leftKeyDown = false;
			goingLeft = false;
			if (rightKeyDown) {
				goingRight = true;
			}
		}
		else if(key == 'd' || key == 'D') {
			rightKeyDown = false;
			goingRight = false;
			if (leftKeyDown) {
				goingLeft = true;
			}
		}
	}

	boolean isGoingLeft() {
		if(gameController.leftKeyDown && gameController.goingLeft) {
			return true;
		}
		return false;
	}

	boolean isGoingRight() {
		if(gameController.rightKeyDown && gameController.goingRight) {
			return true;
		}
		return false;
	}

}
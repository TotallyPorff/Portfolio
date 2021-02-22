#include "clipDetector.h"
#include <HAPI_lib.h>

using namespace HAPISPACE;

clipDetector::clipDetector(int posX, int posY, int boxWidth, int boxHeight) {
	topLeftCoords[0] = posX;
	topLeftCoords[1] = posY;
	bottomLeftCoords[0] = posX + boxWidth;
	bottomLeftCoords[1] = posY + boxHeight;
	width = boxWidth;
	height = boxHeight;
}

clipDetector::~clipDetector() {

}


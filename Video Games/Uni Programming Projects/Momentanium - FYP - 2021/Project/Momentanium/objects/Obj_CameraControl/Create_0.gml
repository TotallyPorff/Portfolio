/// @description Setup viewport camera
/* NOTE: Viewport 0 is set to follow this object, and has the correct resolution set*/

//Grab camera ID
cameraID = view_get_camera(0);

//Set camera pos and speed variables
cameraXCentre = room_width / 2;
cameraYCentre = room_height / 2;
cameraXTarget = cameraXCentre;
cameraYTarget = cameraYCentre;
x = cameraXCentre;
y = cameraYCentre;
cameraSpeed = 100;

//Set camera size variables
cameraWidthMax = 1280;
cameraHeightMax = 720;
cameraWidthMin = 640;
cameraHeightMin = 360;
cameraWidth = cameraWidthMax;
cameraHeight = cameraHeightMax;
camera_set_view_size(cameraID, cameraWidth, cameraHeight);
borderPerc = 30;

//Set border maximums so camera can only view in certain area
maxBorderRight = cameraXCentre + (cameraWidthMax / 2);
maxBorderLeft = cameraXCentre - (cameraWidthMax / 2);
maxBorderBottom = cameraYCentre + (cameraHeightMax / 2);
maxBorderTop = cameraYCentre - (cameraHeightMax / 2);


//Get instances of all player controlled characters
playerChars = ds_list_create();
alarm[0] = 1;


// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Approach(arg0, arg1, arg2){
	if (arg0 < arg1) {
		arg0 += arg2;
		if (arg0 > arg1) {
			return arg1;
		}
	} else {
		arg0 -= arg2;
		if (arg0 < arg1) {
			return arg1;
		}
	}
	
	return arg0;
}
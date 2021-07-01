// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Approach(variable, maximum, increment){
	//If var less than max
	if (variable < maximum) {
		//increase
		variable += increment;
		//If beyond max
		if (variable > maximum) {
			return maximum;
		}
		//else return variable
		return variable;
	}
	else {
		//decrease
		variable -= increment;
		//if beyond max
		if (variable < maximum) {
			return maximum;
		}
		//else return variable
		return variable;
	}
	//else return max
	return variable;
}
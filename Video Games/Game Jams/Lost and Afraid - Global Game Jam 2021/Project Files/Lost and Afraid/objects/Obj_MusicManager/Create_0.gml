/// @description Create Music
mainMusic = 0;
mainMusicVol = 0;

//variables for darkness room
softPianoVol = 1;
stringsVol = 0;
sawBassVol = 0;
sqrBassVol = 0;
kickVol = 0;
whisperVol = 0;

//Indexes to store
softPiano = 0;
strings = 0;
sawBass = 0;
sqrBass = 0;
kick = 0;
whisper = 0;

if (room == Rm_Main) {
	mainMusic = audio_play_sound(Snd_Main_Theme, 0, true);
	audio_sound_gain(mainMusic, mainMusicVol, 0);
}
if (room == Rm_Darkness) {
	softPiano = audio_play_sound(Snd_Anxiety_SoftPiano, 0, true);
	audio_sound_gain(softPiano, softPianoVol, 0);
	
	strings = audio_play_sound(Snd_Anxiety_Strings, 0, true);
	audio_sound_gain(strings, stringsVol, 0);
	
	sawBass = audio_play_sound(Snd_Anxiety_SawBass, 0, true);
	audio_sound_gain(sawBass, sawBassVol, 0);
	
	sqrBass = audio_play_sound(Snd_Anxiety_SqrBass, 0, true);
	audio_sound_gain(sqrBass, sqrBassVol, 0);
	
	kick = audio_play_sound(Snd_Anxiety_Kick, 0, true);
	audio_sound_gain(kick, kickVol, 0);
	
	whisper = audio_play_sound(Snd_Whispers, 0, true);
	audio_sound_gain(whisper, whisperVol, 0);
	
	//Wind SFX
	audio_play_sound(SFX_Wind, 0, true);
}
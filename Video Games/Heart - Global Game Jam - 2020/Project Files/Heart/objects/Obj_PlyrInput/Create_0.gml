//Setting variables
inputted = false;
input = "None";
shownInputs = false;

//Setting Spot variables
spot1X = room_width / 4;
spot1Y = 384;
spot2X = 512;
spot2Y = 384;
spot3X = (room_width / 2) + (room_width / 4)
spot3Y = 384;

//Creating boxes
badInput = instance_create_layer(-200, -200, "Text", Obj_InptBox);
neutralInput = instance_create_layer(-200, -200, "Text", Obj_InptBox);
goodInput = instance_create_layer(-200, -200, "Text", Obj_InptBox);

//Creating response array
//PERSONALITY PLAYER RESPONSES
if (Obj_Heart.personality == 0) { //Reluctant to admit to problem
	//persArray[0, 0] responses
	persRespArray[0, 0] = "Are you super sure it's going well?";
	persRespArray[0, 1] = "Well, that's good to hear that everything is fine!";
	persRespArray[0, 2] = "Life doesn't always go well, and I'm here when you need me.";
	//persArray[0, 1] responses
	persRespArray[1, 0] = "Damn, I'm super jealous!";
	persRespArray[1, 1] = "Sounds like you had a nice day then.";
	persRespArray[1, 2] = "It's good that you decided to take care of yourself for the day.";
	//persArray[0, 2] responses
	persRespArray[2, 0] = "Everything? Are you sure everything was great?";
	persRespArray[2, 1] = "I'm happy to see that you're enjoying things. It makes me smile.";
	persRespArray[2, 2] = "That's great! If it ever goes bad though, I'm here to help.";
	
	//persArray[1, 0] responses
	persRespArray[3, 0] = "Are you sure? Cause you're clearly not happy.";
	persRespArray[3, 1] = "It's nice to know you're ok.";
	persRespArray[3, 2] = "You guess? Is something up that I can help you with?";
	//persArray[1, 1] responses
	persRespArray[4, 0] = "Sounds like you'll be fine then.";
	persRespArray[4, 1] = "Don't worry about the stuff, you'll get it done in time.";
	persRespArray[4, 2] = "I can help you get the stuff done, if you want?";
	//persArray[1, 2] responses
	persRespArray[5, 0] = "You clearly don't look OK! What can I do to help?";
	persRespArray[5, 1] = "Ah, that's good to hear everything is alright.";
	persRespArray[5, 2] = "I mean, it's OK if it's not going OK, but that's nice to hear.";
	
	//persArray[2, 0] responses
	persRespArray[6, 0] = "Ah, it's nice to know you can handle it.";
	persRespArray[6, 1] = "Small problems can end up much bigger than expected.";
	persRespArray[6, 2] = "I can help with it to take some weight off your shoulders, if you want?";
	//persArray[2, 1] responses
	persRespArray[7, 0] = "Yeah you'll be fine. I stay up late all the time.";
	persRespArray[7, 1] = "Just take care of yourself and try to sleep well.";
	persRespArray[7, 2] = "What kept you up so late?";
	//persArray[2, 2] responses
	persRespArray[8, 0] = "Ah, should be no problem then.";
	persRespArray[8, 1] = "As long as you're ok with handling it.";
	persRespArray[8, 2] = "Just because you're used to it doesn't mean you'll always be ok with it.";
} else if (Obj_Heart.personality == 1) { //Reluctant to share the problem
	//persArray[0, 0] responses
	persRespArray[0, 0] = "Are you sure you don't need any help at all?";
	persRespArray[0, 1] = "I understand. Sometimes things are just difficult to talk about.";
	persRespArray[0, 2] = "I'll be here if you need help when things become too much to handle.";
	//persArray[0, 1] responses
	persRespArray[1, 0] = "Why are friends not allowed to help with personal problems?";
	persRespArray[1, 1] = "That's fair, I'll try to not bother you about it much more.";
	persRespArray[1, 2] = "I'm your friend. If you need help, I will be there.";
	//persArray[0, 2] responses
	persRespArray[2, 0] = "It isn't overwhelming you or anything? Do you need my help?";
	persRespArray[2, 1] = "It's good to know that you'll be able to handle it.";
	persRespArray[2, 2] = "It's OK to ask for help if things become overwhelming.";
	
	//persArray[1, 0] responses
	persRespArray[3, 0] = "You look really tired. Are you sure you're fine?";
	persRespArray[3, 1] = "It's good to know that when life isn't great, you're willing to admit it.";
	persRespArray[3, 2] = "Sometimes life is really difficult, so I'm glad we have each other for those times.";
	//persArray[1, 1] responses
	persRespArray[4, 0] = "So there's still a problem? I can help you with it.";
	persRespArray[4, 1] = "I'm glad you're confident you can handle it.";
	persRespArray[4, 2] = "As long as you're able to take care of yourself, I'm happy.";
	//persArray[1, 2] responses
	persRespArray[5, 0] = "I'll take the weight off your shoulders and handle it for you.";
	persRespArray[5, 1] = "I'm sure you can get through it. After all, it's just small bumps.";
	persRespArray[5, 2] = "Take it slow, cause small bumps can still have a big effect on people.";
	
	//persArray[2, 0] responses
	persRespArray[6, 0] = "If you don't want to, then don't.";
	persRespArray[6, 1] = "Maybe take the time to think about it if you're not sure.";
	persRespArray[6, 2] = "It's hard to ask for help, but some things you can't face alone...";
	//persArray[2, 1] responses
	persRespArray[7, 0] = "If you want to handle it by yourself, I won't stop you.";
	persRespArray[7, 1] = "Sometimes things can get a bit too much.";
	persRespArray[7, 2] = "It's alright if you can't. You're not alone. There are people who want to help.";
	//persArray[2, 2] responses
	persRespArray[8, 0] = "If things are overwhelming then I'll take the weight off your shoulders.";
	persRespArray[8, 1] = "It's good to be confident in your abilities.";
	persRespArray[8, 2] = "If you want, we can get through it together. That way it'll be easier to deal with.";
}

//PROBLEM PLAYER RESPONSES
if (Obj_Heart.problem == 0) {
	//probArray[0, 0] responses
	probRespArray[0, 0] = "Maybe you should reconsider your options?";
	probRespArray[0, 1] = "It's OK, you can resit them when you're ready.";
	probRespArray[0, 2] = "It's OK if you fail, that's how you learn and improve!";
	//probArray[0, 1] responses
	probRespArray[1, 0] = "Just hang out with people, you'll eventually get used to it.";
	probRespArray[1, 1] = "Maybe listening to music can help? It'll take your focus away from the crowd.";
	probRespArray[1, 2] = "Socialising can be stressful. Try to take things slow, and take breathers when you need them.";
	//probArray[0, 2] responses
	probRespArray[2, 0] = "I doubt anyone is following you. You're fine!";
	probRespArray[2, 1] = "Sounds like you're a bit paranoid. Maybe try to take a breather when that happens?";
	probRespArray[2, 2] = "If you want, I can walk with you, to keep you safe?";
	
	//probArray[1, 0] responses
	probRespArray[3, 0] = "Eh that happens every now and again, It'll pass eventually.";
	probRespArray[3, 1] = "Try out different things, you'll eventually find your motivation again!";
	probRespArray[3, 2] = "Take a little bit of time each day to work on something you like.";
	//probArray[1, 1] responses
	probRespArray[4, 0] = "Just lay low and nothing scary will actually happen.";
	probRespArray[4, 1] = "Maybe try talking online? That often ends up being less scary...";
	probRespArray[4, 2] = "Take your time, and remove yourself from conversations when you need a breather.";
	//probArray[1, 2] responses
	probRespArray[5, 0] = "Everyone else is in the same boat, you'll be OK!";
	probRespArray[5, 1] = "Make some notes, they'll help you get through it.";
	probRespArray[5, 2] = "Talk to someone about it, they can help you rehearse and calm your nerves.";
	
	//probArray[2, 0] responses
	probRespArray[6, 0] = "As long as you keep at it'll, you'll get it done in time!";
	probRespArray[6, 1] = "Plan it out, that way you have a good plan of what to do!";
	probRespArray[6, 2] = "You can do it! Focus on it and don't be afraid to ask for help.";
	//probArray[2, 1] responses
	probRespArray[7, 0] = "If you're worried, try to be a bit more careful about your spending.";
	probRespArray[7, 1] = "Try to save up some emergency money in case.";
	probRespArray[7, 2] = "I can you help schedule a budget, so you can organise your spending more.";
	//probArray[2, 2] responses
	probRespArray[8, 0] = "Leave them a note or something if you can't face them.";
	probRespArray[8, 1] = "Try chatting online with them first. It can be easier than face to face";
	probRespArray[8, 2] = "Just try talking to them, cause you never know what they think unless you ask.";
} else if (Obj_Heart.problem == 1) {
	//probArray[0, 0] responses
	probRespArray[0, 0] = "Does it matter what they say about you?";
	probRespArray[0, 1] = "They're just being mean, you don't have to believe what they say.";
	probRespArray[0, 2] = "Just because they say it doesn't mean there's any truth to it.";
	//probArray[0, 1] responses
	probRespArray[1, 0] = "You could try being healthier, that way they couldn't complain about it";
	probRespArray[1, 1] = "Our bodies are always changing. Maybe in the future they'll be the unhealthy ones!";
	probRespArray[1, 2] = "Your body is great because you live in it, not because its healthy.";
	//probArray[0, 2] responses
	probRespArray[2, 0] = "Try to ignore them, they're just laughing to try and make their life better.";
	probRespArray[2, 1] = "They could be laughing to hide the fact that they're also struggling.";
	probRespArray[2, 2] = "No. What your life is is up for you to decide, not them.";
	
	//probArray[1, 0] responses
	probRespArray[3, 0] = "You're often left alone, like when you're at home for example.";
	probRespArray[3, 1] = "Try talking to someone who can get them to stop it.";
	probRespArray[3, 2] = "I can hang out with you more so that you'll have someone to keep you safe.";
	//probArray[1, 1] responses
	probRespArray[4, 0] = "Thing is, when you finally fit in, you'll be wishing you stood out.";
	probRespArray[4, 1] = "It's not your fault, they just can't accept someone who is different to them.";
	probRespArray[4, 2] = "Everyone is unique, so you should stay true to who you are.";
	//probArray[1, 2] responses
	probRespArray[5, 0] = "Hiding away isn't going to solve the situation.";
	probRespArray[5, 1] = "If you don't go you'll end up missing out on the things you enjoy!";
	probRespArray[5, 2] = "Get someone to stay by you, so they can handle them while you enjoy the day.";
	
	//probArray[2, 0] responses
	probRespArray[6, 0] = "Buy less comfort food so that when you're upset you'll end up eating less.";
	probRespArray[6, 1] = "When you're upset, take a step back and take a breather when you can.";
	probRespArray[6, 2] = "Try to find other things that help calm you down, like music.";
	//probArray[2, 1] responses
	probRespArray[7, 0] = "You don't have to listen or respond to them, as what they say doesn't matter.";
	probRespArray[7, 1] = "Find a safe space they can't get to so you have somewhere to avoid them.";
	probRespArray[7, 2] = "I can hang out with you more so they have less opportunity to get in your face.";
	//probArray[2, 2] responses
	probRespArray[8, 0] = "You can set alarm across your room to help get out of bed in the morning.";
	probRespArray[8, 1] = "Try to think about all the fun things and people you'll miss if you don't get out of bed.";
	probRespArray[8, 2] = "Just take the time to ready yourself and breathe to calm your nerves.";
}
var answerShown = false;
var kResultList;

function flipCard() {
		answerShown = true;
		$('#flipcard').hide();
		$('#answer_text').show();
		$('#submit_buttons').show();
		kResultList.enable();
}

function resetCard() {
	answerShown = false;
	$('#flipcard').show();
	$('#answer_text').hide();
	$('#submit_buttons').hide();
	document.getElementById('result_flash').innerHTML = '';
	kResultList.disable();
}

function setupKeyListener() {
	kResultList = new YAHOO.util.KeyListener(document, { keys:[49,50,51,52,53,54] }, { fn:keyHandler } )
	kFlipList = new YAHOO.util.KeyListener(document, { keys:[32] }, { fn:keyHandler } )
	kFlipList.enable();
}
YAHOO.util.Event.addListener(window, "load", setupKeyListener);

function setupClickListener() {
	YAHOO.util.Event.on($('#flashcard'), 'click', function(e) {
		flipCard();
	});
}
YAHOO.util.Event.addListener(window, "load", setupClickListener);

var keyHandler = function(type, args, obj) {
	var keyCode = args[0];
	switch (keyCode) {
	case 32:
		flipCard();
		break;
	case 49:
		clickButton('Perfect');
		break;
	case 50:
		clickButton('Good');
		break;
	case 51:
		clickButton('Pass');
		break;
	case 52:
		clickButton('Fail');
		break;
	case 53:
		clickButton('Bad');
		break;
	case 54:
		clickButton('Unknown');
		break;
	default:
	}
}

function flashResponse(buttonId) {
	document.getElementById('result_flash').innerHTML = buttonId;
	if ($('#buttons_panel') != null) {
		$('#submit_buttons').hide();
	}
}

function clickButton(buttonId) {
	var b = document.getElementById(buttonId);
	b.click();
}

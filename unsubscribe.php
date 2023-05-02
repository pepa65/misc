<?php
// Header (https): "List-Unsubscribe: <https://URL/unsubscribe.php?i=LISTID&e=EMAIL>"
// Header (mailto): "List-Unsubscribe: <mailto:TO?from=EMAIL&subject=Unsubscribe&body=LISTID>"
// Combined: "List-Unsubscribe: <...>,<...>"
// Set URL and TO according to the setup, and LISTID and EMAIL for each addressee in the mailer
// Configure when installing unsubscribe.php on the server
$email=@$_GET['e']; // EMAIL
$listid=@$_GET['i']; // LISTID
if($email!="" && $listid!=""){
	// Configuration
	$to='TO';
	$fromname='FROM_NAME';
	$frommail='FROM_MAIL';
	$afterwards='LINK';
	$ids=array('LISTID' => 'IDENTIFIER',);

	// Validate id
	$identifier=@$ids[$listid];
	if(!isset($identifier)){$identifier=$listid;}

	// Send mail: notify TO about EMAIL unsubscribing from LISTID
	$subject="Unsubscribe from $identifier";
	$msg="Heya,\n\nUnsubscribe from: $identifier\nEmail: $email\n\n$fromname\n";
	$headers="From: $fromname <$frommail>";
	error_log("Notify $to about $email: $subject ($headers)");
	mail($notify, $subject, $msg, $headers);
}
error_log("Location: $afterwards");
header('Location: $afterwards');
?>

<?php // Unsubscribe link: https://SITE?i=ID_STRING&e=EMAIL
// Unsubscribe header: "List-Unsubscribe: <mailto:EMAIL?subject=unsubscribe>"
// Parameters in link
$email=@$_GET['e']; // EMAIL
$id=@$_GET['i']; // ID_STRING

// Configuration
$tomail='TO_MAIL';
$fromname='FROM_NAME';
$frommail='FROM_MAIL';
$afterwards='LINK';
$ids=array('ID_STRING' => 'IDENTIFIER',);

// Validate id
$listid=@$ids[$id];
if(isset($listid)){
	// Send mail: notify $tomail about $email unsubscribing from $listid
	$subject="Unsubscribe from $id[$i]";
	$msg="Heya,\n\nUnsubscribe from: $listid\nEmail: $email\n\n$fromname\n";
	$headers="From: $fromname <$frommail>";
	error_log("Notify $tomail about $email: $subject ($headers)");
	mail($notify, $subject, $msg, $headers);
}
error_log("Location: $afterwards");
header('Location: $afterwards');
?>

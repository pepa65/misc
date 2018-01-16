<?php
// For the user that is used by the webserver: 'difth' must be in path,
//  and the directory $files (variable in difth) must be writable.
// Copy these files to the webserver root: index.html difth.php favicon.ico
echo(shell_exec('difth' . ($_POST['send'] == '⇶' ? ' -n' : '')
	. ' -s "' . str_replace("\"", "\\\"", $_POST['old']) . '" "'
	. str_replace("\"", "\\\"", $_POST['new']) . '" /'));
?>

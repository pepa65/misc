<?php
// For the user that is used by the webserver: 'difth' must be in path,
//  and the directory $files (variable set in difth) must be writable,
//  chown www-data $files; chmod 2770 $files
// Copy these files to the webserver root: index.html difth.php favicon.ico
echo(shell_exec('difth' . ($_POST['send'] == '⇶' ? ' -n' : '')
	. ' -s "' . str_replace("\"", "\\\"", $_POST['old']) . '" "'
	. str_replace("\"", "\\\"", $_POST['new']) . '" /'));
?>

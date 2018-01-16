<?php
// For the user that is used by the webserver: the directory $files (in difth)
//  must be writable, and 'difth' must be in path.
echo(shell_exec('difth' . ($_POST['send'] == '⇶' ? ' -n' : '')
	. ' -s "' . str_replace("\"", "\\\"", $_POST['old']) . '" "'
	. str_replace("\"", "\\\"", $_POST['new']) . '" /'));
?>

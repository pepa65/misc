<?php
echo(shell_exec('./difth' . ($_POST['send'] == '⇶' ? ' -n' : '')
	. ' -s "' . str_replace("\"", "\\\"", $_POST['old']) . '" "'
	. str_replace("\"", "\\\"", $_POST['new']) . '" /'));
?>

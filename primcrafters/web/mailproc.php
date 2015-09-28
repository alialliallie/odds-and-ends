#!/usr/bin/php
<?php
require "config.php";
## The log file, I should make it use this sometime
$logfile = "mailproc.log";
## Variables that must be present.
$requiredvars = array('sim', 'buyer', 'frame', 'type', 'price');
$update_vars = array('buyer');

###
# Ne touche pas!!
###
$log = fopen($logfile,'a');

// read from stdin
$fd = fopen("php://stdin", "r");
$email = "";
while (!feof($fd)) {
    $email .= fread($fd, 1024);
}
fclose($fd);

// handle email
$lines = explode("\n", $email);

// empty vars
$from = "";
$subject = "";
$headers = "";
$message = "";
$splittingheaders = true;

for ($i=0; $i<count($lines); $i++) {
    if ($splittingheaders) {
        // this is a header
        $headers .= $lines[$i]."\n";

        // look out for special headers
        if (preg_match("/^Subject: (.*)/", $lines[$i], $matches)) {
            $subject = $matches[1];
        }
        if (preg_match("/^From: (.*)/", $lines[$i], $matches)) {
            $from = $matches[1];
        }
    } else {
        // not a header, but message
        $message .= $lines[$i]."\n";
    }

    if (trim($lines[$i])=="") {
        // empty line, header section has ended
        $splittingheaders = false;
    }
}

// If the subject line isn't 'sale' then we don't want this email
if (strtolower($subject) == 'sale')
{
	// Message got changed from \r\n to \n in initial explosion
	$varList = explode("\n",$message);
	foreach($varList as $var) {
		list($key,$value)=explode(':',$var,2);
		if (in_array(strtolower($key), $requiredvars)) {
			$vars[strtolower($key)]=substr($value,1);
		}
	}

	// Check to make sure we got all the required parameters
	$missingvars = Array();
	$varkeys = array_keys($vars);
	foreach ($requiredvars as $req) {
		if (!in_array(strtolower($req),$varkeys)) {
			$missingvars[] = $req;
		}
	}

	// If $missingvars has elements, log and die
	if (count($missingvars) != 0) {
		$missingstr;
		foreach ($missingvars as $missing)
			$missingstr .= $missing." ";
		fwrite($log, "Error: Missing $missingstr\n");
		fclose($log);
		die("Missing variables.");
	}

	$sql = "INSERT INTO sales SET ";
	foreach (array_keys($vars) as $key)
	{
		$sql .= "$key='" . mysql_escape_string($vars[$key]) . "', ";
	}
	$sql .= "date=NOW()";
	mysql_connect($db_server, $db_username, $db_password); 
	mysql_select_db($db_name);
	$result = mysql_query($sql);
	if (mysql_errno())
	{
		fwrite($log, date() . "Error: " . mysql_error());
	}
}
else if (strtolower($subject) == 'updaterequest')
{
}

fclose($log);
?>

<?php
	require "config.php";
	mysql_connect($db_server, $db_username, $db_password); 
	mysql_select_db($db_name);

	$simnames = Array();
	$simnames[] = "All";
	$sql_simnames = "SELECT sim FROM sales GROUP BY sim";
	$results = mysql_query($sql_simnames) or die(mysql_error());
	while ($row = mysql_fetch_row($results)) {
		$simnames[] = $row[0];
	}
?>
<?php echo '<?xml version="1.0" encoding="UTF-8"?>'."\n"; ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Primcrafters - All Sales</title>
<link rel="stylesheet" type="text/css" href="primcrafters.css" />
</head>
<body>
<p></p>
<div class="banner">
<h1>Primcrafters Sales Overview</h1>
<div class="section"><span class="section_title">Sales:</span> [<a class="section" href="index.php">Summary</a> | <a class="section" href="byavatar.php">Buyers</a> | <a class="section" href="byframe.php">Frames</a> | <a class="section" href="bysim.php">Sims</a> | All Sales]</div>
</div>
<div class="content">
<table>
<tr>
	<th>Date</th>
	<th>Buyer</th>
	<th>Frame</th>
	<th>Type</th>
	<th>Price</th>
	<th>Location</th>
</tr>
<?php
	$sql = "SELECT * FROM sales ORDER BY date DESC";
	$results = mysql_query($sql) or die(mysql_error());
	$num_rows = mysql_num_rows($results);

	$count = 0;
	while ($row = mysql_fetch_object($results)) {
?>
		<tr <?php if ($count % 2 == 0) echo 'class="even"'; else echo 'class="odd"'; ?>>
			<td><?php echo $row->date ?></td>
			<td><?php echo $row->buyer ?></td>
			<td><?php echo $row->frame ?></td>
			<td><?php echo $row->type ?></td>
			<td>L$<?php echo $row->price ?></td>
			<td><?php echo $row->sim ?></td>
		</tr>
<?php
		$count++;
	}
?>
</table>
</div>
<p style="clear: both; margin-top: 40px;">
  <span class="footything">&copy;2004 Allison (Cienna Rand)</span>
</p>
</body>
</html>

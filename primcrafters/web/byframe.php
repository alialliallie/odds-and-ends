<?php
	require "config.php";
	mysql_connect($db_server, $db_username, $db_password); 
	mysql_select_db($db_name);
	$sql_total = "SELECT SUM(price) AS total FROM sales;";
	$results = mysql_query($sql_total) or die(mysql_error());
	$row = mysql_fetch_row($results);
	$totalsales = $row[0];
?>
<?php echo '<?xml version="1.0" encoding="UTF-8"?>'."\n"; ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Primcrafters - Sales By Frame</title>
<link rel="stylesheet" type="text/css" href="primcrafters.css" />
</head>
<body>
<?php
	if (isset($_GET['framename']))
	{
		$simname = $_GET['framename'];
?>
<div class="banner">
<h1>Primcrafters Sales :: <?php echo $simname; ?></h1>
	<div class="section">
		<span class="section_title">Sales:</span> [<a class="section" href="index.php">Summary</a> | <a class="section" href="byavatar.php">Buyers</a> | Frames | <a class="section" href="bysim.php">Sims</a> | <a class="section" href="allsales.php">All Sales</a>]
		<p><a href="byframe.php">Back</a></p>
	</div>
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
		$sql = "SELECT * FROM sales WHERE frame='$framename' ORDER BY type, date DESC";
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
	}
	else
	{
?>
<div class="banner">
<h1>Primcrafters Sales By Frame</h1>
	<div class="section">
		<span class="section_title">Sales:</span> [<a class="section" href="index.php">Summary</a> | <a class="section" href="byavatar.php">Buyers</a> | Frames | <a class="section" href="bysim.php">Sims</a> | <a class="section" href="allsales.php">All Sales</a>]
	</div>
</div>
<div class="content">
<table>
<tr>
	<th>Frame</th>
	<th>Type</th>
	<th>Sales</th>
	<th>Earnings</th>
	<th style="text-align: right">Percentage</th>
</tr>
<?php
	$sql = "SELECT frame, type, SUM(price) AS total, COUNT(*) AS number FROM sales GROUP BY frame, type";
	$results = mysql_query($sql) or die(mysql_error());
	$num_rows = mysql_num_rows($results);

	$count = 0;
	while ($row = mysql_fetch_object($results)) {
?>
		<tr <?php if ($count % 2 == 0) echo 'class="even"'; else echo 'class="odd"'; ?>>
			<td><a href="byframe.php?framename=<?php echo $row->frame ?>"><?php echo $row->frame ?></a></td>
			<td><?php echo $row->type ?></td>
			<td><?php echo $row->number ?></td>
			<td>L$<?php echo $row->total ?></td>
			<td style="text-align: right"><?php printf("%.2f", round(($row->total / $totalsales) * 100, 2)); ?>%</td>
		</tr>
<?php
		$count++;
	}
	}
?>
</table>
</div>
<p style="clear: both; margin-top: 40px;">
  <span class="footything">&copy;2004 Allison (Cienna Rand)</span>
</p>
</body>
</html>

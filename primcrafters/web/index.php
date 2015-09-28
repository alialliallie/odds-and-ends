<?php echo '<?xml version="1.0" encoding="UTF-8"?>'."\n"; ?>
<?php
	require "config.php";
	mysql_connect($db_server, $db_username, $db_password); 
	mysql_select_db($db_name);
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Primcrafters</title>
<link rel="stylesheet" type="text/css" href="primcrafters.css"/>
</head>
<body>
<div class="banner">
<h1>Primcrafters</h1>
<div class="section"><span class="section_title">Sales:</span> [Summary | <a class="section" href="byavatar.php">Buyers</a> | <a class="section" href="byframe.php">Frames</a> | <a class="section" href="bysim.php">Sims</a> | <a class="section" href="allsales.php">All Sales</a>]</div>
</div>
<div class="content">
<div id="sales_totals">
<table>
<caption>Sales Totals</caption>
<tr><th>&nbsp;</th><th>Number</th><th>Total</th></tr>
<?php
	$sql_today_total = "SELECT COUNT(*) AS number, SUM(price) AS total FROM sales WHERE TO_DAYS(CURDATE()) = TO_DAYS(date)";
	$results = mysql_query($sql_today_total) or die(mysql_error());
	$row['Today'] = mysql_fetch_array($results);
	$sql_week_total = "SELECT COUNT(*) AS number, SUM(price) AS total FROM sales WHERE YEARWEEK(CURDATE()) = YEARWEEK(date)";
	$results = mysql_query($sql_week_total) or die(mysql_error());
	$row['This Week'] = mysql_fetch_array($results);
	$sql_month_total = "SELECT COUNT(*) AS number, SUM(price) AS total FROM sales WHERE MONTH(CURDATE()) = MONTH(date) AND YEAR(CURDATE()) = YEAR(date)";
	$results = mysql_query($sql_month_total) or die(mysql_error());
	$row['This Month'] = mysql_fetch_array($results);
	$sql_year_total = "SELECT COUNT(*) AS number, SUM(price) AS total FROM sales WHERE YEAR(CURDATE()) = YEAR(date)";
	$results = mysql_query($sql_year_total) or die(mysql_error());
	$row['This Year'] = mysql_fetch_array($results);
	$sql_all_total = "SELECT COUNT(*) AS number, SUM(price) AS total FROM sales";
	$results = mysql_query($sql_all_total) or die(mysql_error());
	$row['Total'] = mysql_fetch_array($results);

	$count = 0;
	foreach (array_keys($row) as $rkey) {
?>
		<tr> <?php if ($count % 2 == 0) $tdclass ="even"; else $tdclass ="odd"; ?>
			<td class="<?php echo $tdclass?>"><?php echo $rkey ?></td>
			<td class="<?php echo $tdclass?>"><?php echo $row[$rkey]['number'] ?></td>
			<td class="<?php echo $tdclass?>">L$<?php echo $row[$rkey]['total'] ?></td>
		</tr>
<?php
		$count++;
	}
?>
</table>
</div>
<div id="top_5_frames">
<table>
<caption>Top 5 Frames</caption>
<tr><th>Frame</th><th>Number</th><th>Total</th></tr>
<?php
	$sql_top_frames = "SELECT frame, SUM(price) AS total, COUNT(*) AS number FROM sales GROUP BY frame ORDER BY number DESC LIMIT 5";
	$results = mysql_query($sql_top_frames) or die(mysql_error());
	$count = 0;
	while ($row = mysql_fetch_object($results))
	{
?>
		<tr <?php if ($count % 2 == 0) echo 'class="even"'; else echo 'class="odd"'; ?>>
			<td><?php echo $row->frame ?></td>
			<td><?php echo $row->number ?></td>
			<td>L$<?php echo $row->total ?></td>
		</tr>
<?php
		$count++;
	}
?>
</table>
</div>
<div id="top_5_buyers">
<table>
<caption>Top 5 Buyers</caption>
<tr><th>Buyer</th><th>Number</th><th>Total</th></tr>
<?php
	$sql_top_frames = "SELECT buyer, SUM(price) AS total, COUNT(*) AS number FROM sales GROUP BY buyer ORDER BY number DESC, total DESC LIMIT 5";
	$results = mysql_query($sql_top_frames) or die(mysql_error());
	$count = 0;
	while ($row = mysql_fetch_object($results))
	{
?>
		<tr <?php if ($count % 2 == 0) echo 'class="even"'; else echo 'class="odd"'; ?>>
			<td><?php echo $row->buyer ?></td>
			<td><?php echo $row->number ?></td>
			<td>L$<?php echo $row->total ?></td>
		</tr>
<?php
		$count++;
	}
?>
</table>
</div>
<div id="last_5_sales">
<table style="width: 100%">
<caption>Last 5 Sales</caption>
<tr>
	<th>Date</th>
	<th>Buyer</th>
	<th>Frame</th>
	<th>Type</th>
	<th>Price</th>
	<th>Location</th>
</tr>
<?php
	$sql = "SELECT * FROM sales ORDER BY date DESC LIMIT 5";
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
</div>
<p style="clear: both; margin-top: 40px;">
  <a href="http://validator.w3.org/check?uri=referer"><img
	  src="http://www.w3.org/Icons/valid-xhtml11"
	  alt="Valid XHTML 1.1!" height="31" width="88"/></a>
  <span class="footything">&copy;2004 Allison (Cienna Rand)</span>
</p>
</body>
</html>

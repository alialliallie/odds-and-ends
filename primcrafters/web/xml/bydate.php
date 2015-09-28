<?php
	header("Content-type: text/xml; charset=utf-8");
	require "../config.php";
	mysql_connect($db_server, $db_username, $db_password); 
	mysql_select_db($db_name);
?>
<?php echo '<?xml version="1.0" encoding="UTF-8"?>' . "\n" ?>
<?php echo '<?xml-stylesheet href="bydate.xsl" type="text/xsl"?>' . "\n" ?>
<!DOCTYPE primcrafters SYSTEM "primcrafters.dtd">
<primcrafters>
<?php
	if (isset($_GET['limit'])) 
	{
		$count = $_GET['limit'];
	}
	else
	{
		$count = 5;
	}

	$limitSTR = " LIMIT $count"; 

	if (isset($_GET['offset'])) 
	{ 
		$nextN = $_GET['offset'];
		$limitSTR = " LIMIT $nextN, $count";
	}
	$sql = "SELECT * FROM sales ORDER BY date DESC" . $limitSTR;
	$results = mysql_query($sql) or die(mysql_error());
	$num_rows = mysql_num_rows($results);
?>
<?php
	$count = 0;
	while ($row = mysql_fetch_object($results)) 
	{
		$datetime = explode(" ", $row->date);
?>
	<sale>
		<name><?php echo $row->buyer?></name>
		<purchase>
			<frame><?php echo $row->frame ?></frame>
			<type><?php echo $row->type ?></type>
			<price><?php echo $row->price ?></price>
			<location><?php echo $row->sim ?></location>
			<date><?php echo $datetime[0] ?></date>
			<time><?php echo $datetime[1] ?></time>
		</purchase>
	</sale>
<?php
	}
?>
</primcrafters>

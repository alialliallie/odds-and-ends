<?php
	header("Content-type: text/xml; charset=utf-8");
	require "../config.php";
	mysql_connect($db_server, $db_username, $db_password); 
	mysql_select_db($db_name);
?>
<?php echo '<?xml version="1.0" encoding="UTF-8"?>'."\n"; ?>
<?php echo '<?xml-stylesheet href="buyer.xsl" type="text/xsl"?>' . "\n" ?>
<!DOCTYPE primcrafters SYSTEM "primcrafters.dtd">
<primcrafters>
<?php
	if (isset($_GET['avatar']))
	{
		$buyer = $_GET['avatar'];
		$sql = "SELECT * FROM sales WHERE buyer='$buyer' ORDER BY date DESC";
		$results = mysql_query($sql) or die(mysql_error());
		$num_rows = mysql_num_rows($results);
?>
	<buyer>
		<name><?php echo $buyer?></name>
<?php
		$count = 0;
		while ($row = mysql_fetch_object($results)) {
			$datetime = explode(" ", $row->date);
	?>
		<purchase>
			<frame><?php echo $row->frame ?></frame>
			<type><?php echo $row->type ?></type>
			<price><?php echo $row->price ?></price>
			<location><?php echo $row->sim ?></location>
			<date><?php echo $datetime[0] ?></date>
			<time><?php echo $datetime[1] ?></time>
		</purchase>
	<?php
			$count++;
		}
	}
	else
	{
		$buyer = "";
		$firstrow = true;
		$sql = "SELECT * FROM sales ORDER BY buyer ASC";
		$results = mysql_query($sql) or die(mysql_error());
		while ($row = mysql_fetch_object($results))
		{
			$datetime = explode(" ", $row->date);
			if (strcmp($buyer,$row->buyer) != 0)
			{
				$buyer = $row->buyer;
				if (!$firstrow)
				{
?>
	</buyer>
<?php
				}
?>
	<buyer>
		<name><?php echo $row->buyer ?></name>
<?php
			}
?>
		<purchase>
			<frame><?php echo $row->frame ?></frame>
			<type><?php echo $row->type ?></type>
			<price><?php echo $row->price ?></price>
			<location><?php echo $row->sim ?></location>
			<date><?php echo $datetime[0] ?></date>
			<time><?php echo $datetime[1] ?></time>
		</purchase>
<?php
			$firstrow = false;
		}
	}
?>
	</buyer>
</primcrafters>

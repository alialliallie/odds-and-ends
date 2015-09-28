<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable name="rowswitch" select="'1'"/>
	<xsl:template match="/primcrafters">
		<html>
			<head>
				<title>Primcrafters Sale Report</title>
				<link rel="stylesheet" type="text/css" href="../primcrafters.css"/>
			</head>
			<body>
				<xsl:for-each select="buyer">
					<xsl:apply-templates select="current()"/>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="buyer">
		<div>
			<h2><xsl:value-of select="name"/></h2>
				<table style="width: 50%">
					<tr>
						<th>Frame</th>
						<th>Type</th>
						<th>Price</th>
						<th>Location</th>
						<th>Date</th>
					</tr>
					<xsl:for-each select="purchase">
					<xsl:choose>
						<xsl:when test="(position() mod 2) = 1">
							<tr class="odd">
								<xsl:apply-templates select="current()"/>
							</tr>
						</xsl:when>
						<xsl:otherwise>
							<tr class="even">
								<xsl:apply-templates select="current()"/>
							</tr>
						</xsl:otherwise>
					</xsl:choose>
					</xsl:for-each>
				</table>
		</div>
	</xsl:template>

	<xsl:template match="purchase">
		<td><xsl:value-of select="frame"/></td>
		<td><xsl:value-of select="type"/></td>
		<td><xsl:value-of select="price"/></td>
		<td><xsl:value-of select="location"/></td>
		<td><xsl:value-of select="date"/> <xsl:value-of select="time"/></td>
	</xsl:template>
</xsl:stylesheet>

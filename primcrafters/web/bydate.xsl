<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable name="rowswitch" select="'1'"/>
	<xsl:template match="/primcrafters">
		<html>
			<head>
				<title>Primcrafters XML By Date</title>
				<link rel="stylesheet" type="text/css" href="../primcrafters.css"/>
			</head>
			<body>
				<table>
					<tr>
						<th>Name</th>
						<th>Frame</th>
						<th>Type</th>
						<th>Price</th>
						<th>Location</th>
						<th>Date</th>
					</tr>
					<xsl:for-each select="sale">
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
			</body>
		</html>
	</xsl:template>

	<xsl:template match="sale">
		<td><xsl:value-of select="name"/></td>
		<xsl:apply-templates select="purchase"/>
	</xsl:template>

	<xsl:template match="purchase">
		<td><xsl:value-of select="frame"/></td>
		<td><xsl:value-of select="type"/></td>
		<td><xsl:value-of select="price"/></td>
		<td><xsl:value-of select="location"/></td>
		<td><xsl:value-of select="date"/> <xsl:value-of select="time"/></td>
	</xsl:template>
</xsl:stylesheet>

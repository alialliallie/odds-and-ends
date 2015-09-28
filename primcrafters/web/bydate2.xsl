<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable name="rowswitch" select="'1'"/>
	<xsl:template match="/primcrafters">
		<table style="width: 100%">
		<caption>Browse Sales</caption>
		<tr>
			<th>Date</th>
			<th>Buyer</th>
			<th>Frame</th>
			<th>Type</th>
			<th>Price</th>
			<th>Location</th>
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
	</xsl:template>

	<xsl:template match="sale">
		<td><xsl:value-of select="purchase/date"/> <xsl:value-of select="purchase/time"/></td>
		<td><xsl:value-of select="name"/></td>
		<td><xsl:value-of select="purchase/frame"/></td>
		<td><xsl:value-of select="purchase/type"/></td>
		<td><xsl:value-of select="purchase/price"/></td>
		<td><xsl:value-of select="purchase/location"/></td>
	</xsl:template>
</xsl:stylesheet>

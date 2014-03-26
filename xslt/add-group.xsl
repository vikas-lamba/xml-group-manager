<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:c="urn:oasis:names:tc:entity:xmlns:xml:catalog"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output indent="yes"/>
    <xsl:key name="id" match="c:group" use="@id"/>

    <xsl:param name="group-id"/>
    <xsl:param name="xmlfile"/>

    <xsl:variable name="xmlfrag" select="document($xmlfile)"/>

    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="c:catalog">
        <xsl:copy>
            <xsl:apply-templates/>
            <xsl:choose>
                <xsl:when test="not(key('id', $group-id))">
                    <xsl:element name="group" namespace="urn:oasis:names:tc:entity:xmlns:xml:catalog">
                        <xsl:attribute name="id">
                            <xsl:value-of select="$group-id"/>
                        </xsl:attribute>
                        <xsl:apply-templates select="$xmlfrag/*/*"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message terminate="yes">Error: Group <xsl:value-of select="$group-id"/> alredy exists!</xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
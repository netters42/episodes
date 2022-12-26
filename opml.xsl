<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dcterms="http://purl.org/dc/terms/"
  extension-element-prefixes="str">

<xsl:template match="/opml">
  <html>
    <head>
      <title><xsl:value-of select="head/title"/></title>
      <meta http-equiv="content-type" content="text/html;charset=utf-8" />
      <meta name="HandheldFriendly" content="True"/>
      <meta name="MobileOptimized" content="320"/>
      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <xsl:choose>
        <xsl:when test="head/style">
          <link rel="stylesheet" href="{head/style}"/>
        </xsl:when>
        <xsl:otherwise>
          <link rel="stylesheet" href="oblox.css"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="head/additionalStyle">
          <style>
            <xsl:value-of select="head/additionalStyle"/>
          </style>
        </xsl:when>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="head/additionalHead">
          <xsl:value-of select="head/additionalHead" disable-output-escaping="yes"/>
        </xsl:when>
      </xsl:choose>
    </head>
    <body>
      <h1><span class='at'><xsl:value-of select="head/title"/></span></h1>
      <xsl:choose>
        <xsl:when test="head/logo">
          <img src="{head/logo}" width="96" style="margin: auto; display: block;">
          </img>
        </xsl:when>
      </xsl:choose>
      <xsl:apply-templates select="body/outline"/>
      <p class="footer"><xsl:value-of select="head/license"/> | <xsl:value-of select="head/copyleft"/></p>
      <div>
        <p style="float: left;  font-size: 10px;">Date modified: <xsl:value-of select="head/dateModified"/></p>
        <p style="float: right; font-size: 10px;"><a href="https://oblox.bsd.am/">Made with oblox</a></p>
      </div>
    </body>
  </html>
</xsl:template>
<xsl:template match="body/outline">
  <fieldset><legend><xsl:value-of select="@text"/></legend>
    <ul>
      <xsl:apply-templates select="outline"/>
    </ul>
  </fieldset>
</xsl:template>
<xsl:template match="outline">
  <li style="padding-bottom: 5px;">
    <xsl:choose>
      <xsl:when test="@url">
        <a href="{@url}"><xsl:value-of select="@text"/></a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@text" disable-output-escaping="yes"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="*">
        <ul class="text">
          <xsl:apply-templates select="outline"/>
        </ul>
      </xsl:when>
    </xsl:choose>
  </li>
</xsl:template>
</xsl:stylesheet>


<?xml version="1.0" encoding="utf-8"?>
<!--
	HTML2TWiki Translation v0.3
	http://elmuerte.com/html2twiki

HTML to TWiki markup XSLT
Copyright (C) 2006  Michiel Hendriks

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

http://www.gnu.org/licenses/lgpl.txt
-->
<!--
	TWiki formatting rules:
		http://twiki.org/cgi-bin/view/TWiki/TextFormattingRules
-->
<!--
	TODO:
	* use \ before newlines in content of list items
	* table support?
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="text" indent="no" />
	
	<xsl:preserve-space elements="*" />
	
	<xsl:template match="/html/body">
		<xsl:apply-templates select="node()" mode="twiki" />
	</xsl:template>

	<!-- normalize plain text -->
	<xsl:template match="text()" mode="twiki">
		<xsl:call-template name="normalize-inner">
			<!--<xsl:with-param name="str">
				<xsl:call-template name="compact-string">-->
					<xsl:with-param name="str" select="." />
				<!--</xsl:call-template>
			</xsl:with-param>-->
		</xsl:call-template>
	</xsl:template>
	
	<!-- headings -->
	<xsl:template match="h1" mode="twiki">
		<xsl:text>&#xA;---+ </xsl:text>
		<xsl:apply-templates select="node()" mode="twiki" />
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>
	
	<xsl:template match="h2" mode="twiki">
		<xsl:text>&#xA;---++ </xsl:text>
		<xsl:apply-templates select="node()" mode="twiki" />
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>
	
	<xsl:template match="h3" mode="twiki">
		<xsl:text>&#xA;---+++ </xsl:text>
		<xsl:apply-templates select="node()" mode="twiki" />
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>
	
	<xsl:template match="h4" mode="twiki">
		<xsl:text>&#xA;---++++ </xsl:text>
		<xsl:apply-templates select="node()" mode="twiki" />
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>
	
	<xsl:template match="h5" mode="twiki">
		<xsl:text>&#xA;---+++++ </xsl:text>
		<xsl:apply-templates select="node()" mode="twiki" />
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>
	
	<xsl:template match="h6" mode="twiki">
		<xsl:text>&#xA;---++++++ </xsl:text>
		<xsl:apply-templates select="node()" mode="twiki" />
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>
	
	<!-- simple horizontal rule -->
	<xsl:template match="hr" mode="twiki">
		<xsl:text>&#xA;---&#xA;</xsl:text>
	</xsl:template>
	
	<!-- various anchors -->
	<xsl:template match="a" mode="twiki">
		<xsl:if test="@name">
			<xsl:text>&#xA;#</xsl:text>
			<xsl:value-of select="@name" />
			<xsl:text>&#xA;</xsl:text>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="@href">
				<xsl:text>[[</xsl:text>
				<xsl:value-of select="@href" />
				<xsl:text>][</xsl:text>
				<xsl:apply-templates select="node()" mode="twiki" />
				<xsl:text>]]</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="node()" mode="twiki" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- keep the br tag -->
	<xsl:template match="br" mode="twiki">
		<xsl:text>&lt;br /&gt;</xsl:text>
	</xsl:template>

	<!-- append newlines to paragraphs -->	
	<xsl:template match="p" mode="twiki">
		<xsl:text>&#xA;&#xA;</xsl:text>
		<xsl:variable name="res">
			<xsl:apply-templates select="node()" mode="twiki" />
		</xsl:variable>
		<xsl:value-of select="normalize-space($res)" />
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>
	
	<!-- don't touch the content within pre tags, make it verbatim -->
	<xsl:template match="pre" mode="twiki">
		<xsl:text>&lt;verbatim&gt;</xsl:text>
		<!--<xsl:value-of select="node()" />-->
		<xsl:apply-templates select="." mode="as-is" />
		<xsl:text>&lt;/verbatim&gt; </xsl:text>
	</xsl:template>
	
	<!-- bold -->
	<xsl:template match="b | strong" mode="twiki">
		<xsl:choose>
			<xsl:when test="count(.) = 1 and i[last() = 1]">
				<xsl:call-template name="bold-italic"><xsl:with-param name="node" select="i" /></xsl:call-template>
			</xsl:when>
			<xsl:when test="count(.) = 1 and em[last() = 1]">
				<xsl:call-template name="bold-italic"><xsl:with-param name="node" select="em" /></xsl:call-template>
			</xsl:when>
			<xsl:when test="count(.) = 1 and code[last() = 1]">
				<xsl:call-template name="bold-code"><xsl:with-param name="node" select="code" /></xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>*</xsl:text>
				<xsl:variable name="res">
					<xsl:apply-templates select="node()" mode="twiki" />
				</xsl:variable>
				<xsl:value-of select="normalize-space($res)" /><!-- required for trimming leading and trailing spaces -->
				<xsl:text>*</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- italic -->
	<xsl:template match="i | em" mode="twiki">
		<xsl:choose>
			<xsl:when test="count(.) = 1 and b[last() = 1]">
				<xsl:call-template name="bold-italic"><xsl:with-param name="node" select="b" /></xsl:call-template>
			</xsl:when>
			<xsl:when test="count(.) = 1 and strong[last() = 1]">
				<xsl:call-template name="bold-italic"><xsl:with-param name="node" select="strong" /></xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>_</xsl:text>
				<xsl:variable name="res">
					<xsl:apply-templates select="node()" mode="twiki" />
				</xsl:variable>
				<xsl:value-of select="normalize-space($res)" /><!-- required for trimming leading and trailing spaces -->
				<xsl:text>_</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- code -->
	<xsl:template match="code" mode="twiki">
		<xsl:choose>
			<xsl:when test="count(.) = 1 and b[last() = 1]">
				<xsl:call-template name="bold-code"><xsl:with-param name="node" select="b" /></xsl:call-template>
			</xsl:when>
			<xsl:when test="count(.) = 1 and strong[last() = 1]">
				<xsl:call-template name="bold-code"><xsl:with-param name="node" select="strong" /></xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>=</xsl:text>
				<xsl:variable name="res">
					<xsl:apply-templates select="node()" mode="twiki" />
				</xsl:variable>
				<xsl:value-of select="normalize-space($res)" /><!-- required for trimming leading and trailing spaces -->
				<xsl:text>=</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- combination templates -->		
	<xsl:template name="bold-italic">
		<xsl:text>__</xsl:text>
		<xsl:variable name="res">
			<xsl:apply-templates select="*/* | */text()" mode="twiki" />
		</xsl:variable>
		<xsl:value-of select="normalize-space($res)" /><!-- required for trimming leading and trailing spaces -->
		<xsl:text>__</xsl:text>
	</xsl:template>
	
	<xsl:template name="bold-code">
		<xsl:text>==</xsl:text>
		<xsl:variable name="res">
			<xsl:apply-templates select="*/* | */text()" mode="twiki" />
		</xsl:variable>
		<xsl:value-of select="normalize-space($res)" /><!-- required for trimming leading and trailing spaces -->
		<xsl:text>==</xsl:text>
	</xsl:template>
	
	<!-- lists -->
	<xsl:template match="li" mode="twiki">
		<xsl:variable name="res">
			<xsl:apply-templates select="node()" mode="twiki" />
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="starts-with($res, '&#xA;')"><xsl:value-of select="$res" /></xsl:when>
			<xsl:otherwise>
				<xsl:text>&#xA;</xsl:text>
				<xsl:call-template name="string-repeat"><xsl:with-param name="str"><xsl:text>   </xsl:text></xsl:with-param><xsl:with-param name="cnt" select="count(ancestor::ul) + count(ancestor::ol)" /></xsl:call-template>
				<xsl:choose>
					<xsl:when test="name(..) = 'ul'"><xsl:text>* </xsl:text></xsl:when>
					<xsl:when test="name(..) = 'ol'">
						<xsl:choose>
							<xsl:when test="../@type">
								<xsl:value-of select="../@type" />
								<xsl:text>. </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>1. </xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise><xsl:text>? </xsl:text></xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="$res" />
			</xsl:otherwise>
		</xsl:choose>			
	</xsl:template>
	
	<xsl:template match="dt" mode="twiki">
		<xsl:text>&#xA;   $ </xsl:text>
		<xsl:variable name="term">
			<xsl:apply-templates select="node()" mode="twiki" />
		</xsl:variable>
		<xsl:value-of select="translate($term, ':', '')" /><!-- strip the colon -->
		<xsl:text>:</xsl:text>
	</xsl:template>
	
	<xsl:template match="dd" mode="twiki">
		<!-- fake the dt entry when it's missing -->
		<xsl:if test="name(preceding-sibling::*[position()=1]) != 'dt'"><xsl:text>&#xA;   $ &amp;nbsp;: </xsl:text></xsl:if>
		<xsl:apply-templates select="node()" mode="twiki" />
	</xsl:template>
	
	<xsl:template match="ol | ul | dl" mode="twiki">
		<xsl:apply-templates select="node()" mode="twiki" />
		<xsl:if test="(count(ancestor::ul) + count(ancestor::ol)) = 0">
			<xsl:text>&#xA;</xsl:text>
		</xsl:if>			
	</xsl:template>
	
	<!-- catch-all; return other tags as is -->
	<xsl:template match="*" mode="twiki" priority="-1">
		<xsl:choose>
			<!-- this is a node with content -->
			<xsl:when test="count(node()) > 0">
				<xsl:text>&lt;</xsl:text><xsl:value-of select="name(.)" />
				<xsl:call-template name="node-attributes" />
				<xsl:text>&gt;</xsl:text>
				<!-- node content -->
				<xsl:apply-templates select="node()" mode="twiki" />
				<xsl:text>&lt;/</xsl:text><xsl:value-of select="name(.)" /><xsl:text>&gt;</xsl:text>
			</xsl:when>
			<!-- this is a node without content -->
			<xsl:otherwise>
				<xsl:text>&lt;</xsl:text><xsl:value-of select="name(.)" />
				<xsl:call-template name="node-attributes" />
				<xsl:text>/&gt;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
	
	<!--
			Error checking; This shouldn't actually be needed, HTML needs ot be valid
	-->
	<!--
	<xsl:template match="
		h1//h2 | h1//h3 | h1//h4 | h1//h5 | h1//h6 |
		h2//h3 | h2//h4 | h2//h5 | h2//h6 |
		h3//h4 | h3//h5 | h3//h6 |
		h4//h4 | h4//h5 |
		h5//h6" mode="twiki">
		<xsl:message terminate="yes">
			<xsl:text>Invalid HTML: </xsl:text>
			<xsl:value-of select="." />
		</xsl:message>
	</xsl:template>
	-->
	
	<!-- 
			utility functions 
	-->
	
	<!-- string repeat -->
	<xsl:template name="string-repeat">
		<xsl:param name="str" />
		<xsl:param name="cnt" />
		<xsl:choose>
			<xsl:when test="$cnt = 1">
				<xsl:value-of select="$str" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="str2">
					<xsl:call-template name="string-repeat">
						<xsl:with-param name="str" select="$str"/>
						<xsl:with-param name="cnt" select="$cnt - 1"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="concat($str, $str2)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- change newline to br -->
	<xsl:template name="nl-to-br">
		<xsl:param name="str"/>
		<xsl:choose>
			<xsl:when test="contains($str, '&#xA;')">
				<xsl:value-of select="substring-before($str, '&#xA;')"/>
				<xsl:text>&lt;br /&gt;</xsl:text>
				<xsl:call-template name="nl-to-br">
					<xsl:with-param name="str" select="substring-after($str, '&#xA;')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$str"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- returns a node AS IS in text form -->
	<xsl:template match="*" mode="as-is">
		<xsl:for-each select="text() | *">
			<xsl:choose>
				<!-- this is a node with content -->
				<xsl:when test="name(.) and count(node()) > 0">
					<xsl:text>&lt;</xsl:text><xsl:value-of select="name(.)" />
					<xsl:call-template name="node-attributes" />
					<xsl:text>&gt;</xsl:text>
					<!-- node content -->
					<xsl:apply-templates select="." mode="as-is" />
					<xsl:text>&lt;/</xsl:text><xsl:value-of select="name(.)" /><xsl:text>&gt;</xsl:text>
				</xsl:when>
				<!-- this is a node without content -->
				<xsl:when test="name(.) and count(node()) = 0">
					<xsl:text>&lt;</xsl:text><xsl:value-of select="name(.)" />
					<xsl:call-template name="node-attributes" />
					<xsl:text>/&gt;</xsl:text>
				</xsl:when>
				<!-- normal text node -->
				<xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
			</xsl:choose>	
		</xsl:for-each>
	</xsl:template>
	
	<!-- return node attributes -->
	<xsl:template name="node-attributes">
		<xsl:for-each select="@*">
			<xsl:text> </xsl:text>
			<xsl:value-of select="name(.)" />
			<xsl:text>="</xsl:text>
			<xsl:call-template name="escape-quote">
				<xsl:with-param name="str" select="." />
			</xsl:call-template>
			<xsl:text>"</xsl:text>
		</xsl:for-each>
	</xsl:template>
	
	<!-- replace " with &quot; -->
	<xsl:template name="escape-quote">
		<xsl:param name="str"/>
		<xsl:choose>
			<xsl:when test="contains($str, '&quot;')">
				<xsl:value-of select="substring-before($str, '&quot;')"/>
				<xsl:text>&amp;quot;</xsl:text>
				<xsl:call-template name="escape-quote">
					<xsl:with-param name="str" select="substring-after($str, '&quot;')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$str"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	
	<!-- escape spaces -->
	<xsl:template name="escape-space">
		<xsl:param name="str"/>
		<xsl:choose>
			<xsl:when test="contains($str, ' ')">
				<xsl:value-of select="substring-before($str, ' ')"/>
				<xsl:text>&amp;nbsp;</xsl:text>
				<xsl:call-template name="escape-space">
					<xsl:with-param name="str" select="substring-after($str, ' ')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$str"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	
	<!-- trim-left; removes all whitespace at the beginning of a string; *obsolete* -->
	<!--  
	<xsl:template name="trim-left">
		<xsl:param name="str"/>
		<xsl:choose>
			<xsl:when test="starts-with($str, ' ')">
				<xsl:call-template name="trim-left">
					<xsl:with-param name="str" select="substring-after($str, ' ')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="starts-with($str, '&#xA;')">
				<xsl:call-template name="trim-left">
					<xsl:with-param name="str" select="substring-after($str, '&#xA;')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="starts-with($str, '&#xD;')">
				<xsl:call-template name="trim-left">
					<xsl:with-param name="str" select="substring-after($str, '&#xD;')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="starts-with($str, '&#9;')">
				<xsl:call-template name="trim-left">
					<xsl:with-param name="str" select="substring-after($str, '&#x9;')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$str"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	-->
	
	<!-- normalize-inner; normale space within a string and remain a whitespace and the begin and end when it was present -->
	<xsl:template name="normalize-inner">
		<xsl:param name="str"/>
		<xsl:variable name="tmp_str">
			<xsl:value-of select="translate($str, '&#9;&#xA;&#xD;', '   ')" /><!-- translate all to whitespace -->
		</xsl:variable>
		<xsl:variable name="begin">
			<xsl:if test="starts-with($tmp_str, ' ')">
				<xsl:text> </xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="middle">
			<xsl:value-of select="normalize-space($str)" />
		</xsl:variable>
		<xsl:variable name="end">
			<xsl:if test="substring($tmp_str, string-length($tmp_str), 1) = ' '">
				<xsl:text> </xsl:text>
			</xsl:if>
		</xsl:variable>
		
		<xsl:value-of select="$begin" />
		<xsl:if test="string-length(concat($begin, $middle, $end)) > 2">
			<xsl:value-of select="$middle" />
			<xsl:value-of select="$end" />			
		</xsl:if>
	</xsl:template>
	
	<!-- produces a compact string, trims newlines and whitespace after the newline -->
	<!--
	<xsl:template name="compact-string">
		<xsl:param name="str"/>
		<xsl:choose>
			<xsl:when test="contains($str, '&#xA;')">
				<xsl:value-of select="substring-before($str, '&#xA;')"/>
				<xsl:if test="string-length(substring-before($str, '&#xA;')) > 0"><xsl:text> </xsl:text></xsl:if>
				<xsl:call-template name="compact-string">
					<xsl:with-param name="str">
						<xsl:call-template name="trim-left">
							<xsl:with-param name="str" select="substring-after($str, '&#xA;')" />
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$str"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	-->
	
</xsl:stylesheet> 
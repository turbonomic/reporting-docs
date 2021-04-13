<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:transform
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">
    
    <xsl:output method="html"  indent="no"/>
    
    <xsl:template match="GeneratedDoc">
        <xsl:element name="html">
            <xsl:element name="head">
                <xsl:element name="title"><xsl:value-of select="@name" /></xsl:element>
            </xsl:element>
            <xsl:element name="body">
                <xsl:element name="h2">
                    <xsl:attribute name="class">genData</xsl:attribute>
                    <xsl:value-of select="@name" /><xsl:text> </xsl:text> <xsl:value-of select="@type" />
                </xsl:element>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!--
    <xsl:template match="Intro">
        <xsl:element name="p">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    -->
    
    <xsl:template match="Items">
        <xsl:choose>
            <xsl:when test="../@type='json_data'">
                <xsl:variable name="fieldContent" >
                    <xsl:for-each select="Item[1]/Field/@name">
                        <xsl:value-of select="."/>
                        <xsl:text> </xsl:text>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:element name="table"><xsl:element name="tbody">
                    <xsl:element name="tr">
                        <xsl:element name="th">
                            <xsl:text>JSON Object</xsl:text>
                        </xsl:element>
                        <xsl:for-each select="Item[1]/Field/@name">
                            <xsl:element name="th">
                                <xsl:value-of select="."/>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                    <xsl:apply-templates/>
                </xsl:element></xsl:element>
            </xsl:when>
            
            <xsl:when test="../@type='table'">
                <xsl:variable name="fieldContent" >
                    <xsl:for-each select="Item[1]/Field/@name">
                        <xsl:value-of select="."/>
                        <xsl:text> </xsl:text>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:element name="table"><xsl:element name="tbody">
                    <xsl:element name="tr">
                        <xsl:element name="th">
                            <xsl:element name="p">
                            <xsl:text>Column Name</xsl:text>
                            </xsl:element>
                        </xsl:element>
                        <xsl:for-each select="Item[1]/Field/@name">
                            <xsl:element name="th">
                                <xsl:element name="p">
                                <xsl:value-of select="."/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                    <xsl:apply-templates/>
                </xsl:element></xsl:element>
            </xsl:when>
            
            <xsl:when test="../@type='type'">
                <xsl:element name="ul">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <xsl:template match="Item">
        <xsl:choose>
            <xsl:when test="../../@type='json_data'">
                <xsl:element name="tr">
                    <xsl:element name="td">
                        <xsl:value-of select="@name" />
                    </xsl:element>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="../../@type='table'">
                <xsl:element name="tr">
                    <xsl:element name="td">
                        <xsl:element name="p">
                            <xsl:value-of select="@name" />
                        </xsl:element>
                    </xsl:element>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="../../@type='type'">
                <xsl:element name="li">
                    
                        <xsl:value-of select="@name" />
                    
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="Field">
        <xsl:choose>
            <xsl:when test="../../../@type='json_data'">
                <xsl:element name="td">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="../../../@type='table'">
                <xsl:element name="td">
                    <xsl:choose>
                        <xsl:when test="@name='Description'">
                            <xsl:apply-templates/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="p">
                                <xsl:apply-templates/>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:when>
             
            <xsl:when test="../../../@type='type'">
                <xsl:if test=". != ''">
                    <xsl:apply-templates/>
                </xsl:if>
            </xsl:when>
            
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="p">
        <xsl:element name="p">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="a">
        <xsl:element name="a">
            <xsl:attribute name="href"><xsl:value-of select="@href" /></xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    
</xsl:transform>

<!--
    <xsl:template match="Item">
        <xsl:element name="li">
            <xsl:element name="p">
                <xsl:value-of select="@name" />
            </xsl:element>
            <xsl:element name="ul">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="Field">
        <xsl:element name="li">
            <xsl:element name="p">
                <xsl:value-of select="@name" />
            </xsl:element>
            <xsl:element name="p">
                <xsl:apply-templates/>
            </xsl:element>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    -->

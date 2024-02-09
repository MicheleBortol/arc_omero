<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html"/>
  <xsl:param name="tempVal" select="none"/>

  <xsl:template match="/">
    <HTML>
      <HEAD>
        <TITLE>
          <xsl:value-of select="@Name"/>
        </TITLE>
      </HEAD>
      <BODY topmargin="0px" leftmargin="0px" bgcolor="#EEEEEE">
        <xsl:apply-templates select="Data"/>
      </BODY>
    </HTML>
  </xsl:template>

  <xsl:template match="Data">
    <xsl:apply-templates select ="Image/ImageDescription" />
    <xsl:apply-templates select ="Image/Attachment" />
  </xsl:template>

  <xsl:template match="Attachment">
    <xsl:apply-templates select ="HardwareSetting/FilterSetting" />
  </xsl:template>
  <xsl:template match="User-Comment">
  </xsl:template>

  <xsl:template name="break">
    <xsl:param name="text" select="//User-Comment"/>

    <xsl:comment>This inserts line breaks into the user description in place of line feeds</xsl:comment>

    <xsl:choose>
      <xsl:when test="contains($text, '&#xa;')">
        <xsl:value-of select="substring-before($text, '&#xa;')"/>
        <br/>
        <xsl:call-template name="break">
          <xsl:with-param name="text" select="substring-after($text,'&#xa;')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="ImageDescription">
    <TABLE width="98%" align="center" border="0" cellspacing="5" cellpadding="5" bgcolor="#DDDAD7">
      <TR>
        <TD>
          <TABLE width="100%" align="center" border="0" cellspacing="0" cellpadding="3" bgcolor="#FFFFFF" >
            <TR>
              <TD>
                <TABLE width="100%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD height="20" width="35%" >Image : </TD>
                    <TD>
                      <B>
                        <xsl:value-of select="Name"/>
                      </B>
                    </TD>
                  </TR>

                  <xsl:for-each select="//ScannerSetting/ScannerSettingRecord">
                    <xsl:if test="@Identifier='csScanMode'">
                      <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;">
                        <TD width="35%">Experiment type : </TD>
                        <TD >
                          <xsl:value-of select="@Variant"/>
                        </TD>
                      </TR>
                    </xsl:if>
                  </xsl:for-each>

                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="35%" >File name : </TD>
                    <TD>
                      <xsl:value-of select="FileLocation"/>
                    </TD>
                  </TR>
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="35%" >Size : </TD>
                    <TD>
                      <xsl:value-of select="Size"/>
                    </TD>
                  </TR>
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="35%" >Start Time : </TD>
                    <TD>
                      <xsl:value-of select="StartTime"/>
                    </TD>
                  </TR>
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="35%" >End Time : </TD>
                    <TD >
                      <xsl:value-of select="EndTime"/>
                    </TD>
                  </TR>
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="35%">Total Exposures : </TD>
                    <TD >
                      <xsl:value-of select="FrameCount"/>
                    </TD>
                  </TR>
                  <xsl:if test="//RelativeFocusCorrection != ' '">
                    <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                      <TD width="35%">Relative Focus Correction : </TD>
                      <TD >
                        <xsl:value-of select="RelativeFocusCorrection"/>
                      </TD>
                    </TR>
                  </xsl:if>
                </TABLE>
              </TD>
              <TD align="center" valign="top" rowspan="2">
                <A href="http://www.confocal-microscopy.com/" target="about:blank">
                  <IMG src="LeicaLogo.jpg" border="0" alt="Leica Microsystems Heidelberg GmbH"/>
                </A>
              </TD>
            </TR>
          </TABLE>
        </TD>
      </TR>
    </TABLE>


    <xsl:if test ="//User-Comment != ' '">
      <TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7">
        <TR>
          <TD>
            <TABLE topmargin="0" leftmargin="0" width="100%" align="center" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF">
              <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;">
                <TD colspan="2" width="35%">
                  <xsl:call-template name="break"/>
                </TD>
              </TR>
            </TABLE>
          </TD>
        </TR>
      </TABLE>
    </xsl:if>

    <BR/>
    <TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7">
      <TR>
        <TD>
          <TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF">
            <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: bold; color: 000000; padding: 3px;">
              <TD>Dimension</TD>
              <TD>Logical Size</TD>
              <TD>Physical Length</TD>
              <TD>Physical Origin</TD>
              <TD>Voxel Size</TD>
            </TR>
            <xsl:for-each select="Dimensions/DimensionDescription">
              <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                <TD>
                  <xsl:value-of select="@DimID"/>
                </TD>
                <TD>
                  <xsl:value-of select="@NumberOfElements"/> &nbsp; <xsl:value-of select="@LogicalUnit"/>
                </TD>
                <TD>
                  <xsl:value-of select="@Length"/> &nbsp;<xsl:value-of select="@Unit"/>
                </TD>
                <TD>
                  <xsl:value-of select="@Origin"/> &nbsp;<xsl:value-of select="@Unit"/>
                </TD>
                <TD>
                  <xsl:value-of select="@Voxel"/> &nbsp;<xsl:value-of select="@Unit"/>
                </TD>
              </TR>
            </xsl:for-each>

          </TABLE>
        </TD>
      </TR>
    </TABLE>

    <BR/>

    <xsl:variable name='isStereoTLFinetuningBase'>
      <xsl:comment>Variable for display Stereo TLBase Finetuning-Settings</xsl:comment>
      <xsl:for-each select="//ScannerSettingRecord">
        <xsl:if test="@Identifier='IsStereoTLFinetuningBase'">
          <xsl:value-of select="@Variant"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7">
      <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;">
        <TD colspan="2">
          <TABLE topmargin="0" leftmargin="0" width="100%" align="center" border="1" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
            <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;">
              <TD width="20%">
                <xsl:for-each select="//ScannerSetting/ScannerSettingRecord[@Identifier='nWFChannelCount']">
                  <b>
                    Channels used : &nbsp; <xsl:value-of select="@Variant"/>
                  </b>
                </xsl:for-each>
              </TD>
              <TD width="20%">
                <b>Name </b>
              </TD>
              <TD width="15%">
                <b>Cube </b>
              </TD>
              <TD width="15%">
                <b>Contrast Method </b>
              </TD>

              <xsl:if test="$isStereoTLFinetuningBase != '1'">
                <TD width="7%">
                  <b>Intensity </b>
                </TD>
              </xsl:if>

              <TD width="8%">
                <b>Peak Emission </b>
              </TD>
              <TD width="9%">
                <b>Peak Excitation </b>
              </TD>
            </TR>
            <xsl:for-each select="//FluoDescription/FluoDescriptionRecord">
              <xsl:variable name="MyCounter" select="position()-1"/>
              <xsl:variable name="WFCPrefix">nWFC</xsl:variable>
              <xsl:variable name="StereoChannelTLBasePrefix">
                <xsl:value-of select="concat($WFCPrefix, $MyCounter)"/>
              </xsl:variable>
              <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;">
                <TD>
                  <xsl:value-of select="@Identifier"/>
                </TD>
                <TD>
                  <xsl:value-of select="@Name"/>
                </TD>
                <TD>
                  <xsl:value-of select="@Cube"/> &nbsp;
                </TD>
                <TD>
                  <xsl:value-of select="@Contrast"/>
                </TD>

                <xsl:if test="$isStereoTLFinetuningBase != '1'">
                  <TD>
                    <xsl:value-of select="@Intensity"/>
                  </TD>
                </xsl:if>

                <TD>
                  <xsl:value-of select="@Emission"/> &nbsp; nm
                </TD>
                <TD>
                  <xsl:value-of select="@Excitation"/>&nbsp; nm
                </TD>
              </TR>
            </xsl:for-each>
          </TABLE>
        </TD>
      </TR>
    </TABLE>

    <BR/>

    <xsl:variable name='isColorCamera'>
      <xsl:for-each select="//ScannerSettingRecord">
        <xsl:if test="@Identifier='bIsColour'">
          <xsl:value-of select="@Variant"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7">
      <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;">
        <TD colspan="2">
          <TABLE topmargin="0" leftmargin="0" width="100%" align="center" border="1" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
            <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;">
              <TD width="15%">
                <b>Channel Name </b>
              </TD>
              <TD width="15%">
                <b>LUT Name </b>
              </TD>
              <TD width="15%">
                <b>Exposure Time </b>
              </TD>
              <TD width="15%">
                <b>Gain </b>
              </TD>
              <xsl:if test="//Channels/ChannelDescription2[@EMGain!='']">
                <TD width="15%">
                  <b>EM Gain</b>
                </TD>
              </xsl:if>
              <xsl:if test="//Channels/ChannelDescription2[@RFCZPos!='']">
                <TD width="15%">
                  <b>Focus Position</b>
                </TD>
              </xsl:if>
              <xsl:if test="$isColorCamera = '1'">
                <TD width="15%">
                  <b>Color-Gain Mode</b>
                </TD>
              </xsl:if>
            </TR>
            <xsl:for-each select="//Channels/ChannelDescription2">
              <xsl:variable name="MyCounter" select="position()-1"/>
              <xsl:variable name="WFCPrefix">nWFC</xsl:variable>
              <xsl:variable name="nColorGainMode">
                <xsl:value-of select="concat($WFCPrefix, $MyCounter,'ColorGainMode')"/>
              </xsl:variable>
              <xsl:variable name="nColorGainValueR">
                <xsl:value-of select="concat($WFCPrefix, $MyCounter,'ColorGainValueR')"/>
              </xsl:variable>
              <xsl:variable name="nColorGainValueG">
                <xsl:value-of select="concat($WFCPrefix, $MyCounter,'ColorGainValueG')"/>
              </xsl:variable>
              <xsl:variable name="nColorGainValueB">
                <xsl:value-of select="concat($WFCPrefix, $MyCounter,'ColorGainValueB')"/>
              </xsl:variable>
              <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;">
                <TD>
                  <xsl:value-of select="@Name"/>
                </TD>
                <TD>
                  <xsl:value-of select="@LutName"/>
                </TD>
                <TD>
                  <xsl:value-of select="@Exposure"/>
                </TD>
                <TD>
                  <xsl:value-of select="@Gain"/>
                </TD>
                <xsl:if test="//Channels/ChannelDescription2[@EMGain!='']">
                  <TD>
                    <xsl:value-of select="@EMGain"/>
                  </TD>
                </xsl:if>
                <xsl:if test="//Channels/ChannelDescription2[@RFCZPos!='']">
                  <TD>
                    <xsl:value-of select="@RFCZPos"/>
                  </TD>
                </xsl:if>
                <xsl:if test="$isColorCamera = '1'">
                  <xsl:for-each select="//ScannerSettingRecord">
                    <xsl:if test="@Identifier=$nColorGainMode">
                      <TD>
                        <xsl:choose>
                          <xsl:when test="@Variant = '0'">
                            Manual setup (
                          </xsl:when>
                          <xsl:when test="@Variant = '1'">
                            Autom. WhiteBalance (
                          </xsl:when>
                          <xsl:when test="@Variant = '2'">
                            No control, default (
                          </xsl:when>
                          <xsl:otherwise>
                            Undefined
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:for-each select="//ScannerSettingRecord">
                          <xsl:if test="@Identifier=$nColorGainValueR">
                            R:<xsl:value-of select="@Variant"/> -
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="//ScannerSettingRecord">
                          <xsl:if test="@Identifier=$nColorGainValueG">
                            G:<xsl:value-of select="@Variant"/> -
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="//ScannerSettingRecord">
                          <xsl:if test="@Identifier=$nColorGainValueB">
                            B:<xsl:value-of select="@Variant"/>
                          </xsl:if>
                        </xsl:for-each>
                        )
                      </TD>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:if>
              </TR>
            </xsl:for-each>
          </TABLE>
        </TD>
      </TR>
    </TABLE>


    <xsl:if test="//Channels/ChannelDescription3">
      <HR width="98%"></HR>
      <TABLE width="98%" align="center" border="0" cellspacing="5" cellpadding="5">
        <TR>
          <TD align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
            <b>Fast Filter Wheels</b>
          </TD>
        </TR>
      </TABLE>

      <TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7">
        <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;">
          <TD colspan="2">
            <TABLE topmargin="0" leftmargin="0" width="100%" align="center" border="1" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
              <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;">
                <TD width="20%">
                  <b>Channel Name </b>
                </TD>
                <TD width="20%">
                  <b>Emission1 </b>
                </TD>
                <TD width="20%">
                  <b>Emission2</b>
                </TD>
                <TD width="20%">
                  <b>Excitation1</b>
                </TD>
                <TD width="20%">
                  <b>Excitation2 </b>
                </TD>
              </TR>
              <xsl:for-each select="//Channels/ChannelDescription3">
                <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;">
                  <TD>
                    <xsl:value-of select="@Name"/>
                  </TD>
                  <TD>
                    <xsl:value-of select="@FFWEmission1"/>
                  </TD>
                  <TD>
                    <xsl:value-of select="@FFWEmission2"/>
                  </TD>
                  <TD>
                    <xsl:value-of select="@FFWExcitation1"/>
                  </TD>
                  <TD>
                    <xsl:value-of select="@FFWExcitation2"/>
                  </TD>
                </TR>
              </xsl:for-each>
            </TABLE>
          </TD>
        </TR>
      </TABLE>
    </xsl:if>

    <xsl:variable name='isILLEDAvailable'>
      <xsl:comment>Variable for ILLED-Settings available</xsl:comment>
      <xsl:for-each select="//ScannerSettingRecord">
        <xsl:if test="@Identifier='ILLEDMaxWavelengths' and @Variant > '0'">1</xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <xsl:if test="$isILLEDAvailable = '1'">
      <HR width="98%"></HR>
      <TABLE width="98%" align="center" border="0" cellspacing="5" cellpadding="5">
        <TR>
          <TD align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
            <b>IL-LED Illumination</b>
          </TD>
        </TR>
      </TABLE>

      <TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7">
        <TR>
          <TD>
            <TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF">
              <xsl:for-each select="//ScannerSettingRecord">

                <xsl:if test="@Identifier='ILLEDCodedSliderPos'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">IL-LED Manual Slider Pos.</TD>
                    <xsl:choose>
                      <xsl:when test="@Variant = '0'">
                        <TD>Lamp</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '1'">
                        <TD>LED</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '2'">
                        <TD>Mixed mode ( Lamp + LED )</TD>
                      </xsl:when>
                      <xsl:otherwise>
                        <TD>undefined</TD>
                      </xsl:otherwise>
                    </xsl:choose>
                  </TR>
                </xsl:if>

                <xsl:if test="@Identifier='ILLEDMaxWavelengths'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">IL-LED Wavelengths</TD>
                    <TD>
                      <xsl:for-each select="//ScannerSettingRecord">
                        <xsl:if test="@Identifier='ILLEDWavelength0' and @Variant > '0'">
                          <xsl:value-of select="@Variant"/>nm,
                        </xsl:if>
                        <xsl:if test="@Identifier='ILLEDWavelength1' and @Variant > '0'">
                          <xsl:value-of select="@Variant"/>nm,
                        </xsl:if>
                        <xsl:if test="@Identifier='ILLEDWavelength2' and @Variant > '0'">
                          <xsl:value-of select="@Variant"/>nm,
                        </xsl:if>
                        <xsl:if test="@Identifier='ILLEDWavelength3' and @Variant > '0'">
                          <xsl:value-of select="@Variant"/>nm,
                        </xsl:if>
                        <xsl:if test="@Identifier='ILLEDWavelength4' and @Variant > '0'">
                          <xsl:value-of select="@Variant"/>nm
                        </xsl:if>
                      </xsl:for-each>
                    </TD>
                  </TR>
                </xsl:if>

              </xsl:for-each>
            </TABLE>
          </TD>
        </TR>
      </TABLE>

      <TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7">
        <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;">
          <TD>
            <TABLE topmargin="0" leftmargin="0" width="100%" align="center" border="1" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
              <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;">
                <TD width="25%">
                  <b>Channel Name</b>
                </TD>
                <TD>
                  <xsl:for-each select="//ScannerSettingRecord">
                    <xsl:if test="@Identifier='ILLEDWavelength0'">
                      <xsl:choose>
                        <xsl:when test="@Variant > '0'">
                          <b>
                            <xsl:value-of select="@Variant"/>nm
                          </b>
                        </xsl:when>
                        <xsl:otherwise>-</xsl:otherwise>
                      </xsl:choose>
                    </xsl:if>
                  </xsl:for-each>
                </TD>
                <TD>
                  <xsl:for-each select="//ScannerSettingRecord">
                    <xsl:if test="@Identifier='ILLEDWavelength1'">
                      <xsl:choose>
                        <xsl:when test="@Variant > '0'">
                          <b>
                            <xsl:value-of select="@Variant"/>nm
                          </b>
                        </xsl:when>
                        <xsl:otherwise>-</xsl:otherwise>
                      </xsl:choose>
                    </xsl:if>
                  </xsl:for-each>
                </TD>
                <TD>
                  <xsl:for-each select="//ScannerSettingRecord">
                    <xsl:if test="@Identifier='ILLEDWavelength2'">
                      <xsl:choose>
                        <xsl:when test="@Variant > '0'">
                          <b>
                            <xsl:value-of select="@Variant"/>nm
                          </b>
                        </xsl:when>
                        <xsl:otherwise>-</xsl:otherwise>
                      </xsl:choose>
                    </xsl:if>
                  </xsl:for-each>
                </TD>
                <TD>
                  <xsl:for-each select="//ScannerSettingRecord">
                    <xsl:if test="@Identifier='ILLEDWavelength3'">
                      <xsl:choose>
                        <xsl:when test="@Variant > '0'">
                          <b>
                            <xsl:value-of select="@Variant"/>nm
                          </b>
                        </xsl:when>
                        <xsl:otherwise>-</xsl:otherwise>
                      </xsl:choose>
                    </xsl:if>
                  </xsl:for-each>
                </TD>
                <TD>
                  <xsl:for-each select="//ScannerSettingRecord">
                    <xsl:if test="@Identifier='ILLEDWavelength4'">
                      <xsl:choose>
                        <xsl:when test="@Variant > '0'">
                          <b>
                            <xsl:value-of select="@Variant"/>nm
                          </b>
                        </xsl:when>
                        <xsl:otherwise>-</xsl:otherwise>
                      </xsl:choose>
                    </xsl:if>
                  </xsl:for-each>
                </TD>
              </TR>

              <xsl:for-each select="//FluoDescription/FluoDescriptionRecord">
                <xsl:variable name="MyCounter" select="position()-1"/>
                <xsl:variable name="WFCPrefix">nWFC</xsl:variable>

                <xsl:variable name="ActiveStateVariableLED0">
                  <xsl:value-of select="concat($WFCPrefix, $MyCounter,'ILLEDActiveState0')"/>
                </xsl:variable>
                <xsl:variable name="ActiveStateVariableLED1">
                  <xsl:value-of select="concat($WFCPrefix, $MyCounter,'ILLEDActiveState1')"/>
                </xsl:variable>
                <xsl:variable name="ActiveStateVariableLED2">
                  <xsl:value-of select="concat($WFCPrefix, $MyCounter,'ILLEDActiveState2')"/>
                </xsl:variable>
                <xsl:variable name="ActiveStateVariableLED3">
                  <xsl:value-of select="concat($WFCPrefix, $MyCounter,'ILLEDActiveState3')"/>
                </xsl:variable>
                <xsl:variable name="ActiveStateVariableLED4">
                  <xsl:value-of select="concat($WFCPrefix, $MyCounter,'ILLEDActiveState4')"/>
                </xsl:variable>

                <xsl:variable name="IntensityVariableLED0">
                  <xsl:value-of select="concat($WFCPrefix, $MyCounter,'ILLEDIntensity0')"/>
                </xsl:variable>
                <xsl:variable name="IntensityVariableLED1">
                  <xsl:value-of select="concat($WFCPrefix, $MyCounter,'ILLEDIntensity1')"/>
                </xsl:variable>
                <xsl:variable name="IntensityVariableLED2">
                  <xsl:value-of select="concat($WFCPrefix, $MyCounter,'ILLEDIntensity2')"/>
                </xsl:variable>
                <xsl:variable name="IntensityVariableLED3">
                  <xsl:value-of select="concat($WFCPrefix, $MyCounter,'ILLEDIntensity3')"/>
                </xsl:variable>
                <xsl:variable name="IntensityVariableLED4">
                  <xsl:value-of select="concat($WFCPrefix, $MyCounter,'ILLEDIntensity4')"/>
                </xsl:variable>

                <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;">
                  <TD>
                    <xsl:value-of select="@Identifier"/>
                  </TD>
                  <TD>
                    <xsl:for-each select="//ScannerSettingRecord">
                      <xsl:if test="@Identifier=$ActiveStateVariableLED0">
                        <xsl:choose>
                          <xsl:when test="@Variant = '0'">-</xsl:when>
                          <xsl:when test="@Variant > '0'">
                            <xsl:for-each select="//ScannerSettingRecord">
                              <xsl:if test="@Identifier=$IntensityVariableLED0">
                                <xsl:value-of select="@Variant"/>%
                              </xsl:if>
                            </xsl:for-each>
                          </xsl:when>
                          <xsl:otherwise>-</xsl:otherwise>
                        </xsl:choose>
                      </xsl:if>
                    </xsl:for-each>
                  </TD>

                  <TD>
                    <xsl:for-each select="//ScannerSettingRecord">
                      <xsl:if test="@Identifier=$ActiveStateVariableLED1">
                        <xsl:choose>
                          <xsl:when test="@Variant = '0'">-</xsl:when>
                          <xsl:when test="@Variant > '0'">
                            <xsl:for-each select="//ScannerSettingRecord">
                              <xsl:if test="@Identifier=$IntensityVariableLED1">
                                <xsl:value-of select="@Variant"/>%
                              </xsl:if>
                            </xsl:for-each>
                          </xsl:when>
                          <xsl:otherwise>-</xsl:otherwise>
                        </xsl:choose>
                      </xsl:if>
                    </xsl:for-each>
                  </TD>

                  <TD>
                    <xsl:for-each select="//ScannerSettingRecord">
                      <xsl:if test="@Identifier=$ActiveStateVariableLED2">
                        <xsl:choose>
                          <xsl:when test="@Variant = '0'">-</xsl:when>
                          <xsl:when test="@Variant > '0'">
                            <xsl:for-each select="//ScannerSettingRecord">
                              <xsl:if test="@Identifier=$IntensityVariableLED2">
                                <xsl:value-of select="@Variant"/>%
                              </xsl:if>
                            </xsl:for-each>
                          </xsl:when>
                          <xsl:otherwise>-</xsl:otherwise>
                        </xsl:choose>
                      </xsl:if>
                    </xsl:for-each>
                  </TD>

                  <TD>
                    <xsl:for-each select="//ScannerSettingRecord">
                      <xsl:if test="@Identifier=$ActiveStateVariableLED3">
                        <xsl:choose>
                          <xsl:when test="@Variant = '0'">-</xsl:when>
                          <xsl:when test="@Variant > '0'">
                            <xsl:for-each select="//ScannerSettingRecord">
                              <xsl:if test="@Identifier=$IntensityVariableLED3">
                                <xsl:value-of select="@Variant"/>%
                              </xsl:if>
                            </xsl:for-each>
                          </xsl:when>
                          <xsl:otherwise>-</xsl:otherwise>
                        </xsl:choose>
                      </xsl:if>
                    </xsl:for-each>
                  </TD>

                  <TD>
                    <xsl:for-each select="//ScannerSettingRecord">
                      <xsl:if test="@Identifier=$ActiveStateVariableLED4">
                        <xsl:choose>
                          <xsl:when test="@Variant = '0'">-</xsl:when>
                          <xsl:when test="@Variant > '0'">
                            <xsl:for-each select="//ScannerSettingRecord">
                              <xsl:if test="@Identifier=$IntensityVariableLED4">
                                <xsl:value-of select="@Variant"/>%
                              </xsl:if>
                            </xsl:for-each>
                          </xsl:when>
                          <xsl:otherwise>-</xsl:otherwise>
                        </xsl:choose>
                      </xsl:if>
                    </xsl:for-each>
                  </TD>

                </TR>
              </xsl:for-each>
            </TABLE>
          </TD>
        </TR>
      </TABLE>

    </xsl:if>

    <xsl:for-each select="//FilterSetting/FilterSettingRecord[@Attribute='XPos' and @ClassName='CXYZStage']">
      <xsl:comment>don't show this if stage positioning is not used" </xsl:comment>
      <BR/>

      <TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7">
        <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;">
          <TD colspan="2">
            <TABLE topmargin="0" leftmargin="0" width="100%" align="center" border="1" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
              <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: bold; color: 000000; padding: 3px;">
                <TD width="40%">Stage Position</TD>
                <TD width="20%">X</TD>
                <TD width="20%">Y</TD>
                <TD width="20%">Z</TD>
              </TR>

              <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;">
                <TD width="20%">Origin</TD>
                <xsl:for-each select="//FilterSetting/FilterSettingRecord[@Attribute='XPosOrigin' and @ClassName='CXYZStage']">
                  <TD>
                    <xsl:value-of select="@Variant"/> &nbsp;<xsl:value-of select="@Unit"/>
                  </TD>
                </xsl:for-each>
                <xsl:for-each select="//FilterSetting/FilterSettingRecord[@Attribute='YPosOrigin' and @ClassName='CXYZStage']">
                  <TD>
                    <xsl:value-of select="@Variant"/> &nbsp;<xsl:value-of select="@Unit"/>
                  </TD>
                </xsl:for-each>
                <xsl:for-each select="//FilterSetting/FilterSettingRecord[@Attribute='ZPosOrigin' and @ClassName='CXYZStage']">
                  <TD>
                    <xsl:value-of select="@Variant"/> &nbsp;<xsl:value-of select="@Unit"/>
                  </TD>
                </xsl:for-each>
              </TR>
              <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;">
                <TD width="20%">Position</TD>
                <xsl:for-each select="//FilterSetting/FilterSettingRecord[@Attribute='XPos' and @ClassName='CXYZStage']">
                  <TD>
                    <xsl:value-of select="@Variant"/> &nbsp;<xsl:value-of select="@Unit"/>
                  </TD>
                </xsl:for-each>
                <xsl:for-each select="//FilterSetting/FilterSettingRecord[@Attribute='YPos' and @ClassName='CXYZStage']">
                  <TD>
                    <xsl:value-of select="@Variant"/> &nbsp;<xsl:value-of select="@Unit"/>
                  </TD>
                </xsl:for-each>
                <xsl:for-each select="//FilterSetting/FilterSettingRecord[@Attribute='ZPos' and @ClassName='CXYZStage']">
                  <TD>
                    <xsl:value-of select="@Variant"/> &nbsp;<xsl:value-of select="@Unit"/>
                  </TD>
                </xsl:for-each>
              </TR>
            </TABLE>
          </TD>
        </TR>
      </TABLE>
    </xsl:for-each>

  </xsl:template>

  <xsl:template match="FilterSetting">
    <HR width="98%"></HR>
    <TABLE width="98%" align="center" border="0" cellspacing="5" cellpadding="5">
      <TR>
        <TD align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
          <b>Camera Settings</b>
        </TD>
      </TR>
    </TABLE>
    <TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7">
      <TR>
        <TD>
          <TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF">

            <xsl:for-each select="//FilterSettingRecord">
              <xsl:if test="@ClassName='CFolderHardwareTree'">
                <xsl:if test="@Attribute='System_Number'">
                  <TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">
                      <xsl:value-of select="@Description"/>
                    </TD>
                    <TD >
                      <xsl:value-of select="@Variant"/>
                    </TD>
                  </TR>
                </xsl:if>
              </xsl:if>
            </xsl:for-each>

            <xsl:for-each select="//ScannerSettingRecord">

              <xsl:if test="@Identifier='CameraName'">
                <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                  <TD width="40%">
                    Camera:
                  </TD>
                  <TD >
                    <xsl:value-of select="@Variant"/>
                  </TD>
                </TR>
              </xsl:if>
              <xsl:if test="@Identifier='eBinning'">
                <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                  <TD width="40%">
                    <xsl:value-of select="@Description"/>
                  </TD>
                  <xsl:choose>
                    <xsl:when test="@Variant = '2001'">
                      <TD>2x2 pr</TD>
                    </xsl:when>
                    <xsl:when test="@Variant = '2002'">
                      <TD>2x2 R</TD>
                    </xsl:when>
                    <xsl:when test="@Variant = '2003'">
                      <TD>2x2 G</TD>
                    </xsl:when>
                    <xsl:when test="@Variant = '2004'">
                      <TD>2x2 B</TD>
                    </xsl:when>
                    <xsl:otherwise>
                      <TD >
                        <xsl:value-of select="@Variant"/> x <xsl:value-of select="@Variant"/>
                      </TD>
                    </xsl:otherwise>
                  </xsl:choose>
                </TR>
              </xsl:if>
              <xsl:if test="@Identifier='nBrightnessCorrection'">
                <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                  <TD width="40%">Brightness Correction</TD>
                  <xsl:choose>
                    <xsl:when test="@Variant = '0'">
                      <TD>OFF</TD>
                    </xsl:when>
                    <xsl:when test="@Variant = '1'">
                      <TD>ON</TD>
                    </xsl:when>
                    <xsl:otherwise>
                      <TD>Undefined</TD>
                    </xsl:otherwise>
                  </xsl:choose>
                </TR>
              </xsl:if>
              <xsl:if test="@Identifier='nBit'">
                <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                  <TD width="40%">
                    <xsl:value-of select="@Description"/>
                  </TD>
                  <TD >
                    <xsl:value-of select="@Variant"/>  &nbsp; bits
                  </TD>
                </TR>
              </xsl:if>
              <xsl:if test="@Identifier='dblGamma'">
                <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                  <TD width="40%">
                    <xsl:value-of select="@Description"/>
                  </TD>
                  <TD >
                    <xsl:value-of select="@Variant"/>
                  </TD>
                </TR>
              </xsl:if>
              <xsl:if test="@Identifier='nCameraDualLighMode'">
                <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                  <TD width="40%">Dual light mode</TD>
                  <xsl:choose>
                    <xsl:when test="@Variant = '0'">
                      <TD>NIR mode</TD>
                    </xsl:when>
                    <xsl:when test="@Variant = '1'">
                      <TD>Standard mode</TD>
                    </xsl:when>
                    <xsl:otherwise>
                      <TD>Undefined</TD>
                    </xsl:otherwise>
                  </xsl:choose>
                </TR>
              </xsl:if>
              <xsl:if test="@Identifier='nCameraColorCaptureMode'">
                <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                  <TD width="40%">Color Capture Mode</TD>
                  <xsl:choose>
                    <xsl:when test="@Variant = '0'">
                      <TD>Composite</TD>
                    </xsl:when>
                    <xsl:when test="@Variant = '1'">
                      <TD>R-Channel only</TD>
                    </xsl:when>
                    <xsl:when test="@Variant = '2'">
                      <TD>G-Channel only</TD>
                    </xsl:when>
                    <xsl:when test="@Variant = '3'">
                      <TD>B-Channel only</TD>
                    </xsl:when>
                    <xsl:otherwise>
                      <TD>Undefined</TD>
                    </xsl:otherwise>
                  </xsl:choose>
                </TR>
              </xsl:if>
              <xsl:if test="@Identifier='nBlackValue'">
                <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                  <TD width="40%">
                    <xsl:value-of select="@Description"/>
                  </TD>
                  <TD >
                    <xsl:value-of select="@Variant"/>
                  </TD>
                </TR>
              </xsl:if>
              <xsl:if test="@Identifier='nWhiteValue'">
                <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                  <TD width="40%">
                    <xsl:value-of select="@Description"/>
                  </TD>
                  <TD >
                    <xsl:value-of select="@Variant"/>
                  </TD>
                </TR>
              </xsl:if>
              <xsl:if test="@Identifier='OnlineShadingCorrection'">
                <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                  <TD width="40%">Online Shading Correction</TD>
                  <xsl:choose>
                    <xsl:when test="@Variant = '0'">
                      <TD>OFF</TD>
                    </xsl:when>
                    <xsl:when test="@Variant = '1'">
                      <TD>ON</TD>
                    </xsl:when>
                    <xsl:otherwise>
                      <TD>Undefined</TD>
                    </xsl:otherwise>
                  </xsl:choose>
                </TR>
              </xsl:if>
            </xsl:for-each>

            <xsl:for-each select="//Data/Image/Attachment[@Name='Lost Frame Info']/Info">
              <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                <TD width="40%">
                  Lost Frame Detected
                </TD>
                <TD>
                  <xsl:choose>
                    <xsl:when test="@LostFrameDetected = '0'">NO</xsl:when>
                    <xsl:when test="@LostFrameDetected = '1'">YES</xsl:when>
                  </xsl:choose>
                </TD>
              </TR>
              <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                <TD width="40%">
                  Lost Sequence Detected
                </TD>
                <TD>
                  <xsl:choose>
                    <xsl:when test="@LostSequenceDetected = '0'">NO</xsl:when>
                    <xsl:when test="@LostSequenceDetected = '1'">YES</xsl:when>
                  </xsl:choose>
                </TD>
              </TR>
            </xsl:for-each>
          </TABLE>
        </TD>
      </TR>
    </TABLE>

    <xsl:variable name='isACFActive'>
      <xsl:comment>Variable for display Advanced-Camera-Features-Settings</xsl:comment>
      <xsl:for-each select="//ScannerSettingRecord">
        <xsl:if test="@Identifier='Advanced_Camera_Features_Activated'">
          <xsl:choose>
            <xsl:when test="@Variant = '0'">0</xsl:when>
            <xsl:when test="@Variant = '1'">1</xsl:when>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <xsl:if test="$isACFActive = '1'">

      <HR width="98%"></HR>
      <TABLE width="98%" align="center" border="0" cellspacing="5" cellpadding="5">
        <TR>
          <TD align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
            <b>Advanced Camera Features</b>
          </TD>
        </TR>
      </TABLE>

      <TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7">
        <TR>
          <TD>
            <TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF">

              <xsl:for-each select="//ScannerSettingRecord">

                <xsl:if test="contains(@Description,'Enabled')">
                  <xsl:if test="@Variant = '1'">

                    <xsl:if test="contains(following-sibling::*/@Description,'Value')">
                      <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                        <TD width="40%">
                          <xsl:value-of select="following-sibling::*/@Description" />
                        </TD>

                        <xsl:variable name='ACFValue'>
                          <xsl:value-of select="following-sibling::*/@Variant" />
                        </xsl:variable>

                        <xsl:choose>
                          <xsl:when test="$ACFValue = ''">
                            <TD>
                              Enabled
                            </TD>
                          </xsl:when>
                          <xsl:otherwise>
                            <TD>
                              <xsl:value-of select="following-sibling::*/@Variant" />
                            </TD>
                          </xsl:otherwise>
                        </xsl:choose>
                      </TR>
                    </xsl:if>

                  </xsl:if>
                </xsl:if>

              </xsl:for-each>

            </TABLE>
          </TD>
        </TR>
      </TABLE>

    </xsl:if>

    <xsl:variable name='isStereoTLFinetuningBase'>
      <xsl:comment>Variable for display Stereo TLBase Finetuning-Settings</xsl:comment>
      <xsl:for-each select="//ScannerSettingRecord">
        <xsl:if test="@Identifier='IsStereoTLFinetuningBase'">
          <xsl:value-of select="@Variant"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <xsl:if test="$isStereoTLFinetuningBase = '1'">

      <HR width="98%"></HR>
      <TABLE width="98%" align="center" border="0" cellspacing="5" cellpadding="5">
        <TR>
          <TD align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
            <b>Illumination Settings</b>
          </TD>
        </TR>
      </TABLE>

      <TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7">
        <TR>
          <TD>
            <TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF">

              <xsl:for-each select="//FluoDescription/FluoDescriptionRecord">
                <xsl:variable name="MyCounter" select="position()-1"/>
                <xsl:variable name="WFCPrefix">WFC</xsl:variable>
                <xsl:variable name="ChannelPrefix">
                  <xsl:value-of select="concat($WFCPrefix, $MyCounter)"/>
                </xsl:variable>

                <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: bold; color: 000000; padding: 3px;">
                  <TD>
                    Channel <xsl:value-of select="$MyCounter" />
                  </TD>
                </TR>
                <TR>
                  <TD>
                    <TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF">

                      <xsl:for-each select="//ScannerSettingRecord">
                        <xsl:if test="contains(@Identifier,concat($ChannelPrefix,'StereoTLZoomApertureControlMode'))">
                          <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                            <TD width="40%">
                              TL Zoom Aperture Control Mode
                            </TD>
                            <xsl:choose>
                              <xsl:when test="@Variant = '0'">
                                <TD>Off</TD>
                              </xsl:when>
                              <xsl:when test="@Variant = '1'">
                                <TD>On</TD>
                              </xsl:when>
                              <xsl:otherwise>
                                <TD>Undefined</TD>
                              </xsl:otherwise>
                            </xsl:choose>
                          </TR>
                        </xsl:if>
                        <xsl:if test="contains(@Identifier,concat($ChannelPrefix,'StereoTLContrastMode'))">
                          <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                            <TD width="40%">
                              TL Contrast Mode
                            </TD>
                            <xsl:choose>
                              <xsl:when test="@Variant = '1'">
                                <TD>TL-BF</TD>
                              </xsl:when>
                              <xsl:when test="@Variant = '2'">
                                <TD>TL-RC</TD>
                              </xsl:when>
                              <xsl:when test="@Variant = '3'">
                                <TD>TL-DF</TD>
                              </xsl:when>
                              <xsl:otherwise>
                                <TD>Undefined</TD>
                              </xsl:otherwise>
                            </xsl:choose>
                          </TR>
                        </xsl:if>
                        <xsl:if test="contains(@Identifier,concat($ChannelPrefix,'StereoTLBase_Position'))">
                          <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                            <TD width="40%">
                              TL Position
                            </TD>
                            <TD>
                              <xsl:value-of select="@Variant" />
                            </TD>
                          </TR>
                        </xsl:if>
                        <xsl:if test="contains(@Identifier,concat($ChannelPrefix,'StereoTLBase_Aperture'))">
                          <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                            <TD width="40%">
                              TL Aperture
                            </TD>
                            <TD>
                              <xsl:value-of select="@Variant" />
                            </TD>
                          </TR>
                        </xsl:if>
                        <xsl:if test="contains(@Identifier,'Light-Intensity_FREE') and contains(@Identifier, $ChannelPrefix)">
                          <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                            <TD width="40%">
                              <xsl:value-of select="@Description" />
                            </TD>
                            <TD>
                              <xsl:value-of select="@Variant" />
                            </TD>
                          </TR>
                        </xsl:if>
                        <xsl:if test="contains(@Identifier,'Shutter_FREE') and contains(@Identifier, $ChannelPrefix)">
                          <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                            <TD width="40%">
                              <xsl:value-of select="@Description" />
                            </TD>
                            <xsl:choose>
                              <xsl:when test="@Variant = '0'">
                                <TD>Closed</TD>
                              </xsl:when>
                              <xsl:when test="@Variant = '1'">
                                <TD>Open</TD>
                              </xsl:when>
                              <xsl:otherwise>
                                <TD>Undefined</TD>
                              </xsl:otherwise>
                            </xsl:choose>
                          </TR>
                        </xsl:if>
                      </xsl:for-each>
                    </TABLE>
                  </TD>
                </TR>
              </xsl:for-each>
            </TABLE>
          </TD>
        </TR>
      </TABLE>

    </xsl:if>



    <xsl:variable name='isAutoFocusHSActive'>
      <xsl:comment>Variable for display AutoFocusHS-Settings</xsl:comment>
      <xsl:for-each select="//ScannerSettingRecord">
        <xsl:if test="@Identifier='bAutoFocusHSActive'">1</xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name='ShowOnlyForAutoFocusHS'>
      <xsl:for-each select="//ScannerSettingRecord">
        <xsl:if test="@Identifier='eAFHSSubsystem'">
          <xsl:choose>
            <xsl:when test="@Variant = '0'">1</xsl:when>
            <xsl:when test="@Variant = '3'">1</xsl:when>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name='ShowXYTSettingsForAutoFocusHS'>
      <xsl:for-each select="//ScannerSettingRecord">
        <xsl:if test="@Identifier='eAFHSSubsystem'">
          <xsl:choose>
            <xsl:when test="@Variant = '1'">1</xsl:when>
            <xsl:when test="@Variant = '3'">1</xsl:when>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name='ShowAFCPositionForAutoFocusHSMode'>
      <xsl:comment>Variable for display AFCPosition</xsl:comment>
      <xsl:for-each select="//ScannerSettingRecord">
        <xsl:if test="@Identifier='eAFHSSubsystem'">
          <xsl:choose>
            <xsl:when test="@Variant = '1'">
              <xsl:for-each select="//ScannerSettingRecord">
                <xsl:if test="@Identifier='dblAFHSAFCOffset' and @Variant >= '0'">1</xsl:if>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="@Variant = '3'">
              <xsl:for-each select="//ScannerSettingRecord">
                <xsl:if test="@Identifier='dblAFHSAFCOffset' and @Variant >= '0'">1</xsl:if>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>



    <xsl:if test="$isAutoFocusHSActive = '1'">
      <HR width="98%"></HR>
      <TABLE width="98%" align="center" border="0" cellspacing="5" cellpadding="5">
        <TR>
          <TD align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
            <b>Autofocus Settings</b>
          </TD>
        </TR>
      </TABLE>
      <TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7">
        <TR>
          <TD>
            <TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF">
              <xsl:for-each select="//ScannerSettingRecord">

                <xsl:if test="@Identifier='eAFHSSubsystem'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">Autofocus-Subsystem</TD>
                    <xsl:choose>
                      <xsl:when test="@Variant = '0'">
                        <TD>Highspeed Autofocus</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '1'">
                        <TD>Adaptive Focus Control</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '2'">
                        <TD>Continuous Adaptive Focus Control</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '3'">
                        <TD>Adaptive Focus Control + Highspeed Autofocus</TD>
                      </xsl:when>
                      <xsl:otherwise>
                        <TD>Undefined</TD>
                      </xsl:otherwise>
                    </xsl:choose>
                  </TR>
                </xsl:if>

                <xsl:if test="$ShowAFCPositionForAutoFocusHSMode = '1'">
                  <xsl:if test="@Identifier='dblAFHSAFCOffset'">
                    <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                      <TD width="40%">AFC Position</TD>
                      <TD>
                        <xsl:value-of select="@Variant"/>
                      </TD>
                    </TR>
                  </xsl:if>
                </xsl:if>

                <xsl:if test="@Identifier='eAFHSConfigMode' and $ShowOnlyForAutoFocusHS='1'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">Configuration-Mode</TD>
                    <xsl:choose>
                      <xsl:when test="@Variant = '0'">
                        <TD>Userdefined</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '1'">
                        <TD>Optimized</TD>
                      </xsl:when>
                      <xsl:otherwise>
                        <TD>Undefined</TD>
                      </xsl:otherwise>
                    </xsl:choose>
                  </TR>
                </xsl:if>

                <xsl:if test="@Identifier='eAFHSOperationMode' and $ShowOnlyForAutoFocusHS='1'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">Capture range</TD>
                    <xsl:choose>
                      <xsl:when test="@Variant = '0'">
                        <TD>Local</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '1'">
                        <TD>Global</TD>
                      </xsl:when>
                      <xsl:otherwise>
                        <TD>undefined</TD>
                      </xsl:otherwise>
                    </xsl:choose>
                  </TR>
                </xsl:if>

                <xsl:if test="@Identifier='nAFHSRangeLocal' and $ShowOnlyForAutoFocusHS='1'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">Local range</TD>
                    <TD >
                      <xsl:value-of select="@Variant"/>
                      microns
                    </TD>
                  </TR>
                </xsl:if>

                <xsl:if test="@Identifier='nAFHSRangeGlobal' and $ShowOnlyForAutoFocusHS='1'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">Global range</TD>
                    <TD >
                      <xsl:value-of select="@Variant"/>
                      microns
                    </TD>
                  </TR>
                </xsl:if>

                <xsl:if test="@Identifier='nAFHSPrecision' and $ShowOnlyForAutoFocusHS='1'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">Precision</TD>
                    <TD >
                      <xsl:value-of select="@Variant"/>
                    </TD>
                  </TR>
                </xsl:if>

                <xsl:if test="@Identifier='eAFHSZUseMode' and $ShowOnlyForAutoFocusHS='1'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">Focus-Device</TD>
                    <xsl:choose>
                      <xsl:when test="@Variant = '1'">
                        <TD>Galvo</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '2'">
                        <TD>Z-Wide</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '4'">
                        <TD>FineFocus</TD>
                      </xsl:when>
                      <xsl:otherwise>
                        <TD>undefined</TD>
                      </xsl:otherwise>
                    </xsl:choose>
                  </TR>
                </xsl:if>

                <xsl:if test="@Identifier='eAFHSWorkflowTimelapse' and $ShowXYTSettingsForAutoFocusHS='1'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">Workflow - Timelapse</TD>
                    <xsl:choose>
                      <xsl:when test="@Variant = '1'">
                        <TD>Execute first time only</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '2'">
                        <TD>Execute on all times</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '3'">
                        <TD>
                          <xsl:text>Execute every </xsl:text>
                          <xsl:for-each select="//ScannerSettingRecord">
                            <xsl:if test="@Identifier='nAFHSWorkflowTimelapseIterator'">
                              <xsl:value-of select="@Variant"/>
                            </xsl:if>
                          </xsl:for-each>
                          <xsl:text> times</xsl:text>
                        </TD>
                      </xsl:when>
                      <xsl:otherwise>
                        <TD>undefined</TD>
                      </xsl:otherwise>
                    </xsl:choose>
                  </TR>
                </xsl:if>

                <xsl:if test="@Identifier='eAFHSWorkflowXY' and $ShowXYTSettingsForAutoFocusHS='1'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">Workflow - Stage positions</TD>
                    <xsl:choose>
                      <xsl:when test="@Variant = '1'">
                        <TD>Execute on first position only</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '2'">
                        <TD>Execute on all positions</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '3'">
                        <TD>
                          <xsl:text>Execute every </xsl:text>
                          <xsl:for-each select="//ScannerSettingRecord">
                            <xsl:if test="@Identifier='nAFHSWorkflowXYIterator'">
                              <xsl:value-of select="@Variant"/>
                            </xsl:if>
                          </xsl:for-each>
                          <xsl:text> positions</xsl:text>
                        </TD>
                      </xsl:when>
                      <xsl:otherwise>
                        <TD>undefined</TD>
                      </xsl:otherwise>
                    </xsl:choose>
                  </TR>
                </xsl:if>

                <xsl:if test="@Identifier='bAFHSCameranRoiIsUsed' and $ShowOnlyForAutoFocusHS='1'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">Use ROI</TD>
                    <xsl:choose>
                      <xsl:when test="@Variant = '0'">
                        <TD>no</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '1'">
                        <TD>yes</TD>
                      </xsl:when>
                      <xsl:otherwise>
                        <TD>undefined</TD>
                      </xsl:otherwise>
                    </xsl:choose>
                  </TR>
                </xsl:if>

              </xsl:for-each>
            </TABLE>
          </TD>
        </TR>
      </TABLE>


    </xsl:if>
    <p> </p>



    <xsl:variable name='isBestFocusActive'>
      <xsl:comment>Variable for display BestFocus-Settings</xsl:comment>
      <xsl:for-each select="//ScannerSettingRecord">
        <xsl:if test="@Identifier='bIsSeriesScanAutofocusActive' and @Variant='1'">1</xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name='ShowOnlyForBestFocus'>
      <xsl:for-each select="//ScannerSettingRecord">
        <xsl:if test="@Identifier='eAFSubsystem'">
          <xsl:choose>
            <xsl:when test="@Variant = '0'">1</xsl:when>
            <xsl:when test="@Variant = '3'">1</xsl:when>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name='ShowXYTSettingsForBestFocus'>
      <xsl:for-each select="//ScannerSettingRecord">
        <xsl:if test="@Identifier='eAFSubsystem'">
          <xsl:choose>
            <xsl:when test="@Variant = '1'">1</xsl:when>
            <xsl:when test="@Variant = '3'">1</xsl:when>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name='ShowAFCPositionForBestFocusMode'>
      <xsl:comment>Variable for display AFCPosition</xsl:comment>
      <xsl:for-each select="//ScannerSettingRecord">
        <xsl:if test="@Identifier='eAFSubsystem'">
          <xsl:choose>
            <xsl:when test="@Variant = '1'">
              <xsl:for-each select="//ScannerSettingRecord">
                <xsl:if test="@Identifier='dblAFCOffset' and @Variant >= '0'">1</xsl:if>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="@Variant = '3'">
              <xsl:for-each select="//ScannerSettingRecord">
                <xsl:if test="@Identifier='dblAFCOffset' and @Variant >= '0'">1</xsl:if>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <xsl:if test="$isBestFocusActive = '1'">
      <HR width="98%"></HR>
      <TABLE width="98%" align="center" border="0" cellspacing="5" cellpadding="5">
        <TR>
          <TD align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
            <b>Autofocus Settings</b>
          </TD>
        </TR>
      </TABLE>
      <TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7">
        <TR>
          <TD>
            <TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF">

              <xsl:for-each select="//ScannerSettingRecord">

                <xsl:if test="@Identifier='eAFSubsystem'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">Autofocus-Subsystem</TD>
                    <xsl:choose>
                      <xsl:when test="@Variant = '0'">
                        <TD>Best Focus</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '1'">
                        <TD>Adaptive Focus Control</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '2'">
                        <TD>Continuous Adaptive Focus Control</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '3'">
                        <TD>Adaptive Focus Control + Best Focus</TD>
                      </xsl:when>
                      <xsl:otherwise>
                        <TD>Undefined</TD>
                      </xsl:otherwise>
                    </xsl:choose>
                  </TR>
                </xsl:if>

                <xsl:if test="$ShowAFCPositionForBestFocusMode = '1'">
                  <xsl:if test="@Identifier='dblAFCOffset'">
                    <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                      <TD width="40%">AFC Position</TD>
                      <TD>
                        <xsl:value-of select="@Variant"/>
                      </TD>
                    </TR>
                  </xsl:if>
                </xsl:if>

                <xsl:if test="@Identifier='nAFPrecision' and $ShowOnlyForBestFocus = '1'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">Precision</TD>
                    <TD >
                      <xsl:value-of select="@Variant"/>
                    </TD>
                  </TR>
                </xsl:if>

                <xsl:if test="@Identifier='dblAFFocusRange' and $ShowOnlyForBestFocus = '1'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">Focus Range</TD>
                    <TD >
                      <xsl:value-of select="@Variant * 1000000"/>
                      microns
                    </TD>
                  </TR>
                </xsl:if>

                <xsl:if test="@Identifier='eAFZUseMode' and $ShowOnlyForBestFocus = '1'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">Focus-Device</TD>
                    <xsl:choose>
                      <xsl:when test="@Variant = '1'">
                        <TD>Galvo</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '2'">
                        <TD>Z-Wide</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '4'">
                        <TD>FineFocus</TD>
                      </xsl:when>
                      <xsl:otherwise>
                        <TD>undefined</TD>
                      </xsl:otherwise>
                    </xsl:choose>
                  </TR>
                </xsl:if>

                <xsl:if test="@Identifier='eAFAnalyseType' and $ShowOnlyForBestFocus = '1'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">Analyse Type</TD>
                    <xsl:choose>
                      <xsl:when test="@Variant = '1'">
                        <TD>Contrast Based Method 1</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '2'">
                        <TD>Intensity Based Method</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '3'">
                        <TD>Noise Based Method</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '4'">
                        <TD>Contrast Based Method 2</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '5'">
                        <TD>Reflection Based Method</TD>
                      </xsl:when>
                      <xsl:otherwise>
                        <TD>undefined</TD>
                      </xsl:otherwise>
                    </xsl:choose>
                  </TR>
                </xsl:if>

                <xsl:if test="@Identifier='eAFWorkflowTimelapse' and $ShowXYTSettingsForBestFocus='1'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">Workflow - Timelapse</TD>
                    <xsl:choose>
                      <xsl:when test="@Variant = '1'">
                        <TD>Execute first time only</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '2'">
                        <TD>Execute on all times</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '3'">
                        <TD>
                          <xsl:text>Execute every </xsl:text>
                          <xsl:for-each select="//ScannerSettingRecord">
                            <xsl:if test="@Identifier='nAFWorkflowTimelapseIterator'">
                              <xsl:value-of select="@Variant"/>
                            </xsl:if>
                          </xsl:for-each>
                          <xsl:text> times</xsl:text>
                        </TD>
                      </xsl:when>
                      <xsl:otherwise>
                        <TD>undefined</TD>
                      </xsl:otherwise>
                    </xsl:choose>
                  </TR>
                </xsl:if>

                <xsl:if test="@Identifier='eAFWorkflowXY' and $ShowXYTSettingsForBestFocus='1'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">Workflow - Stage positions</TD>
                    <xsl:choose>
                      <xsl:when test="@Variant = '1'">
                        <TD>Execute on first position only</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '2'">
                        <TD>Execute on all positions</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '3'">
                        <TD>
                          <xsl:text>Execute every </xsl:text>
                          <xsl:for-each select="//ScannerSettingRecord">
                            <xsl:if test="@Identifier='nAFWorkflowXYIterator'">
                              <xsl:value-of select="@Variant"/>
                            </xsl:if>
                          </xsl:for-each>
                          <xsl:text> positions</xsl:text>
                        </TD>
                      </xsl:when>
                      <xsl:otherwise>
                        <TD>undefined</TD>
                      </xsl:otherwise>
                    </xsl:choose>
                  </TR>
                </xsl:if>

                <xsl:if test="@Identifier='bAFUseFixSliceNumber' and @Variant='1'">
                  <xsl:for-each select="//ScannerSettingRecord">
                    <xsl:if test="@Identifier='nAFFixSliceNumber' and $ShowOnlyForBestFocus = '1'">
                      <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                        <TD width="40%">Slice Number</TD>
                        <TD >
                          <xsl:value-of select="@Variant"/>
                        </TD>
                      </TR>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:if>

              </xsl:for-each>
            </TABLE>
          </TD>
        </TR>
      </TABLE>


    </xsl:if>
    <p> </p>


    <xsl:variable name='isTirf'>
      <xsl:comment>Variable for display TIRF-Settings</xsl:comment>
      <xsl:for-each select="//ScannerSettingRecord">
        <xsl:if test="@Identifier='TIRFManualMode'">1</xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name='isTirfChannelAvailable'>
      <xsl:for-each select="//FluoDescription/FluoDescriptionRecord">
        <xsl:if test = "@Contrast = 'TIRF'">
          1
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name='TirfManualMode'>
      <xsl:for-each select="//ScannerSettingRecord">
        <xsl:if test="@Identifier='TIRFManualMode'">
          <xsl:value-of select="@Variant"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name='ShowTIRFFastIlluminationSwitchingMode'>
      <xsl:for-each select="//ScannerSettingRecord">
        <xsl:if test="@Identifier='IsTIRFFastIlluminationSwitchingActive'">
          <xsl:value-of select="@Variant"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <xsl:if test="$isTirf = '1' and $isTirfChannelAvailable != '' ">
      <HR width="98%"></HR>

      <TABLE width="98%" align="center" border="0" cellspacing="5" cellpadding="5">
        <TR>
          <TD align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
            <b>TIRF Settings</b>
          </TD>
        </TR>
      </TABLE>

      <TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7">
        <TR>
          <TD>
            <TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF">
              <xsl:for-each select="//ScannerSettingRecord">

                <xsl:if test="@Identifier='TIRFManualMode'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">TIRF Mode</TD>
                    <xsl:choose>
                      <xsl:when test="@Variant = '1'">
                        <TD>Expert  Mode</TD>
                      </xsl:when>
                      <xsl:otherwise>
                        <TD>Automatic Mode</TD>
                      </xsl:otherwise>
                    </xsl:choose>
                  </TR>
                </xsl:if>

                <xsl:if test="@Identifier='eTIRFPenetrationDepthMode'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">TIRF Penetration Depth Mode</TD>
                    <xsl:choose>
                      <xsl:when test="@Variant = '0'">
                        <TD>Fast</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '1'">
                        <TD>Variable</TD>
                      </xsl:when>
                      <xsl:when test="@Variant = '2'">
                        <TD>Const</TD>
                      </xsl:when>
                      <xsl:otherwise>
                        <TD>Undefined</TD>
                      </xsl:otherwise>
                    </xsl:choose>
                  </TR>
                </xsl:if>

              </xsl:for-each>
            </TABLE>
          </TD>
        </TR>
      </TABLE>

      <TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7">
        <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;">
          <TD>
            <TABLE topmargin="0" leftmargin="0" width="100%" align="center" border="1" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
              <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;">
                <TD width="20%">
                  <b>Channel Name</b>
                </TD>
                <TD>
                  <b>Wavelength</b>
                </TD>
                <TD>
                  <b>Laser Intensity</b>
                </TD>
                <TD>
                  <b>PenetrationDepth</b>
                </TD>
                <TD>
                  <xsl:choose>
                    <xsl:when test="$TirfManualMode = '1'">
                      <b>Aperture</b>
                    </xsl:when>
                    <xsl:otherwise>
                      <b>PenetrationDepth-Index</b>
                    </xsl:otherwise>
                  </xsl:choose>
                </TD>
                <TD>
                  <b>Azimuth</b>
                </TD>
                <xsl:if test="$ShowTIRFFastIlluminationSwitchingMode = '1'">
                  <TD>
                    <b>Fast Illum.Switching Mode</b>
                  </TD>
                </xsl:if>
              </TR>

              <xsl:for-each select="//FluoDescription/FluoDescriptionRecord">
                <xsl:variable name="MyCounter" select="position()-1"/>
                <xsl:variable name="WFCPrefix">nWFC</xsl:variable>
                <xsl:variable name="WFCPostfix">TIRF</xsl:variable>
                <xsl:variable name="TIRFChannelPrefix">
                  <xsl:value-of select="concat($WFCPrefix, $MyCounter, $WFCPostfix)"/>
                </xsl:variable>


                <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;">
                  <TD>
                    <xsl:value-of select="@Identifier"/>
                  </TD>

                  <TD>
                    <xsl:for-each select="//ScannerSettingRecord">
                      <xsl:variable name="TIRFChannel_WaveLength">
                        <xsl:value-of select="concat($TIRFChannelPrefix, '_WaveLength')"/>
                      </xsl:variable>
                      <xsl:if test="@Identifier=$TIRFChannel_WaveLength">
                        <xsl:value-of select="@Variant"/>nm
                      </xsl:if>
                    </xsl:for-each>
                  </TD>

                  <TD>
                    <xsl:for-each select="//ScannerSettingRecord">
                      <xsl:variable name="TIRFChannel_LaserIntensity">
                        <xsl:value-of select="concat($TIRFChannelPrefix, '_LaserIntensity')"/>
                      </xsl:variable>
                      <xsl:if test="@Identifier=$TIRFChannel_LaserIntensity">
                        <xsl:value-of select="@Variant"/>%
                      </xsl:if>
                    </xsl:for-each>
                  </TD>

                  <TD>
                    <xsl:for-each select="//ScannerSettingRecord">
                      <xsl:variable name="TIRFChannel_PenetrationDepth">
                        <xsl:value-of select="concat($TIRFChannelPrefix, '_PenetrationDepth')"/>
                      </xsl:variable>
                      <xsl:if test="@Identifier=$TIRFChannel_PenetrationDepth">
                        <xsl:value-of select="@Variant"/>nm
                      </xsl:if>
                    </xsl:for-each>
                  </TD>

                  <TD>
                    <xsl:choose>
                      <xsl:when test="$TirfManualMode = '1'">
                        <xsl:for-each select="//ScannerSettingRecord">
                          <xsl:variable name="TIRFChannel_Aperture">
                            <xsl:value-of select="concat($TIRFChannelPrefix, '_Aperture')"/>
                          </xsl:variable>
                          <xsl:if test="@Identifier=$TIRFChannel_Aperture">
                            <xsl:value-of select="@Variant"/>
                          </xsl:if>
                        </xsl:for-each>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:for-each select="//ScannerSettingRecord">
                          <xsl:variable name="TIRFChannel_PenetrationDepthIndex">
                            <xsl:value-of select="concat($TIRFChannelPrefix, '_PenetrationDepthIndex')"/>
                          </xsl:variable>
                          <xsl:if test="@Identifier=$TIRFChannel_PenetrationDepthIndex">
                            <xsl:value-of select="@Variant"/>
                          </xsl:if>
                        </xsl:for-each>
                      </xsl:otherwise>
                    </xsl:choose>
                  </TD>

                  <TD>
                    <xsl:for-each select="//ScannerSettingRecord">
                      <xsl:variable name="TIRFChannel_Azimuth">
                        <xsl:value-of select="concat($TIRFChannelPrefix, '_Azimuth')"/>
                      </xsl:variable>
                      <xsl:if test="@Identifier=$TIRFChannel_Azimuth">
                        <xsl:value-of select="@Variant"/>
                      </xsl:if>
                    </xsl:for-each>
                  </TD>

                  <xsl:if test="$ShowTIRFFastIlluminationSwitchingMode = '1'">
                    <TD>
                      <xsl:for-each select="//ScannerSettingRecord">
                        <xsl:variable name="TIRFChannel_FastIlluminationSwitchingMode">
                          <xsl:value-of select="concat($TIRFChannelPrefix, 'FastIlluminationSwitchingMode')"/>
                        </xsl:variable>
                        <xsl:if test="@Identifier=$TIRFChannel_FastIlluminationSwitchingMode">
                          <xsl:choose>
                            <xsl:when test="@Variant = '1'">
                              FLUO
                            </xsl:when>
                            <xsl:otherwise>
                              TIRF
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:if>
                      </xsl:for-each>
                    </TD>
                  </xsl:if>
                </TR>
              </xsl:for-each>
            </TABLE>
          </TD>
        </TR>
      </TABLE>
    </xsl:if>

    <p> </p>

    <TABLE width="98%" align="center" border="0" cellspacing="5" cellpadding="5">
      <TR>
        <TD align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
          <b>Microscope Settings</b>
        </TD>
      </TR>
    </TABLE>

    <TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7">
      <TR>
        <TD>
          <TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF">
            

            <xsl:for-each select="//ScannerSettingRecord">
              <xsl:if test="@Identifier='MicroscopeFamilyType'">
                <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                  <TD width="40%">
                    Microscope Family Type
                  </TD>
                  <TD >
                    <xsl:choose>
                      <xsl:when test="@Variant = '0'">
                        Unknown
                      </xsl:when>
                      <xsl:when test="@Variant = '1'">
                        Compound Valentine
                      </xsl:when>
                      <xsl:when test="@Variant = '2'">
                        Compound Pioneer
                      </xsl:when>
                      <xsl:when test="@Variant = '3'">
                        Stereo
                      </xsl:when>
                      <xsl:when test="@Variant = '4'">
                        Manual
                      </xsl:when>
                    </xsl:choose>
                  </TD>
                </TR>
              </xsl:if>
            </xsl:for-each>

            <xsl:for-each select="//FilterSettingRecord">
              
              <xsl:if test="@ClassName='CTurret'">
                <xsl:if test="@Attribute!='OrderNumber'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">
                      <xsl:value-of select="@Description"/>
                    </TD>
                    <TD >
                      <xsl:value-of select="@Variant"/>
                    </TD>
                  </TR>
                </xsl:if>
              </xsl:if>

              <xsl:if test="@ClassName='CAotf'">
                <xsl:if test="@ObjectName='Visible AOTF'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">
                      <xsl:value-of select="@Description"/>
                    </TD>
                    <TD >
                      <xsl:value-of select="@Variant"/> &nbsp; %
                    </TD>
                  </TR>
                </xsl:if>
                <xsl:if test="@ObjectName='UV AOTF'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">
                      <xsl:value-of select="@Description"/>
                    </TD>
                    <TD >
                      <xsl:value-of select="@Variant"/> &nbsp; %
                    </TD>
                  </TR>
                </xsl:if>

              </xsl:if>

              <xsl:if test="@ClassName='CDetectionUnit'">
                <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                  <TD width="40%">
                    <xsl:value-of select="@Description"/>
                  </TD>
                  <xsl:choose>
                    <xsl:when test="@Attribute = 'VideoOffset'">
                      <TD >
                        <xsl:value-of select="@Variant"/> &nbsp; %
                      </TD>
                    </xsl:when>
                    <xsl:when test="@Attribute = 'HighVoltage'">
                      <TD >
                        <xsl:value-of select="@Variant"/> &nbsp; Volt
                      </TD>
                    </xsl:when>
                    <xsl:otherwise>
                      <TD >
                        <xsl:value-of select="@Variant"/>
                      </TD>
                    </xsl:otherwise>
                  </xsl:choose>
                </TR>
              </xsl:if>


              <xsl:if test="@ClassName='CFilterWheel'">
                <xsl:if test="@ObjectName='UV Lens FW'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">
                      <xsl:value-of select="@Description"/>
                    </TD>
                    <TD >
                      <xsl:value-of select="@Variant"/>
                    </TD>
                  </TR>
                </xsl:if>
              </xsl:if>

              <xsl:if test="@ClassName='CScanActuator'">
                <xsl:if test="@ObjectName='Y Scan Actuator'">
                  <xsl:if test="@Attribute='Position'">
                    <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                      <TD width="40%">
                        <xsl:value-of select="@Description"/>
                      </TD>
                      <TD >
                        <xsl:value-of select="@Variant"/> &nbsp; µm
                      </TD>
                    </TR>
                  </xsl:if>
                </xsl:if>
              </xsl:if>

              <xsl:if test="@ClassName='CScanActuator'">
                <xsl:if test="@ObjectName='Z Scan Actuator'">
                  <xsl:if test="@Attribute='Position'">
                    <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                      <TD width="40%">
                        <xsl:value-of select="@Description"/>
                      </TD>
                      <TD >
                        <xsl:value-of select="@Variant"/> &nbsp; µm
                      </TD>
                    </TR>
                  </xsl:if>
                </xsl:if>
              </xsl:if>

            </xsl:for-each>

            <xsl:for-each select="//FilterSettingRecord">

              <xsl:if test="@ClassName='CTubeOptic'">
                <xsl:if test="@Attribute='Magnification'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">
                      <xsl:value-of select="@Description"/>
                    </TD>
                    <TD >
                      <xsl:value-of select="@Variant"/>
                    </TD>
                  </TR>
                </xsl:if>
              </xsl:if>

            </xsl:for-each>

          </TABLE>

          <p> </p>

        </TD>
      </TR>
    </TABLE>

    <p> </p>


    <xsl:variable name='ShowDiaphragmSettings'>
      <xsl:comment>Variable for display Diaphragm-Settings</xsl:comment>
      <xsl:for-each select="//ScannerSettingRecord">
        <xsl:if test="@Identifier='bIsDiaphragmStoreModeEnabled'">
          <xsl:value-of select="@Variant"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <xsl:if test="$ShowDiaphragmSettings = '1'">
      <TABLE width="98%" align="center" border="0" cellspacing="5" cellpadding="5">
        <TR>
          <TD align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
            <b>Diaphragm Settings</b>
          </TD>
        </TR>
      </TABLE>

      <TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7">
        <TR>
          <TD>
            <TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF">

              <xsl:for-each select="//ScannerSettingRecord">

                <xsl:if test="@Identifier='FieldDiaphragmILSettingsToDisplay'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">
                      <xsl:value-of select="@Description"/>
                    </TD>
                    <TD >
                      <xsl:value-of disable-output-escaping="yes" select="@Variant"/>
                    </TD>
                  </TR>
                </xsl:if>
                
                <xsl:if test="@Identifier='FieldDiaphragmTLSettings'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">
                      <xsl:value-of select="@Description"/>
                    </TD>
                    <TD >
                      <xsl:value-of select="@Variant"/>
                    </TD>
                  </TR>
                </xsl:if>

                <xsl:if test="@Identifier='ApertureDiaphragmTLSettings'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">
                      <xsl:value-of select="@Description"/>
                    </TD>
                    <TD >
                      <xsl:value-of select="@Variant"/>
                    </TD>
                  </TR>
                </xsl:if>

              </xsl:for-each>

            </TABLE>
            <p> </p>

          </TD>
        </TR>
      </TABLE>
    </xsl:if>

    <p> </p>

    <xsl:variable name='ShowDICSettings'>
      <xsl:comment>Variable for display DIC-Settings</xsl:comment>
      <xsl:for-each select="//ScannerSettingRecord">
        <xsl:if test="@Identifier='bIsDICStoreModeEnabled'">
          <xsl:value-of select="@Variant"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <xsl:if test="$ShowDICSettings = '1'">
      <TABLE width="98%" align="center" border="0" cellspacing="5" cellpadding="5">
        <TR>
          <TD align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
            <b>DIC Settings</b>
          </TD>
        </TR>
      </TABLE>

      <TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7">
        <TR>
          <TD>
            <TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF">

              <xsl:for-each select="//ScannerSettingRecord">

                <xsl:if test="@Identifier='PrismNameDIC'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">
                      <xsl:value-of select="@Description"/>
                    </TD>
                    <TD >
                      <xsl:value-of select="@Variant"/>
                    </TD>
                  </TR>
                </xsl:if>

                <xsl:if test="@Identifier='PrismNameCond'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">
                      <xsl:value-of select="@Description"/>
                    </TD>
                    <TD >
                      <xsl:value-of select="@Variant"/>
                    </TD>
                  </TR>
                </xsl:if>

                <xsl:if test="@Identifier='DICBias'">
                  <TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;">
                    <TD width="40%">
                      <xsl:value-of select="@Description"/>
                    </TD>
                    <TD >
                      <xsl:value-of select="@Variant"/>
                    </TD>
                  </TR>
                </xsl:if>

              </xsl:for-each>

            </TABLE>
            <p> </p>

          </TD>
        </TR>
      </TABLE>
    </xsl:if>


  </xsl:template>



</xsl:stylesheet>

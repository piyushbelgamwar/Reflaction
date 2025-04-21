<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    ******************************************************************* 
    * 
    *    Schema for: Data Item REP026a - Access to Cash - Banks and Building Societies 
    *    Version:    1 
    *    Date:       24 July 2024 
    *    Modified:   To detect and reject whitespace-only content
    * 
    ******************************************************************* 
--> 
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified" 
    attributeFormDefault="unqualified" targetNamespace="urn:fsa-gov-uk:MER:REP026a:1" 
    xmlns="urn:fsa-gov-uk:MER:REP026a:1" xmlns:mer-meta="urn:fsa-gov-uk:MER:Meta-Data:1" version="1" 
    id="MER-REP026a"> 

    <xs:annotation> 
        <xs:documentation> 
            <mer-meta:DataItemReference>REP026a</mer-meta:DataItemReference> 
            <mer-meta:DataItemName>Access to Cash - Banks and Building Societies</mer-meta:DataItemName> 
        </xs:documentation> 
    </xs:annotation> 

    <!-- Define custom simple types with pattern restrictions to prevent whitespace-only content -->
    <xs:simpleType name="NonEmptyString">
        <xs:restriction base="xs:string">
            <xs:pattern value=".*[^\s].*"/>
            <xs:minLength value="1"/>
        </xs:restriction>
    </xs:simpleType>

    <xs:simpleType name="NonEmptyStringType100">
        <xs:restriction base="NonEmptyString">
            <xs:maxLength value="100"/>
        </xs:restriction>
    </xs:simpleType>

    <xs:simpleType name="NonEmptyStringType400">
        <xs:restriction base="NonEmptyString">
            <xs:maxLength value="400"/>
        </xs:restriction>
    </xs:simpleType>

    <xs:simpleType name="NonEmptyStringType2000">
        <xs:restriction base="NonEmptyString">
            <xs:maxLength value="2000"/>
        </xs:restriction>
    </xs:simpleType>

    <xs:simpleType name="NonEmptyPostCodeType">
        <xs:restriction base="PostCodeType">
            <xs:pattern value=".*[^\s].*"/>
        </xs:restriction>
    </xs:simpleType>

    <xs:simpleType name="NonEmptyEastNorthType">
        <xs:restriction base="EastNorthType">
            <xs:pattern value=".*[^\s].*"/>
        </xs:restriction>
    </xs:simpleType>

    <xs:simpleType name="NonEmptyLongLatType">
        <xs:restriction base="LongLatType">
            <xs:pattern value=".*[^\s].*"/>
        </xs:restriction>
    </xs:simpleType>

    <xs:simpleType name="NonEmptyNonNegativeIntegerType">
        <xs:restriction base="NonNegativeIntegerType">
            <xs:pattern value=".*[^\s].*"/>
        </xs:restriction>
    </xs:simpleType>

    <xs:simpleType name="NonEmptySortcodeType">
        <xs:restriction base="SortcodeType">
            <xs:pattern value=".*[^\s].*"/>
        </xs:restriction>
    </xs:simpleType>

    <!-- Include the original common types -->
    <xs:include schemaLocation="../../CommonTypes/v17/CommonTypes-Schema.xsd"/>

    <xs:element name="REP026a-AccesstoCashBanksandBuildingSocieties"> 
        <xs:complexType> 
            <xs:sequence> 
                <xs:element name="IdentifyingInformation" minOccurs="1"> 
                    <xs:complexType> 
                        <xs:sequence> 
                            <xs:element name="FRN" type="FRNType" minOccurs="1"/> 
                        </xs:sequence> 
                    </xs:complexType> 
                </xs:element> 
                <xs:element name="BranchInformation" minOccurs="1" maxOccurs="unbounded"> 
                    <xs:complexType> 
                        <xs:sequence> 
                            <xs:element name="BUID" type="NonEmptyStringType100" minOccurs="1"/> 
                            <xs:element name="MUID" type="NonEmptyStringType100" minOccurs="0"/> 
                            <xs:element name="BranchName" type="NonEmptyStringType100" minOccurs="0"/> 
                            <xs:element name="Brand" type="NonEmptyStringType100" minOccurs="1"/> 
                            <xs:element name="SortCode" type="NonEmptySortcodeType" minOccurs="1"/> 
                            <xs:element name="OtherID" type="String2000Type" minOccurs="0"/> 
                            <xs:element name="Leasehold" type="YesNoNAType" minOccurs="1"/> 
                             
                            <xs:element name="LocationInformation" minOccurs="1"> 
                                <xs:complexType> 
                                    <xs:sequence> 
                                        <xs:element name="Postcode" type="NonEmptyPostCodeType" minOccurs="1"/> 
                                        <xs:element name="Address" type="NonEmptyStringType2000" minOccurs="1"/> 
                                        <xs:element name="Easting" type="NonEmptyEastNorthType" minOccurs="1"/> 
                                        <xs:element name="Northing" type="NonEmptyEastNorthType" minOccurs="1"/> 
                                        <xs:element name="Latitude" type="NonEmptyLongLatType" minOccurs="1"/> 
                                        <xs:element name="Longitude" type="NonEmptyLongLatType" minOccurs="1"/> 
                                        <xs:element name="OtherLocation" type="String2000Type" minOccurs="0"/>                                                     
                                    </xs:sequence> 
                                </xs:complexType> 
                            </xs:element> 
                            <xs:element name="BranchOpeningHours" minOccurs="1"> 
                                <xs:complexType> 
                                    <xs:sequence> 
                                        <xs:element name="Monday" type="NonEmptyStringType400" minOccurs="1"/> 
                                        <xs:element name="Tuesday" type="NonEmptyStringType400" minOccurs="1"/> 
                                        <xs:element name="Wednesday" type="NonEmptyStringType400" minOccurs="1"/> 
                                        <xs:element name="Thursday" type="NonEmptyStringType400" minOccurs="1"/> 
                                        <xs:element name="Friday" type="NonEmptyStringType400" minOccurs="1"/> 
                                        <xs:element name="Saturday" type="NonEmptyStringType400" minOccurs="1"/> 
                                        <xs:element name="Sunday" type="NonEmptyStringType400" minOccurs="1"/> 
                                        <xs:element name="Reduced" type="YesNoNAType" minOccurs="1"/> 
                                        <xs:element name="TempClosedDays" type="NonEmptyNonNegativeIntegerType" minOccurs="0"/> 
                                        <xs:element name="TempClosedReason" type="String2000Type" minOccurs="0"/> 
                                        <xs:element name="OtherHours" type="String2000Type" minOccurs="0"/> 
                                    </xs:sequence> 
                                </xs:complexType> 
                            </xs:element> 
                            <xs:element name="BranchCharacteristicsInternalFacilities" minOccurs="1"> 
                                <xs:complexType> 
                                    <xs:sequence> 
                                        <xs:element name="Agency" type="YesNoNAType" minOccurs="1"/> 
                                        <xs:element name="Dependant" type="YesNoNAType" minOccurs="1"/> 
                                        <xs:element name="CommunityBanker" type="YesNoNAType" minOccurs="1"/> 
                                        <xs:element name="CounterFtoF" type="YesNoNAType" minOccurs="1"/> 
                                        <xs:element name="ConsumerDeposits" type="YesNoNAType" minOccurs="1"/> 
                                        <xs:element name="BusinessDeposits" type="YesNoNAType" minOccurs="1"/> 
                                        <xs:element name="ConsumerWithdrawals" type="YesNoNAType" minOccurs="1"/> 
                                        <xs:element name="BusinessWithdrawals" type="YesNoNAType" minOccurs="1"/> 
                                        <xs:element name="BusinessBalanceEnq" type="YesNoNAType" minOccurs="1"/> 
                                        <xs:element name="LBIT" type="YesNoType" minOccurs="1"/> 
                                        <xs:element name="FreeATMID" type="String2000Type" minOccurs="0"/> 
                                        <xs:element name="PAYATMID" type="String2000Type" minOccurs="0"/> 
                                        <xs:element name="CounterAll" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/> 
                                        <xs:element name="CounterPersonal" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/> 
                                        <xs:element name="CounterSME" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/> 
                                        <xs:element name="ATMAll" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/> 
                                        <xs:element name="ATMPersonal" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/> 
                                        <xs:element name="ATMSME" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/> 
                                        <xs:element name="ATMNote" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/> 
                                        <xs:element name="ATMCoin" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/> 
                                        <xs:element name="ATMCashIDs" type="String2000Type" minOccurs="0"/> 
                                        <xs:element name="ATMSupport" type="YesNoNAType" minOccurs="1"/> 
                                        <xs:element name="NonChipCard" type="YesNoNAType" minOccurs="1"/> 
                                        <xs:element name="OtherType" type="String2000Type" minOccurs="0"/> 
                                    </xs:sequence> 
                                </xs:complexType> 
                            </xs:element> 
                            <xs:element name="BranchAccessibility" minOccurs="1"> 
                                <xs:complexType> 
                                    <xs:sequence> 
                                        <xs:element name="Wheelchair" type="YesNoNAType" minOccurs="1"/> 
                                        <xs:element name="StepFree" type="YesNoNAType" minOccurs="1"/> 
                                        <xs:element name="Hearing" type="YesNoNAType" minOccurs="1"/> 
                                        <xs:element name="VisualImpairment" type="YesNoNAType" minOccurs="1"/> 
                                        <xs:element name="OtherAccess" type="String400Type" minOccurs="0"/> 
                                    </xs:sequence> 
                                </xs:complexType> 
                            </xs:element> 
                            <xs:element name="ExternalFacilities" minOccurs="1"> 
                                <xs:complexType> 
                                    <xs:sequence> 
                                        <xs:element name="ExternalDeposit" type="YesNoNAType" minOccurs="1"/> 
                                        <xs:element name="ExternalFTUATM" type="String2000Type" minOccurs="0"/> 
                                        <xs:element name="ExternalPTUATM" type="String2000Type" minOccurs="0"/> 
                                        <xs:element name="ExternalAllDay" type="YesNoNAType" minOccurs="1"/> 
                                        <xs:element name="OtherExternal" type="String2000Type" minOccurs="0"/> 
                                    </xs:sequence> 
                                </xs:complexType> 
                            </xs:element> 
                            <xs:element name="UsageLevels" minOccurs="1"> 
                                <xs:complexType> 
                                    <xs:sequence> 
                                        <xs:element name="ConsumerFootfall" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/> 
                                        <xs:element name="BusinessFootfall" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/> 
                                        <xs:element name="ConsumerVolWithdrawal" type="NonNegativeMonetaryType" minOccurs="1"/> 
                                        <xs:element name="BusinessVolWithdrawal" type="NonNegativeMonetaryType" minOccurs="1"/> 
                                        <xs:element name="ConsumerVolDeposit" type="NonNegativeMonetaryType" minOccurs="1"/> 
                                        <xs:element name="BusinessVolDeposit" type="NonNegativeMonetaryType" minOccurs="1"/> 
                                        <xs:element name="ConsumerWithdrawalTrans" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/> 
                                        <xs:element name="BusinessWithdrawalTrans" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/> 
                                        <xs:element name="ConsumerDepositTrans" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/> 
                                        <xs:element name="BusinessDepositTrans" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/> 
                                        <xs:element name="ConsumerBalanceEnq" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/> 
                                        <xs:element name="BusinessBalanceEnq" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/> 
                                        <xs:element name="NoRegisteredPersonalCustomers" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/> 
                                        <xs:element name="DefnRegularPersonalCustomer" type="String2000Type" minOccurs="0"/>                                                                                                                              
                                        <xs:element name="NoRegularPersonalCustomers" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/>                             
                                        <xs:element name="NoOnlineCustomers" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/>                             
                                        <xs:element name="NoMobileBankingCustomers" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/>                             
                                        <xs:element name="NoPhoneBankingCustomers" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/>                             
                                        <xs:element name="DefnRegularSMECustomer" type="String2000Type" minOccurs="0"/> 
                                        <xs:element name="NoRegularSMECustomers" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/>                             
                                        <xs:element name="NoSMEDepositCustomers" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/>                             
                                        <xs:element name="NoSMEWithdrawalCustomers" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/>                             
                                        <xs:element name="NoRegisteredSMECustomers" type="NonEmptyNonNegativeIntegerType" minOccurs="0"/>                             
                                        <xs:element name="OtherUsage" type="String2000Type" minOccurs="0"/> 
                                    </xs:sequence> 
                                </xs:complexType> 
                            </xs:element> 
                            <xs:element name="CustomersVulnerableCirc" minOccurs="1"> 
                                <xs:complexType> 
                                    <xs:sequence> 
                                        <xs:element name="NoVulnerableCustomers" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/> 
                                        <xs:element name="NoPassbookNonChipCustomers" type="NonEmptyNonNegativeIntegerType" minOccurs="0"/> 
                                        <xs:element name="NoBasicAccounts" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/> 
                                        <xs:element name="OtherVulnerable" type="String2000Type" minOccurs="0"/> 
                                    </xs:sequence> 
                                </xs:complexType> 
                            </xs:element> 
                            <xs:element name="SupportStrategyVulnerableCustomers" minOccurs="0"> 
                                <xs:complexType> 
                                    <xs:sequence> 
                                        <xs:element name="SupportStrategy" type="String2000Type" minOccurs="0"/> 
                                    </xs:sequence> 
                                </xs:complexType> 
                            </xs:element> 
                            <xs:element name="RemovalSatHours" minOccurs="1"> 
                                <xs:complexType> 
                                    <xs:sequence> 
                                        <xs:element name="SaturdayClosure" type="YesNoNAType" minOccurs="1"/> 
                                        <xs:element name="SaturdayClosureResidual" type="String2000Type" minOccurs="0"/> 
                                    </xs:sequence> 
                                </xs:complexType> 
                            </xs:element> 
                            <xs:element name="ProposedClosure" minOccurs="1"> 
                                <xs:complexType> 
                                    <xs:sequence> 
                                        <xs:element name="Closure" type="YesNoType" minOccurs="1"/> 
                                    </xs:sequence> 
                                </xs:complexType> 
                            </xs:element> 
                            <xs:element name="ProposedClosureDetails" minOccurs="0"> 
                                <xs:complexType> 
                                    <xs:sequence> 
                                        <xs:element name="ClosureDate" type="DateRestriction" minOccurs="0"/> 
                                        <xs:element name="AnnouncementDate" type="DateRestriction" minOccurs="0"/> 
                                        <xs:element name="ATMRemaining" type="String2000Type" minOccurs="0"/> 
                                        <xs:element name="PreviousHopper" type="YesNoNAType" minOccurs="0"/> 
                                    </xs:sequence> 
                                </xs:complexType> 
                            </xs:element> 
                            <xs:element name="CommunicationAndClosures" minOccurs="0"> 
                                <xs:complexType> 
                                    <xs:sequence> 
                                        <xs:element name="TwelveWeeks" type="YesNoNAType" minOccurs="0"/> 
                                        <xs:element name="LocalStakeholders" type="String2000Type" minOccurs="0"/> 
                                        <xs:element name="EngagementStrategy" type="String2000Type" minOccurs="0"/> 
                                    </xs:sequence> 
                                </xs:complexType> 
                            </xs:element> 
                            <xs:element name="ProvisionOfAlternativeAccessPoint" minOccurs="0"> 
                                <xs:complexType> 
                                    <xs:sequence> 
                                        <xs:element name="ProvisionGap" type="YesNoNAType" minOccurs="1"/> 
                                        <xs:element name="ProvisionGapTime" type="NonEmptyNonNegativeIntegerType" minOccurs="1"/> 
                                        <xs:element name="ProvisionGapDetails" type="String2000Type" minOccurs="0"/> 
                                    </xs:sequence> 
                                </xs:complexType> 
                            </xs:element> 
                            <xs:element name="AvailablePO" minOccurs="0"> 
                                <xs:complexType> 
                                    <xs:sequence> 
                                        <xs:element name="NearestPostcode" type="NonEmptyPostCodeType" minOccurs="0"/> 
                                        <xs:element name="NearestAddress" type="String2000Type" minOccurs="0"/> 
                                        <xs:element name="POEnhanced" type="YesNoNAType" minOccurs="0"/> 
                                        <xs:element name="POOutreach" type="YesNoNAType" minOccurs="0"/> 
                                        <xs:element name="DrivingTime" type="NonEmptyNonNegativeIntegerType" minOccurs="0"/> 
                                        <xs:element name="PublicTransportTime" type="NonEmptyNonNegativeIntegerType" minOccurs="0"/> 
                                        <xs:element name="MonOH" type="String400Type" minOccurs="0"/> 
                                        <xs:element name="TuesOH" type="String400Type" minOccurs="0"/> 
                                        <xs:element name="WedOH" type="String400Type" minOccurs="0"/> 
                                        <xs:element name="ThursOH" type="String400Type" minOccurs="0"/> 
                                        <xs:element name="FriOH" type="String400Type" minOccurs="0"/> 
                                        <xs:element name="SatOH" type="String400Type" minOccurs="0"/> 
                                        <xs:element name="SunOH" type="String400Type" minOccurs="0"/> 
                                        <xs:element name="POCapacity" type="YesNoNAType" minOccurs="0"/> 
                                        <xs:element name="POSuitability" type="String2000Type" minOccurs="0"/> 
                                        <xs:element name="OtherPO" type="String2000Type" minOccurs="0"/> 
                                    </xs:sequence> 
                                </xs:complexType> 
                            </xs:element> 
                            <xs:element name="ImpactPODeflection" minOccurs="0"> 
                                <xs:complexType> 
                                    <xs:sequence> 
                                        <xs:element name="SMEPODeflection" type="NonEmptyNonNegativeIntegerType" minOccurs="0"/> 
                                        <xs:element name="SMEOtherDeflection" type="NonEmptyNonNegativeIntegerType" minOccurs="0"/> 
                                        <xs:element name="SMEResidual" type="String2000Type" minOccurs="0"/> 
                                        <xs:element name="SMECosts" type="YesNoNAType" minOccurs="0"/> 
                                        <xs:element name="SMEContactStrategy" type="String2000Type" minOccurs="0"/> 
                                        <xs:element name="SMEExcessDeposits" type="NonEmptyNonNegativeIntegerType" minOccurs="0"/> 
                                    </xs:sequence> 
                                </xs:complexType> 
                            </xs:element> 
                            <xs:element name="RemainingBranchesAndDeflection" minOccurs="0"> 
                                <xs:complexType> 
                                    <xs:sequence> 
                                        <xs:element name="BranchPostcode" type="NonEmptyPostCodeType" minOccurs="0"/> 
                                        <xs:element name="BranchAddress" type="String2000Type" minOccurs="0"/> 
                                        <xs:element name="BranchDrivingTime" type="NonEmptyNonNegativeIntegerType" minOccurs="0"/> 
                                        <xs:element name="BranchPublicTransportTime" type="NonEmptyNonNegativeIntegerType" minOccurs="0"/> 
                                        <xs:element name="BranchMonOH" type="String400Type" minOccurs="0"/> 
                                        <xs:element name="BranchTuesOH" type="String400Type" minOccurs="0"/> 
                                        <xs:element name="BranchWedOH" type="String400Type" minOccurs="0"/> 
                                        <xs:element name="BranchThursOH" type="String400Type" minOccurs="0"/> 
                                        <xs:element name="BranchFriOH" type="String400Type" minOccurs="0"/> 
                                        <xs:element name="BranchSatOH" type="String400Type" minOccurs="0"/> 
                                        <xs:element name="BranchSunOH" type="String400Type" minOccurs="0"/> 
                                        <xs:element name="OHDeflection" type="YesNoNAType" minOccurs="0"/> 
                                        <xs:element name="ServicesDeflection" type="String2000Type" minOccurs="0"/> 
                                        <xs:element name="SuitabilityDeflection" type="String2000Type" minOccurs="0"/> 
                                    </xs:sequence> 
                                </xs:complexType> 
                            </xs:element> 
                            <xs:element name="RemainingBSAndATM" minOccurs="0"> 
                                <xs:complexType> 
                                    <xs:sequence> 
                                        <xs:element name="BSPostcode" type="NonEmptyPostCodeType" minOccurs="1"/> 
                                        <xs:element name="BSAddress" type="String2000Type" minOccurs="0"/> 
                                        <xs:element name="BSDistance" type="NonNegativeFloat2Type" minOccurs="1"/> 
                                        <xs:element name="FTUATMPostcode" type="PostCodeType" minOccurs="0"/> 
                                        <xs:element name="FTUATMAddress" type="String2000Type" minOccurs="0"/> 
                                        <xs:element name="ATMDistance" type="NonNegativeFloat2Type" minOccurs="1"/> 
                                        <xs:element name="OtherATM" type="String2000Type" minOccurs="0"/> 
                                    </xs:sequence> 
                                </xs:complexType> 
                            </xs:element> 
                        </xs:sequence> 
                    </xs:complexType> 
                </xs:element> 
            </xs:sequence> 
            <xs:attribute name="currency" fixed="GBP" use="required"/> 
            <xs:attribute name="units" fixed="single" use="required"/> 
        </xs:complexType> 
    </xs:element> 
</xs:schema>

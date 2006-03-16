
-- Sequences 
create sequence "Contact_contactId";
create sequence "Country_countryId";
create sequence "State_stateId";
create sequence "Address_addressId";
create sequence "EmailAddress_emailAddressId";
create sequence "PhoneNumber_phoneNumberId";

-- Tables
CREATE TABLE "Contact" (
	"contactId" NUMBER NOT NULL ,
	"firstName" VARCHAR2(50 BYTE) NOT NULL ,
	"lastName" VARCHAR2(50 BYTE) NOT NULL,
	PRIMARY KEY
 	("contactId")
);

CREATE TABLE "Country" (
	"countryId" NUMBER NOT NULL ,
	"abbreviation" VARCHAR2(10 BYTE) NOT NULL ,
	"name" VARCHAR2(50 BYTE) NOT NULL ,
	"sortOrder" NUMBER NOT NULL ,
	PRIMARY KEY
 	("countryId")
);

CREATE TABLE "State" (
	"stateId" NUMBER NOT NULL ,
	"abbreviation" VARCHAR2(5 BYTE) NOT NULL ,
	"name" VARCHAR2(50 BYTE) NOT NULL  ,
	PRIMARY KEY
 	("stateId")
);

CREATE TABLE "Address"
(
	"addressId" NUMBER NOT NULL,
	"contactId" NUMBER NOT NULL,
	"line1" VARCHAR2(50 BYTE) NOT NULL,
	"line2" VARCHAR2(50 BYTE),
	"city" VARCHAR2(50 BYTE) NOT NULL,
	"stateId" NUMBER ,
	"postalCode" VARCHAR2(20 BYTE) NOT NULL,
	"countryId" NUMBER NOT NULL,
	PRIMARY KEY
	("addressId"),
	CONSTRAINT FK_Address_Contact 
	FOREIGN KEY ("contactId") 
	REFERENCES "Contact" ("contactId"),
	CONSTRAINT FK_Address_Country 
	FOREIGN KEY ("countryId") 
	REFERENCES "Country" ("countryId"),
	CONSTRAINT FK_Address_State 
	FOREIGN KEY ("stateId") 
	REFERENCES "State" ("stateId")
);

CREATE TABLE "EmailAddress" (
	"emailAddressId" NUMBER NOT NULL ,
	"contactId" NUMBER NOT NULL ,
	"emailAddress" VARCHAR2(100 BYTE) NOT NULL ,
	PRIMARY KEY
	("emailAddressId"),
	CONSTRAINT FK_EmailAddress_Contact 
	FOREIGN KEY ("contactId") 
	REFERENCES "Contact" ("contactId")
);

CREATE TABLE "PhoneNumber" (
	"phoneNumberId" NUMBER NOT NULL ,
	"contactId" NUMBER NOT NULL ,
	"phoneNumber" VARCHAR2(50 BYTE) NOT NULL ,
	PRIMARY KEY
	("phoneNumberId"),
	CONSTRAINT FK_PhoneNumber_Contact 
	FOREIGN KEY ("contactId") 
	REFERENCES "Contact" ("contactId")
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'AB',
	'Alberta'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'AK',
	'Alaska'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'AL',
	'Alabama'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'AR',
	'Arkansas'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'AZ',
	'Arizona'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'BC',
	'British Columbia'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'CA',
	'California'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'CO',
	'Colorado'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'CT',
	'Connecticut'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'DC',
	'District Of Columbia'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'DE',
	'Delaware'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'FL',
	'Florida'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'GA',
	'Georgia'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'GU',
	'Guam'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'HI',
	'Hawaii'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'IA',
	'Iowa'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'ID',
	'Idaho'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'IL',
	'Illinois'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'IN',
	'Indiana'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'KS',
	'Kansas'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'KY',
	'Kentucky'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'LA',
	'Louisiana'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'MA',
	'Massachusetts'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'MB',
	'Manitoba'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'MD',
	'Maryland'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'ME',
	'Maine'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'MI',
	'Michigan'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'MN',
	'Minnesota'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'MO',
	'Missouri'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'MP',
	'Northern Mariana Islands'
);


INSERT INTO "State" (

	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'MS',
	'Mississippi'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'MT',
	'Montana'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'NB',
	'New Brunswick'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'NC',
	'North Carolina'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'ND',
	'North Dakota'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'NE',
	'Nebraska'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'NF',
	'Newfoundland and Labrador'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'NH',
	'New Hampshire'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'NJ',
	'New Jersey'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'NM',
	'New Mexico'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'NS',
	'Nova Scotia'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'NT',
	'Northwest Territories'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'NU',
	'Nunavut'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'NV',
	'Nevada'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'NY',
	'New York'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'OH',
	'Ohio'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'OK',
	'Oklahoma'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'ON',
	'Ontario'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'OR',
	'Oregon'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'PA',
	'Pennsylvania'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'PE',
	'Prince Edward Island'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'PR',
	'Puerto Rico'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'QC',
	'Quebec'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'RI',
	'Rhode Island'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'SC',
	'South Carolina'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'SD',
	'South Dakota'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'SK',
	'Saskatchewan'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'TN',
	'Tennessee'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'TX',
	'Texas'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'UT',
	'Utah'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'VA',
	'Virginia'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'VI',
	'Virgin Islands'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'VT',
	'Vermont'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'WA',
	'Washington'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'WI',
	'Wisconsin'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'WV',
	'West Virginia'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'WY',
	'Wyoming'
);


INSERT INTO "State" (
	"stateId",
	"abbreviation",
	"name"
) VALUES (
	"State_stateId".nextval,
	'YT',
	'Yukon Territory'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'ABW',
	'Aruba',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'AFG',
	'Afghanistan',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'AGO',
	'Angola',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'AIA',
	'Anguilla',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'ALB',
	'Albania',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'AND',
	'Andorra',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'ANT',
	'Netherlands Antilles',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'ARE',
	'United Arab Emirates',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'ARG',
	'Argentina',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'ARM',
	'Armenia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'ASM',
	'American Samoa',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'ATA',
	'Antarctica',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'ATF',
	'French Southern Territories',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'ATG',
	'Antigua and Barbuda',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'AUS',
	'Australia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'AUT',
	'Austria',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'AZE',
	'Azerbaijan',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'BDI',
	'Burundi',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'BEL',
	'Belgium',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'BEN',
	'Benin',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'BFA',
	'Burkina Faso',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'BGD',
	'Bangladesh',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'BGR',
	'Bulgaria',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'BHR',
	'Bahrain',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'BHS',
	'Bahamas',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'BIH',
	'Bosnia and Herzegowina',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'BLR',
	'Belarus',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'BLZ',
	'Belize',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'BMU',
	'Bermuda',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'BOL',
	'Bolivia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'BRA',
	'Brazil',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'BRB',
	'Barbados',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'BRN',
	'Brunei Darussalam',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'BTN',
	'Bhutan',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'BVT',
	'Bouvet Island',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'BWA',
	'Botswana',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'CAF',
	'Central African Republic',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'CAN',
	'Canada',
	'4'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'CCK',
	'Cocos (Keeling); Islands',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'CHE',
	'Switzerland',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'CHL',
	'Chile',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'CHN',
	'China',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'CIV',
	'Cote D''Ivoire',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'CMR',
	'Cameroon',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'COG',
	'Congo',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'COK',
	'Cook Islands',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'COL',
	'Colombia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'COM',
	'Comoros',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'CPV',
	'Cape Verde',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'CRI',
	'Costa Rica',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'CUB',
	'Cuba',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'CXR',
	'Christmas Island',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'CYM',
	'Cayman Islands',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'CYP',
	'Cyprus',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'CZE',
	'Czech Republic',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'DEU',
	'Germany',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'DJI',
	'Djibouti',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'DMA',
	'Dominica',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'DNK',
	'Denmark',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'DOM',
	'Dominican Republic',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'DZA',
	'Algeria',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'ECU',
	'Ecuador',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'EGY',
	'Egypt',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'ERI',
	'Eritrea',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'ESH',
	'Western Sahara',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'ESP',
	'Spain',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'EST',
	'Estonia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'ETH',
	'Ethiopia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'FIN',
	'Finland',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'FJI',
	'Fiji',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'FLK',
	'Falkland Islands (Malvinas);',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'FRA',
	'France',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'FRO',
	'Faroe Islands',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'FSM',
	'Micronesia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'FXX',
	'France, Metropolitan',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'GAB',
	'Gabon',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'GBR',
	'United Kingdom',
	'3'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'GEO',
	'Georgia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'GHA',
	'Ghana',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'GIB',
	'Gibraltar',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'GIN',
	'Guinea',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'GLP',
	'Guadeloupe',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'GMB',
	'Gambia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'GNB',
	'Guinea-Bissau',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'GNQ',
	'Equatorial Guinea',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'GRC',
	'Greece',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'GRD',
	'Grenada',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'GRL',
	'Greenland',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'GTM',
	'Guatemala',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'GUF',
	'French Guiana',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'GUM',
	'Guam',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'GUY',
	'Guyana',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'HKG',
	'Hong Kong',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'HMD',
	'Heard/McDonald Isls.',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'HND',
	'Honduras',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'HRV',
	'Croatia (Hrvatska);',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'HTI',

	'Haiti',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'HUN',
	'Hungary',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'IDN',
	'Indonesia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'IND',
	'India',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'IOT',
	'British Indian Ocean Terr.',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'IRL',
	'Ireland',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'IRN',
	'Iran',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'IRQ',
	'Iraq',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'ISL',
	'Iceland',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'ISR',
	'Israel',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'ITA',
	'Italy',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'JAM',
	'Jamaica',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'JOR',
	'Jordan',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'JPN',
	'Japan',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'KAZ',
	'Kazakhstan',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'KEN',
	'Kenya',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'KGZ',
	'Kyrgyzstan',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'KHM',
	'Cambodia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'KIR',
	'Kiribati',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'KNA',
	'Saint Kitts and Nevis',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'KOR',
	'Korea (South);',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'KWT',
	'Kuwait',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'LAO',
	'Lao',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'LBN',
	'Lebanon',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'LBR',
	'Liberia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'LBY',
	'Libyan Arab Jamahiriya',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'LCA',
	'Saint Lucia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'LIE',
	'Liechtenstein',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'LKA',
	'Sri Lanka',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'LSO',
	'Lesotho',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'LTU',
	'Lithuania',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'LUX',
	'Luxembourg',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'LVA',
	'Latvia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'MAC',
	'Macau',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'MAR',
	'Morocco',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'MCO',
	'Monaco',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'MDA',
	'Moldova',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'MDG',
	'Madagascar',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'MDV',
	'Maldives',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'MEX',
	'Mexico',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'MHL',
	'Marshall Islands',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'MKD',
	'Macedonia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'MLI',
	'Mali',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'MLT',
	'Malta',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'MMR',
	'Myanmar',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'MNG',
	'Mongolia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'MNP',
	'Northern Mariana Isls.',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'MOZ',
	'Mozambique',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'MRT',
	'Mauritania',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'MSR',
	'Montserrat',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'MTQ',
	'Martinique',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'MUS',
	'Mauritius',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'MWI',
	'Malawi',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'MYS',
	'Malaysia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'MYT',
	'Mayotte',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'NAM',
	'Namibia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'NCL',
	'New Caledonia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'NER',
	'Niger',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'NFK',
	'Norfolk Island',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'NGA',
	'Nigeria',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'NIC',
	'Nicaragua',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'NIU',
	'Niue',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'NLD',
	'Netherlands',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'NOR',
	'Norway',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'NPL',
	'Nepal',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'NRU',
	'Nauru',
	'0'
);



INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'NZL',
	'New Zealand',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'OMN',
	'Oman',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'PAK',
	'Pakistan',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'PAN',
	'Panama',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'PCN',
	'Pitcairn',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'PER',
	'Peru',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'PHL',
	'Philippines',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'PLW',
	'Palau',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'PNG',
	'Papua New Guinea',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'POL',
	'Poland',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'PRI',
	'Puerto Rico',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'PRK',
	'Korea (North);',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'PRT',
	'Portugal',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'PRY',
	'Paraguay',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'PYF',
	'French Polynesia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'QAT',
	'Qatar',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'REU',
	'Reunion',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'ROM',
	'Romania',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'RUS',
	'Russian Federation',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'RWA',
	'Rwanda',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'SAU',
	'Saudi Arabia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'SDN',
	'Sudan',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'SEN',
	'Senegal',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'SGP',
	'Singapore',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'SGS',
	'S Georgia/S Sandwich Isls.',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'SHN',
	'St. Helena',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'SJM',
	'Svalbard/Jan Mayen Isls.',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'SLB',
	'Solomon Islands',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'SLE',
	'Sierra Leone',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'SLV',
	'El Salvador',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'SMR',
	'San Marino',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'SOM',
	'Somalia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'SPM',
	'St. Pierre and Miquelon',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'STP',
	'Sao Tome and Principe',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'SUR',
	'Suri""name""',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'SVK',
	'Slovak Republic',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'SVN',
	'Slovenia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'SWE',
	'Sweden',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'SWZ',
	'Swaziland',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'SYC',
	'Seychelles',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'SYR',
	'Syrian Arab Republic',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'TCA',
	'Turks and Caicos Islands',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'TCD',
	'Chad',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'TGO',
	'Togo',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'THA',
	'Thailand',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'TJK',
	'Tajikistan',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'TKL',
	'Tokelau',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'TKM',
	'Turkmenistan',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'TMP',
	'East Timor',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'TON',
	'Tonga',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'TTO',
	'Trinidad and Tobago',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'TUN',
	'Tunisia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'TUR',
	'Turkey',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'TUV',
	'Tuvalu',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'TWN',
	'Taiwan',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'TZA',
	'Tanzania',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'UGA',
	'Uganda',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'UKR',
	'Ukraine',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'UMI',
	'US Minor Outlying Islands',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'URY',
	'Uruguay',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'USA',
	'United States of America',
	'5'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'UZB',
	'Uzbekistan',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'VAT',
	'Vatican City State',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'VCT',
	'Saint Vincent/Grenadines',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'VEN',
	'Venezuela',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'VGB',
	'Virgin Islands (British);',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'VIR',
	'Virgin Islands (U.S.);',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'VNM',
	'Viet Nam',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'VUT',
	'Vanuatu',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'WLF',
	'Wallis and Futuna Islands',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'WSM',
	'Samoa',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'YEM',
	'Yemen',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'YUG',
	'Yugoslavia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'ZAF',
	'South Africa',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'ZAR',
	'Zaire',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'ZMB',
	'Zambia',
	'0'
);


INSERT INTO "Country" (
	"countryId",
	"abbreviation",
	"name",
	"sortOrder"
) VALUES (
	"Country_countryId".nextval,
	'ZWE',
	'Zimbabwe',
	'0'
);

COMMIT;

 

-- ----------------------------------------------------------------------
-- EOF
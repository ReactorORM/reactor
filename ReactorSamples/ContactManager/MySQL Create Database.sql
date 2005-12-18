

CREATE TABLE `Contact` (
	`contactId` int NOT NULL auto_increment  ,
	`firstName` varchar(50) NOT NULL ,
	`lastName` varchar(50) NOT NULL ,
	PRIMARY KEY  (`contactId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Country` (
	`countryId` smallint NOT NULL auto_increment  ,
	`abbreviation` varchar(10) NOT NULL ,
	`name` varchar(50) NOT NULL ,
	`sortOrder` tinyint NOT NULL ,
	PRIMARY KEY  (`countryId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `State` (
	`stateId` smallint NOT NULL auto_increment  ,
	`abbreviation` varchar(5) NOT NULL ,
	`name` varchar(50) NOT NULL ,
	PRIMARY KEY  (`stateId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Address` (
	`addressId` int NOT NULL auto_increment,
	`contactId` int NOT NULL ,
	`line1` varchar(50) NOT NULL ,
	`line2` varchar(50) NULL ,
	`city` varchar(50) NOT NULL ,
	`stateId` smallint NULL ,
	`postalCode` varchar(20) NOT NULL ,
	`countryId` smallint NOT NULL ,
	PRIMARY KEY  (`addressId`),
	KEY `FK_address_1` (`stateId`),
	KEY `FK_address_2` (`countryId`),
	KEY `FK_address_3` (`contactId`),
	CONSTRAINT `FK_address_1` FOREIGN KEY (`stateId`) REFERENCES `State` (`stateId`),
	CONSTRAINT `FK_address_2` FOREIGN KEY (`countryId`) REFERENCES `Country` (`countryId`),
	CONSTRAINT `FK_address_3` FOREIGN KEY (`contactId`) REFERENCES `Contact` (`contactId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `EmailAddress` (
	`emailAddressId` int NOT NULL auto_increment  ,
	`contactId` int NOT NULL ,
	`emailAddress` varchar(100) NOT NULL ,
	PRIMARY KEY  (`emailAddressId`),
	KEY `FK_EmailAddress_1` (`contactId`),
	CONSTRAINT `FK_EmailAddress_1` FOREIGN KEY (`contactId`) REFERENCES `Contact` (`contactId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `PhoneNumber` (
	`phoneNumberId` int NOT NULL auto_increment  ,
	`contactId` int NOT NULL ,
	`phoneNumber` varchar(50) NOT NULL ,
	PRIMARY KEY  (`phoneNumberId`),
	KEY `FK_PhoneNumber_1` (`contactId`),
	CONSTRAINT `FK_PhoneNumber_1` FOREIGN KEY (`contactId`) REFERENCES `Contact` (`contactId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'AB',
  'Alberta'
)

INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'AK',
  'Alaska'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'AL',
  'Alabama'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'AR',
  'Arkansas'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'AZ',
  'Arizona'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'BC',
  'British Columbia'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'CA',
  'California'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'CO',
  'Colorado'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'CT',
  'Connecticut'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'DC',
  'District Of Columbia'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'DE',
  'Delaware'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'FL',
  'Florida'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'GA',
  'Georgia'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'GU',
  'Guam'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'HI',
  'Hawaii'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'IA',
  'Iowa'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'ID',
  'Idaho'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'IL',
  'Illinois'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'IN',
  'Indiana'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'KS',
  'Kansas'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'KY',
  'Kentucky'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'LA',
  'Louisiana'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'MA',
  'Massachusetts'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'MB',
  'Manitoba'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'MD',
  'Maryland'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'ME',
  'Maine'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'MI',
  'Michigan'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'MN',
  'Minnesota'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'MO',
  'Missouri'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'MP',
  'Northern Mariana Islands'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'MS',
  'Mississippi'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'MT',
  'Montana'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'NB',
  'New Brunswick'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'NC',
  'North Carolina'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'ND',
  'North Dakota'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'NE',
  'Nebraska'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'NF',
  'Newfoundland and Labrador'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'NH',
  'New Hampshire'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'NJ',
  'New Jersey'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'NM',
  'New Mexico'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'NS',
  'Nova Scotia'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'NT',
  'Northwest Territories'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'NU',
  'Nunavut'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'NV',
  'Nevada'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'NY',
  'New York'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'OH',
  'Ohio'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'OK',
  'Oklahoma'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'ON',
  'Ontario'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'OR',
  'Oregon'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'PA',
  'Pennsylvania'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'PE',
  'Prince Edward Island'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'PR',
  'Puerto Rico'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'QC',
  'Quebec'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'RI',
  'Rhode Island'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'SC',
  'South Carolina'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'SD',
  'South Dakota'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'SK',
  'Saskatchewan'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'TN',
  'Tennessee'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'TX',
  'Texas'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'UT',
  'Utah'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'VA',
  'Virginia'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'VI',
  'Virgin Islands'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'VT',
  'Vermont'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'WA',
  'Washington'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'WI',
  'Wisconsin'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'WV',
  'West Virginia'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'WY',
  'Wyoming'
);


INSERT INTO `State`
(
  abbreviation,
  name
) VALUES (
  'YT',
  'Yukon Territory'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'ABW',
	'Aruba',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'AFG',
	'Afghanistan',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'AGO',
	'Angola',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'AIA',
	'Anguilla',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'ALB',
	'Albania',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'AND',
	'Andorra',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'ANT',
	'Netherlands Antilles',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'ARE',
	'United Arab Emirates',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'ARG',
	'Argentina',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'ARM',
	'Armenia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'ASM',
	'American Samoa',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'ATA',
	'Antarctica',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'ATF',
	'French Southern Territories',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'ATG',
	'Antigua and Barbuda',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'AUS',
	'Australia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'AUT',
	'Austria',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'AZE',
	'Azerbaijan',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'BDI',
	'Burundi',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'BEL',
	'Belgium',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'BEN',
	'Benin',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'BFA',
	'Burkina Faso',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'BGD',
	'Bangladesh',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'BGR',
	'Bulgaria',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'BHR',
	'Bahrain',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'BHS',
	'Bahamas',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'BIH',
	'Bosnia and Herzegowina',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'BLR',
	'Belarus',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'BLZ',
	'Belize',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'BMU',
	'Bermuda',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'BOL',
	'Bolivia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'BRA',
	'Brazil',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'BRB',
	'Barbados',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'BRN',
	'Brunei Darussalam',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'BTN',
	'Bhutan',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'BVT',
	'Bouvet Island',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'BWA',
	'Botswana',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'CAF',
	'Central African Republic',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'CAN',
	'Canada',
	'4'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'CCK',
	'Cocos (Keeling) Islands',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'CHE',
	'Switzerland',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'CHL',
	'Chile',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'CHN',
	'China',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'CIV',
	'Cote D''Ivoire',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'CMR',
	'Cameroon',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'COG',
	'Congo',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'COK',
	'Cook Islands',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'COL',
	'Colombia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'COM',
	'Comoros',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'CPV',
	'Cape Verde',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'CRI',
	'Costa Rica',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'CUB',
	'Cuba',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'CXR',
	'Christmas Island',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'CYM',
	'Cayman Islands',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'CYP',
	'Cyprus',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'CZE',
	'Czech Republic',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'DEU',
	'Germany',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'DJI',
	'Djibouti',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'DMA',
	'Dominica',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'DNK',
	'Denmark',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'DOM',
	'Dominican Republic',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'DZA',
	'Algeria',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'ECU',
	'Ecuador',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'EGY',
	'Egypt',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'ERI',
	'Eritrea',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'ESH',
	'Western Sahara',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'ESP',
	'Spain',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'EST',
	'Estonia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'ETH',
	'Ethiopia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'FIN',
	'Finland',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'FJI',
	'Fiji',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'FLK',
	'Falkland Islands (Malvinas)',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'FRA',
	'France',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'FRO',
	'Faroe Islands',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'FSM',
	'Micronesia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'FXX',
	'France, Metropolitan',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'GAB',
	'Gabon',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'GBR',
	'United Kingdom',
	'3'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'GEO',
	'Georgia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'GHA',
	'Ghana',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'GIB',
	'Gibraltar',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'GIN',
	'Guinea',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'GLP',
	'Guadeloupe',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'GMB',
	'Gambia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'GNB',
	'Guinea-Bissau',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'GNQ',
	'Equatorial Guinea',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'GRC',
	'Greece',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'GRD',
	'Grenada',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'GRL',
	'Greenland',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'GTM',
	'Guatemala',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'GUF',
	'French Guiana',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'GUM',
	'Guam',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'GUY',
	'Guyana',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'HKG',
	'Hong Kong',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'HMD',
	'Heard/McDonald Isls.',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'HND',
	'Honduras',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'HRV',
	'Croatia (Hrvatska)',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'HTI',

	'Haiti',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'HUN',
	'Hungary',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'IDN',
	'Indonesia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'IND',
	'India',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'IOT',
	'British Indian Ocean Terr.',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'IRL',
	'Ireland',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'IRN',
	'Iran',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'IRQ',
	'Iraq',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'ISL',
	'Iceland',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'ISR',
	'Israel',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'ITA',
	'Italy',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'JAM',
	'Jamaica',
	'0'
)



INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'JOR',
	'Jordan',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'JPN',
	'Japan',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'KAZ',
	'Kazakhstan',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'KEN',
	'Kenya',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'KGZ',
	'Kyrgyzstan',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'KHM',
	'Cambodia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'KIR',
	'Kiribati',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'KNA',
	'Saint Kitts and Nevis',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'KOR',
	'Korea (South)',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'KWT',
	'Kuwait',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'LAO',
	'Lao',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'LBN',
	'Lebanon',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'LBR',
	'Liberia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'LBY',
	'Libyan Arab Jamahiriya',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'LCA',
	'Saint Lucia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'LIE',
	'Liechtenstein',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'LKA',
	'Sri Lanka',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'LSO',
	'Lesotho',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'LTU',
	'Lithuania',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'LUX',
	'Luxembourg',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'LVA',
	'Latvia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'MAC',
	'Macau',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'MAR',
	'Morocco',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'MCO',
	'Monaco',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'MDA',
	'Moldova',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'MDG',
	'Madagascar',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'MDV',
	'Maldives',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'MEX',
	'Mexico',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'MHL',
	'Marshall Islands',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'MKD',
	'Macedonia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'MLI',
	'Mali',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'MLT',
	'Malta',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'MMR',
	'Myanmar',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'MNG',
	'Mongolia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'MNP',
	'Northern Mariana Isls.',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'MOZ',
	'Mozambique',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'MRT',
	'Mauritania',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'MSR',
	'Montserrat',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'MTQ',
	'Martinique',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'MUS',
	'Mauritius',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'MWI',
	'Malawi',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'MYS',
	'Malaysia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'MYT',
	'Mayotte',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'NAM',
	'Namibia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'NCL',
	'New Caledonia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'NER',
	'Niger',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'NFK',
	'Norfolk Island',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'NGA',
	'Nigeria',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'NIC',
	'Nicaragua',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'NIU',
	'Niue',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'NLD',
	'Netherlands',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'NOR',
	'Norway',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'NPL',
	'Nepal',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'NRU',
	'Nauru',
	'0'
)



INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'NZL',
	'New Zealand',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'OMN',
	'Oman',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'PAK',
	'Pakistan',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'PAN',
	'Panama',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'PCN',
	'Pitcairn',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'PER',
	'Peru',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'PHL',
	'Philippines',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'PLW',
	'Palau',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'PNG',
	'Papua New Guinea',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'POL',
	'Poland',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'PRI',
	'Puerto Rico',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'PRK',
	'Korea (North)',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'PRT',
	'Portugal',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'PRY',
	'Paraguay',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'PYF',
	'French Polynesia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'QAT',
	'Qatar',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'REU',
	'Reunion',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'ROM',
	'Romania',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'RUS',
	'Russian Federation',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'RWA',
	'Rwanda',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'SAU',
	'Saudi Arabia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'SDN',
	'Sudan',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'SEN',
	'Senegal',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'SGP',
	'Singapore',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'SGS',
	'S Georgia/S Sandwich Isls.',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'SHN',
	'St. Helena',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'SJM',
	'Svalbard/Jan Mayen Isls.',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'SLB',
	'Solomon Islands',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'SLE',
	'Sierra Leone',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'SLV',
	'El Salvador',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'SMR',
	'San Marino',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'SOM',
	'Somalia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'SPM',
	'St. Pierre and Miquelon',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'STP',
	'Sao Tome and Principe',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'SUR',
	'Suri"Name"',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'SVK',
	'Slovak Republic',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'SVN',
	'Slovenia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'SWE',
	'Sweden',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'SWZ',
	'Swaziland',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'SYC',
	'Seychelles',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'SYR',
	'Syrian Arab Republic',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'TCA',
	'Turks and Caicos Islands',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'TCD',
	'Chad',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'TGO',
	'Togo',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'THA',
	'Thailand',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'TJK',
	'Tajikistan',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'TKL',
	'Tokelau',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'TKM',
	'Turkmenistan',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'TMP',
	'East Timor',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'TON',
	'Tonga',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'TTO',
	'Trinidad and Tobago',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'TUN',
	'Tunisia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'TUR',
	'Turkey',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'TUV',
	'Tuvalu',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'TWN',
	'Taiwan',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'TZA',
	'Tanzania',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'UGA',
	'Uganda',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'UKR',
	'Ukraine',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'UMI',
	'US Minor Outlying Islands',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'URY',
	'Uruguay',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'USA',
	'United States of America',
	'5'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'UZB',
	'Uzbekistan',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'VAT',
	'Vatican City State',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'VCT',
	'Saint Vincent/Grenadines',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'VEN',
	'Venezuela',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'VGB',
	'Virgin Islands (British)',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'VIR',
	'Virgin Islands (U.S.)',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'VNM',
	'Viet Nam',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'VUT',
	'Vanuatu',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'WLF',
	'Wallis and Futuna Islands',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'WSM',
	'Samoa',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'YEM',
	'Yemen',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'YUG',
	'Yugoslavia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'ZAF',
	'South Africa',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'ZAR',
	'Zaire',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'ZMB',
	'Zambia',
	'0'
);


INSERT INTO `Country`
(
	abbreviation,
	name,
	sortOrder
)
VALUES
(
	'ZWE',
	'Zimbabwe',
	'0'
);








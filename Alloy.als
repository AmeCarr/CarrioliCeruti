open util/integer

//-------------------------------------------------------------------SIGS--------------------------------------------------------------------------------

// Date and time of every reporting
sig TimeStamp{}

//Position of reportings and users
sig Position{

		latitude: one Int,
		longitude: one Int
}
//latitude >= -90 and latitude <= 90 and longitude >= -180 and longitude <= 180
{latitude >= -3 and latitude <= 3 and longitude >= -6 and longitude <= 6}

//String, name of private or authority
abstract sig Username{}

//String, only authotities have one
sig AuthorityID extends Username{}

//String, only private users have one
sig PrivateUsername extends Username{}

//Both privates and authorities have one
sig Email{}

//Both privates and authorities have one
sig Password{}

//String, every vehicle has one
sig LicensePlate{}

sig Vehicle{

	licensePlate: one LicensePlate
}

//Picture of parking reportings
sig Picture{}

sig Registration{

		password: one Password,
}

//Privates must make a Registration
sig PrivateRegistration extends Registration{
		
		privateUsername: one PrivateUsername,
		GPS_RequestResult: one Request_Result
}

//Authoritues must make a Registration
sig AuthorityRegistration extends Registration{
		
		authorityID: one AuthorityID
}

sig ReportingID{}

//Any tipe of reporting
abstract sig Reporting{
		
		reportingID: one ReportingID,
		position: one Position,
		timestamp: one TimeStamp,
		username: one Username,
		anonimity: one Anonimity_Request_Result
}

sig ParkingReporting extends Reporting{
		
		picture: lone Picture,
		licensePlate: lone LicensePlate
}

sig AccidentReporting extends Reporting{

		numCarsInvolved: Int,
		carsInvolved: set LicensePlate
}

sig SpeedReporting, TrafficLightReporting extends Reporting{

		licensePlate: lone LicensePlate
}


//User can be both private or authoritie
sig User{

		registration: one Registration,
		reportings: set Reporting,
		position: lone Position,
		email: one Email,
		see : Map
}

sig Private extends User{

		privateUsername: one PrivateUsername,
}

sig Authority extends User{

		authorityID: one AuthorityID,
		downloadedData: set ParkingReporting,
		uploadedData: set AccidentReporting
}

//Made at the sign up
sig GPS_Request {

		subjectOfRequest: one User
}

//Result of the GPS request
abstract sig Request_Result{

	request: one GPS_Request
}

one sig GPS_Request_Accepted extends Request_Result{}

one sig GPS_Request_Refused extends Request_Result{}

one sig Map{

		reportings: set Reporting
}

//made for every reporting
sig Anonimity_Request{

		reporting: one Reporting
}

abstract sig Anonimity_Request_Result{

		request: one Anonimity_Request
}

sig AnonimityTrue extends Anonimity_Request_Result{}

sig AnonimityFalse extends Anonimity_Request_Result{}

//--------------------------------------------------------------------- FACTS-------------------------------------------------------------------------

//All PrivateUsername have to be associated with a Private
fact UserNamePrivateConnection{

		all u: PrivateUsername | some p: Private | u in p.privateUsername
}

//All reportings are unique
fact UniqueReportings{

		no disjoint rep1, rep2: Reporting | rep1.reportingID = rep2.reportingID
}

//All AuthorityID have to be associated with a Authority
fact AuthorityIDAuthorityConnection{

		all ID: AuthorityID | some a: Authority | ID in a.authorityID
}


//All PrivateUsernames have to be associated to a PrivateRegistration
fact UsernameRegistrationConnection{

		all u: PrivateUsername | some p: PrivateRegistration | u in p.privateUsername
}

//All AuthorityID have to be associated to a AuthotityRegistration
fact AuthotityIDRegistrationConnection{
		
		all ID: AuthorityID | some a: AuthorityRegistration | ID in a.authorityID
}


//All Passwords have to be associated to a Registration
fact PasswordRegistrationConnection{

		all p: Password | some r: Registration | p in r.password
}

fact RegistrationUserConnection{
		all r:Registration | some u:User | r in u.registration
}

//Every Private has a unique Username
fact UniquePrivateUsername{

		no disjoint p1, p2: Private | p1.privateUsername = p2.privateUsername
}

//Every Authority has a unique AuthorityID
fact AuthorityUniqueAuthorityID{

		no disjoint a1, a2: Authority | a1.authorityID = a2.authorityID
}

//Every User has a unique Email
fact UserUniqueEmail{

		no disjoint u1, u2: User | u1.email = u2.email
}

//Every  request  can  be  either  accepted  or refused, not  both.  
fact GPS_requestAcceptedOrRefused{

		all GPS: GPS_Request | (some rr: Request_Result  | GPS in rr.request) and 
		(no disjoint rr1, rr2: Request_Result | GPS in rr1.request and GPS in rr2.request)
}

//All Reportings have to be associated with one and only one user
fact ReportingUniqueUser{

		all r: Reporting | some u: Username | u in r.username
}


//All reportings on map have to be anonymous or not, not both
fact ReportingAnonymousOrNot{

		all a: Anonimity_Request | (some arr: Anonimity_Request_Result  | a in arr.request) and 
		(no disjoint arr1, arr2: Anonimity_Request_Result | a in arr1.request and a in arr2.request)
}

//All GPS_request have to be associated with one user
fact GPS_requestOneUser{

		all GPS: GPS_Request | some u: User | u in GPS.subjectOfRequest
}

//All vehicles have one and only one license plate
fact vechicleUniqueLicensePlate{

		no disjoint vehicle1, vehicle2: Vehicle | vehicle1.licensePlate = vehicle2.licensePlate
}

//All reportings on the map correspond with all reportings done by the users
fact ReportingsOnMapEqualsToReportingsDone{

		all rep: Map.reportings | some reportings: User.reportings | reportings in rep
}


//There aren't two identical license plates in an accident reporting
fact DifferentLicensePlatesInAccidentReporting{

		no disjoint plate1, plate2: AccidentReporting.carsInvolved | plate1 = plate2
}

//The downloaded data from authorities correspond to parking reportings that are one the map
fact DownloadedDataPresentOnMap{

		all rep: Map.reportings | some data: Authority.downloadedData | data in rep
}

//A picture must be in one parking reporting
fact PictureInReporting{

		all pic: Picture | some p: ParkingReporting.picture  | pic in p
}

---------------------------------------------------------------ASSERTS---------------------------------------------------------------------


//A reporting can't be in two positions on the map (don't exist two reportings with same reportingID with different positions)
assert NoReportingInTwoPositions{

		no disjoint rep1, rep2: Reporting |  rep1.reportingID = rep2.reportingID and rep1.position = rep2.position
}

check NoReportingInTwoPositions for 5


//Two reportings can't have the same reportingID
assert ReportingsWithDifferentID{

		no disjoint r1, r2: Reporting | r1.reportingID = r2.reportingID
}

check ReportingsWithDifferentID for 5

//All Anonimity request have to be associate with one reporting
assert Anonimity_RequestOneReporting{

		all an: Anonimity_Request | some rep: Reporting | rep in an.reporting
}

check Anonimity_RequestOneReporting for 5

-----------------------------------------------------------------PREDICATES-------------------------------------------------------------------------------------------


pred world1{
		
		#Private = 1
		#Authority = 1
		#Reporting = 0
	
}

run world1 for 5


pred world2{

		#Private = 0
		#Reporting = 3
		#Authority = 1
}

run world2 for 3

pred world3{
	
		#Authority = 3
		#Private = 3
		#Reporting = 3
}

run world3 for 6

open util/integer
open util/boolean


//-------------------------------------------------------------------SIGS--------------------------------------------------------------------------------

// Date and time of every reporting
sig TimeStamp{

	date: set Int,
	time: set Int
}

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

//Data that were downloaded by authorities
sig DownloadedData{}

//Data that were uploaded by authorities
sig UploadedData{}

//Picture of parking reportings
sig Picture{}

sig Registration{

		password: one Password
}

//Privates must make a Registration
sig PrivateRegistration extends Registration{
		
		privateUsername: one PrivateUsername
}

//Authoritues must make a Registration
sig AuthorityRegistration extends Registration{
		
		authorityID: one AuthorityID
}

//Any tipe of reporting
sig Reporting{
		
		reportingID: String,
		position: one Position,
		timestamp: one TimeStamp,
		username: one Username,
		anonimity: one Anonimity
}

sig ParkingReporting extends Reporting{
		
		picture: lone Picture,
}

sig AccidentReporting extends Reporting{

		numCarsInvolved: set Int,
		carInvolved: set LicensePlate
}

sig SpeedReporting, TrafficLightReporting extends Reporting{}

//User can be both private or authoritie
sig User{

		registration: one Registration,
		position: lone Position,
		email: one Email
}

sig Private extends User{

		privateUsername: one PrivateUsername,
		reportings: set Reporting
}

sig Authority extends User{

		authorityID: one AuthorityID,
		downloadedData: set DownloadedData,
		uploadedData: set UploadedData
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

sig Suggestion{}

sig Map{

		reportings: set Reporting
}

sig ColoredArea{}

abstract sig Anonimity{}

sig True extends Anonimity{}

sig Talse extends Anonimity{}
//------------------------------------------------------------------------- FACTS-------------------------------------------------------------------------

//All PrivateUsername have to be associated with a Private
fact UserNamePrivateConnection{

		all u: PrivateUsername | some p: Private | u in p.privateUsername
}

//All AuthorityID have to be associated with a Authority
fact AuthorityIDAuthorityConnection{

		all ID: AuthorityID | some a: Authority | ID in a.authorityID
}


//All Usernames have to be associated to a PrivateRegistration
fact UsernameRegistrationConnection{

		all u: PrivateUsername | some p: PrivateRegistration | u in p.privateUsername
}

//All AuthorityID have to be associated to a PrivateRegistration
fact AuthotityIDRegistrationConnection{
		
		all ID: AuthorityID | some a: AuthorityRegistration | ID in a.authorityID
}


//All Passwords have to be associated to a Registration
fact PasswordRegistrationConnection{

		all p: Password | some r: Registration | p in r.password
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

//All Reportings have to be associated with a user
fact ReportingUniqueUser{

		all r: Reporting | some u: Username | u in r.username
}






























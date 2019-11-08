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

//String, only private users have one
sig Username{}

//Both privates and authorities have one
sig Email{}

//Both privates and authorities have one
sig Password{}

//String, only authotities have one
sig AuthorityID{}

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
		
		username: one Username
}

//Authoritues must make a Registration
sig AuthorityRegistration extends Registration{
		
		authorityID: one AuthorityID
}

//Any tipe of reporting
sig Reporting{

		position: one Position,
		timestamp: one TimeStamp,
		username: one Username
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

		username: one Username,
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
abstract sig Request_Result {

	request: one GPS_Request
}

one sig GPS_Request_Accepted extends Request_Result{}

one sig GPS_Request_Refused extends Request_Result{}

//------------------------------------------------------------------------- FACTS-------------------------------------------------------------------------

//All UserName have to be associated with a Private
fact UserNamePrivateConnection{

		all u: Username | some p: Private | u in p.username
}

//All AuthorityID have to be associated with a Authority
fact AuthorityIDAuthorityConnection{

		all ID: AuthorityID | some a: Authority | ID in a.authorityID
}


//All Usernames have to be associated to a PrivateRegistration
fact UsernameRegistrationConnection{

		all u: Username | some p: PrivateRegistration | u in p.username
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
fact PrivateUniqueUsername{

		no disj p1, p2: Private | p1.username = p2.username
}

//Every Authority has a unique AuthorityID
fact AuthorityUniqueAuthorityID{

		no disj a1, a2: Authority | a1.authorityID = a2.authorityID
}

//Every User has a unique Email
fact UserUniqueEmail{

		no disj u1, u2: User | u1.email = u2.email
}






























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

//Both privates and authorities must make one
sig Registration{
		
		username: one Username,
		password: one Password

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
abstract sig User{

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

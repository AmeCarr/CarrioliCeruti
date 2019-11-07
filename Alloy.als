open util/integer

open util/boolean


sig TimeStamp{

	date: set Int,
	time: set Int
}

sig Position{

		latitude: one Int,
		longitude: one Int
}

sig Username{}

sig Email{}

sig Password{}

sig AuthorityID{}

sig DownloadedData{}

sig UploadedData{}

sig Registration{
		
		username: one Username,
		password: one Password

}

sig Reporting{

		position: one Position,
		timestamp: one TimeStamp,
		username: one Username 
}

abstract sig User{

		registration: one Registration,
		position: one Position,
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

		
		

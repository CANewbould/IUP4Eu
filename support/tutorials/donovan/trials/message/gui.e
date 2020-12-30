namespace g

public include iup/iup.e
public include iup/iup_config.e
	IupOpen(0,{})
	
public function message( sequence title, sequence message )

	IupMessage( title, message )


	return 1
end function

public function alarm(object title = NULL, object message = NULL, object b1 = NULL, object b2 = NULL, object b3 = NULL )


	atom result = IupAlarm( title, message, b1, b2, b3 )

	return result
end function


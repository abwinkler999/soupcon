soupcon
=======

There is an OS X recipe viewer application called "YummySoup".  It can export to an idiosyncratic XML file format
called Plist.

Soupcon is a web application built with Sinatra to browse a YummySoup database.

It is deployed at soupcon.herokuapp.com.

TO DO LIST

* restructure views in partials, with tabs along top and index or recipe displayed below

* at the moment, input is in a flat XML file read in with Plist.  Application would be a great deal more
robust if it were upgraded to use a PostgreSQL database instead.
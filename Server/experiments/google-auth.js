var google = require('googleapis');
var plus = google.plus('v1');
var OAuth2 = google.auth.OAuth2;
const CLIENT_ID = "32596942715-55efrjhgepaqloiaoakaua1eoin9n9cp.apps.googleusercontent.com"
//"672822966449-efaa1229enfq2o5kfbbr1p82k7vdacm5.apps.googleusercontent.com";
const CLIENT_SECRET = "eJ2XyXoAUl5eF9fzy4SX3qwf";
var oauth2Client = new OAuth2(CLIENT_ID, CLIENT_SECRET);

// Retrieve tokens via token exchange explained above or set them:
oauth2Client.setCredentials({
  access_token:   'ya29.PwKHlTsQ-MNhgkQU4o9kTbctpIbx7TPcFSbMkKdcIkYXKToUiD7QsmZow-gdNxMBeyL4',
  refresh_token:  '1/O5maj_aFiGSgqu9XsHqOKYHNkoKMUhaoPtV65s42tjo'
});

plus.people.get({ userId: 'me', auth: oauth2Client }, function(err, response) {
  // handle err and response
  console.log(err);
  console.log(response);
});
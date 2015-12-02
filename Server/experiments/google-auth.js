var GoogleAuth = require('google-auth-library');

// Get the environment configured authorization
(new GoogleAuth).getApplicationDefault(function(err, authClient) {
  if (err === null) {
    // Inject scopes if they have not been injected by the environment
    if (authClient.createScopedRequired && authClient.createScopedRequired()) {
      var scopes = [  
      	'https://www.googleapis.com/auth/plus.login',
  		'https://www.googleapis.com/auth/plus.profile.emails.read'
      ];
      authClient = authClient.createScoped(scopes);
    }

    // Fetch the access token
    var _ = require(lodash);
    var optionalUri = null;  // optionally specify the URI being authorized
    var reqHeaders = {};

    authClient.getRequestMetadata(optionalUri, function(err, headers) {
      if (err === null) {
        // Use authorization headers
        reqHeaders = _.merge(allHeaders, headers);
      }
      console.log(err);
      console.log(headers);
    });
  }
});

//ALTER TABLE `Porcelain`.`Bathrooms` CHANGE COLUMN `Longitude` `Longitude` FLOAT(28,21) NOT NULL , CHANGE COLUMN `Latitude` `Latitude` FLOAT(28,21) NOT NULL;

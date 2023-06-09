function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    apiUrl: 'https://api.realworld.io/api/'
  }
  if (env == 'dev') {
    config.userEmail = 'Lifemiles1@gmail.com'
    config.userPassword = 'Lifemiles1'
  }
  if (env == 'qa') {
    config.userEmail = 'Lifemiles1@gmail.com'
    config.userPassword = 'Lifemiles1'
  }

  var accessToken = karate.callSingle('classpath:helpers/CreateToken.feature',config).authToken
  karate.configure('headers',{Authorization: 'Token ' + accessToken})

  return config;
}
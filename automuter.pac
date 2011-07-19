 function FindProxyForURL(url, host) {
 
    //return "PROXY localhost:8123";

  //if (shExpMatch(host, ".hulu.com"))
  if (shExpMatch(url, "http://t2.hulu.com"))
  //if (shExpMatch(url, "http://*.hulu.com"))
  {
    return "PROXY localhost:8123";
  }
  return "DIRECT";
}

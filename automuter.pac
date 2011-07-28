 function FindProxyForURL(url, host) {
 
  if (shExpMatch(host, "t2.hulu.com"))
  {
    return "PROXY localhost:8123";
  }
  return "DIRECT";
}

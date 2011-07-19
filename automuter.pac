 function FindProxyForURL(url, host) {
  // our local URLs from the domains below example.com don't need a proxy:
  if (shExpMatch(host, "*.hulu.com"))
  {
    return "PROXY localhost:8123";
  }
  // All other requests go through port 8080 of proxy.example.com.
  // should that fail to respond, go directly to the WWW:
  return "DIRECT";
}

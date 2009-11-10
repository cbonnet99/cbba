backend bam_site {
     .host = "localhost";
     .port = "8080";
 }

sub vcl_recv {
 set req.backend = bam_site;
 if (req.http.Cache-Control ~ "must-revalidate") {
     purge_url(req.url);
 }
 if (req.request == "GET" && (req.http.host == "staging.beamazing.co.nz:6081" || req.http.host == "staging.beamazing.co.nz")) {
 	 #set req.http.X-Cyrille-Varnish-Debug1 = "1";
 	 unset req.http.cookie;
     unset req.http.Authorization;
     lookup;
 }
 if (req.request == "POST") {
     pass;
 }
 if (req.request != "GET" && req.request != "HEAD" &&
     req.request != "PUT" && req.request != "POST" &&
     req.request != "TRACE" && req.request != "OPTIONS" &&
     req.request != "DELETE") {

     # Non-RFC2616 or CONNECT which is weird. #
     pass;
 }
 if (req.http.Authorization) {
     # Not cacheable by default #
     pass;
 }
 lookup;
}
sub vcl_fetch {
 if (req.request == "GET" && (req.http.host == "staging.beamazing.co.nz:6081" || req.http.host == "staging.beamazing.co.nz")) {
	 #set obj.http.X-Cyrille-Varnish-Debug2 = "1";
     unset obj.http.Set-Cookie;
     set obj.ttl = 5m;
     deliver;
 }
 if (obj.status >= 300) {
     pass;
 }
 if (!obj.cacheable) {
     pass;
 }
 if (obj.http.Set-Cookie) {
     pass;
 }
 if(obj.http.Pragma ~ "no-cache" ||
    obj.http.Cache-Control ~ "no-cache" ||
    obj.http.Cache-Control ~ "private") {
         pass;
 }
 if (obj.http.Cache-Control ~ "max-age") {
     unset obj.http.Set-Cookie;
     deliver;
 }
 pass;

}
sub vcl_deliver {
	unset resp.http.Server; 
        if (obj.hits > 0) {
                set resp.http.X-Cache = "HIT";
        } else {
                set resp.http.X-Cache = "MISS";
        }
}
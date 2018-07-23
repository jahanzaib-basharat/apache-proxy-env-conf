# Apache Proxy

## The file proxy.conf is populated by the ENVIRONMENT VARIABLES. Examples:

	docker run --name=proxy -e PROXY_PASS_1_SOURCE=/wiki1 -e PROXY_PASS_1_TARGET=http://wiki/wiki1/ -e PROXY_PASS_2_SOURCE=/wiki2 -e PROXY_PASS_2_TARGET=http://wiki/wiki2/ -e PROXY_PASS_3_SOURCE=/wiki3 -e PROXY_PASS_3_TARGET=http://wiki/wiki3/ -e PROXY_MATCH_1_SOURCE='^/extensions/(.*)$' -e PROXY_MATCH_1_TARGET='http://wiki/wiki/extensions/$1' -p 80:80 proxy

	docker run -e PROXY_PASS_1_SOURCE=/wiki1 -e PROXY_PASS_1_TARGET=http://wiki/wiki1/ -e PROXY_MATCH_1_SOURCE="^/extensions/(.*)$" -e PROXY_MATCH_1_TARGET="http://wiki/wiki/extensions/$1" -p 80:80 proxy

	docker run -e PROXY_PASS_1_SOURCE=/wiki1 -e PROXY_PASS_1_TARGET=http://wiki/wiki1/ -e PROXY_PASS_2_SOURCE=/wiki2 -e PROXY_PASS_2_TARGET=http://wiki/wiki2/ -p 80:80 proxy

	docker run -e PROXY_PASS_1_SOURCE=/wiki1 -e PROXY_PASS_1_TARGET=http://wiki/wiki1/ -p 80:80 proxy

These examples can generate a configuration like this in the file prox.conf:

	ProxyPreserveHost On (this is by default)
	ProxyPass /wiki1 http://wiki/wiki1/
	ProxyPassReverse /wiki1 http://wiki/wiki1/
	ProxyPass /wiki2 http://wiki/wiki2/
	ProxyPassReverse /wiki2 http://wiki/wiki2/
	ProxyPass /wiki3 http://wiki/wiki3/
	ProxyPassReverse /wiki3 http://wiki/wiki3/
	ProxyPassMatch ^/extensions/(.*)$ http://wiki/wiki/extensions/$1

So, for every mapping you have to set a couple of values:

	* PROXY_PASS_1_SOURCE
	* PROXY_PASS_1_TARGET

The numbering is vital for the correct functionality of the script that generates the configuration.

### Docker Compose 
Using docker-compose you can set the variables like this:

	services:
		myproxy:
			environment:
				PROXY_PASS_1_SOURCE: /wiki
				PROXY_PASS_1_TARGET: http://mywiki/wiki

#### ProxyPassMatch

You can also set rules of type "ProxyPassMatch". For doing it you can sent the variables like this:

	services:
		myproxy:
			environment:
				PROXY_MATCH_1_SOURCE: '^/extensions/(.*)$$'
                PROXY_MATCH_1_TARGET: 'http://smwiki/wiki/extensions/$$1'
                PROXY_MATCH_2_SOURCE: '^/resources/(.*)$$'
                PROXY_MATCH_2_TARGET: 'http://smwiki/wiki/resources/$$1'

> Quotes are important. The double DOLLAR ($) is necessary.
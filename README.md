# DelphiWebDriver
An attempt at building a Delphi implementation of the [W3C WebDriver](https://www.w3.org/TR/webdriver), so it can be embedded in a Delphi project

Essentially a proof of concept / futile excerise.

## Currently Supported APIs

| HTTP   	| Path                                              	| Status      |
| ---	| ---	| --- |
| GET    	| /status                                           	| Functional  |
| POST   	| /session                                          	| Functional  |
| GET     | /session/:sessionId                                 | Functional  |
| GET     | /session/:sessionId/title                         	| In Progress |
| GET     | /session/:sessionId/element/:id                     | In Progress |
| POST    | /session/:sessionId/elements                        | Initial |
| POST    | /session/:sessionId/element                         | Initial |
| GET     | /session/:sessionId/screenshot                      | Initial     |
| POST    | /session/:sessionId/element/:id/click               | In Progress |
| POST    | /session/:sessionId/timeouts/implicit_wait          | In Progress |
| POST    | /session/:sessionId/timeouts                        | In Progress |
| GET     | /sessions                                           | In Progress |
| DELETE  | /session/:sessionId                                 | Functional  |
| POST    | /session/:sessionId/back                          	| Not implemented |
| POST    | /session/:sessionId/forward                       	| Not implemented |
| GET     | /session/:sessionId/source                          | Not implemented |
| POST    | /session/:sessionId/url                             | Not implemented |
| POST    | /session/:sessionId/appium/app/launch             	| Not implemented? |
| POST    | /session/:sessionId/appium/app/close              	| Not implemented? |
| GET     | /session/:sessionId/window                          | In Progress |

NOTES:
* Functional here means it has been at least partially implemented in both a host and a test client
* Not Implemented commands are those that are usually to do with navigation, etc. in a browser

## To been implemented

| HTTP | Path |
| --- | --- |
| GET    	| /sessions                                         	|
| POST   	| /session/:sessionId/buttondown                    	|
| POST   	| /session/:sessionId/buttonup                      	|
| POST   	| /session/:sessionId/click                         	|
| POST   	| /session/:sessionId/doubleclick                   	|
| POST   	| /session/:sessionId/element/active                	|
| GET    	| /session/:sessionId/element/:id/attribute/:name   	|
| POST   	| /session/:sessionId/element/:id/clear             	|
| POST   	| /session/:sessionId/element/:id/click             	|
| GET    	| /session/:sessionId/element/:id/displayed         	|
| GET    	| /session/:sessionId/element/:id/element           	|
| GET    	| /session/:sessionId/element/:id/elements          	|
| GET    	| /session/:sessionId/element/:id/enabled           	|
| GET    	| /session/:sessionId/element/:id/equals            	|
| GET    	| /session/:sessionId/element/:id/location          	|
| GET    	| /session/:sessionId/element/:id/location_in_view  	|
| GET    	| /session/:sessionId/element/:id/name              	|
| GET    	| /session/:sessionId/element/:id/screenshot        	|
| GET    	| /session/:sessionId/element/:id/selected          	|
| GET    	| /session/:sessionId/element/:id/size              	|
| GET    	| /session/:sessionId/element/:id/text              	|
| GET           | /session/:sessionId/element/:id/rect                  |
| POST   	| /session/:sessionId/element/:id/value             	|
| POST   	| /session/:sessionId/keys                          	|
| GET    	| /session/:sessionId/location                      	|
| POST   	| /session/:sessionId/moveto                        	|
| GET    	| /session/:sessionId/orientation                   	|
| GET    	| /session/:sessionId/screenshot                    	|
| GET    	| /session/:sessionId/title                         	|
| POST   	| /session/:sessionId/touch/click                   	|
| POST   	| /session/:sessionId/touch/doubleclick             	|
| POST   	| /session/:sessionId/touch/longclick               	|
| POST   	| /session/:sessionId/touch/flick                   	|
| POST   	| /session/:sessionId/touch/scroll                  	|
| DELETE 	| /session/:sessionId/window                        	|
| POST   	| /session/:sessionId/window                        	|
| GET    	| /session/:sessionId/window/handles                	|
| POST   	| /session/:sessionId/window/maximize               	|
| POST   	| /session/:sessionId/window/size                   	|
| GET    	| /session/:sessionId/window/size                   	|
| POST   	| /session/:sessionId/window/:windowHandle/size     	|
| GET    	| /session/:sessionId/window/:windowHandle/size     	|
| POST   	| /session/:sessionId/window/:windowHandle/position 	|
| GET    	| /session/:sessionId/window/:windowHandle/position 	|
| POST   	| /session/:sessionId/window/:windowHandle/maximize 	|
| GET    	| /session/:sessionId/window_handle                 	|
| GET    	| /session/:sessionId/window_handles                	|


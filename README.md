# DelphiWebDriver
An attempt at building a Delphi implementation of the [W3C WebDriver](https://www.w3.org/TR/webdriver), so it can be embedded in a Delphi project

Essentially a proof of concept / futile excerise.

## Currently Supported APIs

| HTTP   	| Path                                              	| Status      |
|--------	|---------------------------------------------------	|             |
| GET    	| /status                                           	| Functional  |
| POST   	| /session                                          	| Functional  |
| GET     | /session/:sessionId                                 | Functional  |
| GET    	| /session/:sessionId/title                         	| In Progress |
| GET     | /session/:sessionId/element/:id                     | In Progress |
| GET     | /session/:sessionId/screenshot                      | Initial     |
| POST    | /session/:sessionId/element/:id/click               | In Progress |
| POST    | /session/:sessionId/timeouts/implicit_wait          | In Progress |
| POST    | /session/:sessionId/timeouts                        | In Progress |
| GET     | /sessions                                           | In Progress |

NOTE: /session/:sessionId/element/:id/click is functional for TButton controls


